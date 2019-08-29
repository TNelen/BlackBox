import 'package:blackbox/Constants.dart';
import 'package:blackbox/DataContainers/GroupData.dart';
import 'package:blackbox/DataContainers/UserData.dart';
import 'package:blackbox/DataContainers/Issue.dart';
import '../DataContainers/Question.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Interfaces/Database.dart';

import 'FirebaseUtility.dart';

class FirebaseSetters {

  static Future< bool > voteOnUser(GroupData groupData, String voteeID) async {

    await Firestore.instance.runTransaction((Transaction transaction) async {
      DocumentReference groupRef = Firestore.instance
                                    .collection("groups")
                                    .document( groupData.getGroupCode() );
      
      DocumentSnapshot ds = await transaction.get( groupRef );
    
      /// Initialize lists
      Map<dynamic, dynamic> dbData = ds.data['newVotes'];
      Map<String, int> convertedData = new Map<String, int>();

      /// Loop the database Map and add values as Strings to the data Map
      dbData.forEach( (key, value) {
        convertedData[key.toString()] = value;
      } );

      if (convertedData.containsKey( voteeID ))
        convertedData[voteeID] += 1;
      else convertedData[voteeID] = 1;

      Map<String, dynamic> upd = new Map<String, dynamic>();
      upd['newVotes'] = convertedData;

      await transaction.update(groupRef, upd);

    });

    return true;

  }

  static Future< bool > voteOnQuestion(Question q) async
  {
    /// Perform checks
    if (q.getCategoryAsCategory() != Category.Community)
      return false;
    
    if (q.getQuestionID() == null || q.getQuestionID() == "")
      return false;

    bool isSuccess;

    await Firestore.instance.runTransaction((Transaction transaction) async {
      DocumentReference qRef = Firestore.instance
                                    .collection("questions")
                                    .document( q.getQuestionID() );
      
      DocumentSnapshot ds = await transaction.get( qRef );
    
      if (ds.exists) {
        /// Get current document votes and update
        int currentVotes = ds.data['votes'];
        int newVotes;

        if (currentVotes != null) {
          newVotes = currentVotes + 1;
        } else {
          newVotes = 1;
        }

        /// Add the data to be saved
        Map<String, dynamic> upd = new Map<String, dynamic>();
        upd['votes'] = newVotes;

        /// Perform transaction
        await transaction.update(qRef, upd);
        isSuccess = true;
      } else {
        isSuccess = false;
      }
    });

    return isSuccess;

  }


  static Future< bool > updateGroup(GroupData groupData) async {
    String code = groupData.getGroupCode();
    String userID = Constants.getUserID();

    await Firestore.instance.runTransaction((Transaction transaction) async {

      /// Get up-to-date data
      GroupData freshData;
      DocumentReference docRef = Firestore.instance.collection("groups").document( code );
      DocumentSnapshot snap = await transaction.get( docRef );
      
      if (snap.exists)
        freshData = new GroupData.fromDocumentSnapshot( snap );
      else
        freshData = groupData;
      

      var data = new Map<String, dynamic>();
      data['admin'] = groupData.getAdminID();

      ///
      /// Handle members
      /// 
      
      Map<String, dynamic> newMemberList = new Map<String, dynamic>();
      /// Get members from database or local GroupData 
      if (freshData.getMembersAsMap() != null) {
        newMemberList = freshData.getMembersAsMap();
      } else 
        newMemberList = groupData.getMembersAsMap();

      /// Add user if he is still a member
      /// If user is in both lists, the username will just be updated 
      if (groupData.getMembersAsMap().containsKey( userID ))
      {
        newMemberList[ userID ] = Constants.getUsername();
      } else {
        newMemberList.remove( userID );
      }

      data['members'] = newMemberList;

      ///
      /// Handle isPlaying
      /// 
      
      List<String> newList = new List<String>();
      /// Get playing data from database or local GroupData
      if (freshData.getPlaying() != null)
        newList = freshData.getPlaying();
      else
        newList = groupData.getPlaying();

      if ( groupData.getPlaying().contains( userID ) && ! ( newList.contains(userID) ) )
      {
        newList.add( userID );
      } else if ( ! groupData.getPlaying().contains( userID )) {
        newList.remove( userID );
      }

      data['playing'] = newList;

      
      
      ///
      /// Handle votes -> Always get most up-to-date values!
      /// Unless it is a new group, the data does not exist or a question transfer is in progress!
      /// 
      


      /// If user is admin -> Overwrite permissions!
      if ( freshData.getAdminID() == Constants.getUserID() || freshData.getQuestion() == null)
      {
        data['name'] = groupData.getName();
        data['description'] = groupData.getDescription();

        data['nextQuestion'] = groupData.getQuestion().getQuestion();
        data['nextQuestionID'] = groupData.getQuestion().getQuestionID();
        data['nextQuestionCategory'] = groupData.getQuestion().getCategory();
        data['nextQuestionCreatorID'] = groupData.getQuestion().getCreatorID();
        data['nextQuestionCreatorName'] = groupData.getQuestion().getCreatorName();

        data['lastQuestion'] = groupData.getLastQuestion().getQuestion() ?? "";
        data['lastQuestionID'] = groupData.getLastQuestion().getQuestionID() ?? "";
        data['lastQuestionCategory'] = groupData.getLastQuestion().getCategory() ?? "Default";
        data['lastQuestionCreatorID'] = groupData.getLastQuestion().getCreatorID() ?? "";
        data['lastQuestionCreatorName'] = groupData.getLastQuestion().getCreatorName() ?? "";
      } else {  /// Otherwise: use current data
        data['name'] = freshData.getName();
        data['description'] = freshData.getDescription();

        data['nextQuestion'] = freshData.getQuestion().getQuestion();
        data['nextQuestionID'] = freshData.getQuestion().getQuestionID();
        data['nextQuestionCategory'] = freshData.getQuestion().getCategory();
        data['nextQuestionCreatorID'] = freshData.getQuestion().getCreatorID();
        data['nextQuestionCreatorName'] = freshData.getQuestion().getCreatorName();

        data['lastQuestion'] = freshData.getLastQuestion().getQuestion() ?? "";
        data['lastQuestionID'] = freshData.getLastQuestion().getQuestionID() ?? "";
        data['lastQuestionCategory'] = freshData.getLastQuestion().getCategory() ?? "Default";
        data['lastQuestionCreatorID'] = freshData.getLastQuestion().getCreatorID() ?? "";
        data['lastQuestionCreatorName'] = freshData.getLastQuestion().getCreatorName() ?? "";
      }


      bool transfer = (Constants.getUserID() == groupData.getAdminID() && freshData.getQuestion() != null
                        && freshData.getQuestion().getQuestionID() == groupData.getLastQuestion().getQuestionID())
                        || (freshData.getQuestion() == null);

       /// Handle last votes 
      if (freshData.getLastVotes() == null || transfer)
        data['lastVotes'] = groupData.getLastVotes();
      else 
        data['lastVotes'] = freshData.getLastVotes();

      /// Handle new votes
      if (freshData.getNewVotes() == null || transfer)
        data['newVotes'] = groupData.getNewVotes();
      else 
        data['newVotes'] = freshData.getNewVotes();

      /// Handle total votes
      if (freshData.getTotalVotes() == null || transfer)
        data['totalVotes'] = groupData.getTotalVotes();
      else 
        data['totalVotes'] = freshData.getTotalVotes();

      /// Add the new data
      await transaction.set(docRef, data);

      });

    return true;

  }


  static Future< bool > updateUser(UserData userData) async {
    String uniqueID = userData.getUserID();
      
    var data = new Map<String, dynamic>();
    data['name'] = userData.getUsername();

    await Firestore.instance.runTransaction((Transaction transaction) async {
      DocumentReference docRef = Firestore.instance.collection("users").document( uniqueID );
      transaction.set(docRef, data);
    });

    return true;
  }


  static Future< bool > updateQuestion( Question question ) async
  {
    /// Return false if the question is a duplicate (same ID doesn't count as duplicate)
    if ( await FirebaseUtility.hasIdenticalQuestion( question ))
    {
      return false;
    }


    /// Start storing local data
    var data = new Map<String, dynamic>();
    data['question'] = question.getQuestion();
    data['category'] = question.getCategory();
    data['creatorID'] = question.getCreatorID();
    data['creatorName'] = question.getCreatorName();


    /// Get a unique question ID or get the current one
    String uniqueID;
    if (question.getQuestionID() != null)
      uniqueID = question.getQuestionID();
    else 
      uniqueID = "";
    
    if (uniqueID == "")
    {
      uniqueID = await FirebaseUtility.generateUniqueQuestionCode();
    }

    bool doesQuestionIDExist = await FirebaseUtility.doesQuestionIDExist( question );

    /// Update the question document
    await Firestore.instance.runTransaction((Transaction transaction) async {      

      if (doesQuestionIDExist)
      {
        /// get current reports
        DocumentReference reportRef = Firestore.instance
                                      .collection("questions")
                                      .document( uniqueID );

        DocumentSnapshot reports = await transaction.get( reportRef );
        /// Add them to the data map
        if (reports.data['categoryReports'] != null)
          data['categoryReports'] = reports.data['categoryReports'];
        if (reports.data['disturbingReports'] != null)
          data['disturbingReports'] = reports.data['disturbingReports'];
        if (reports.data['grammarReports'] != null)
          data['grammarReports'] = reports.data['grammarReports'];
        if (reports.data['votes'] != null && reports.data["category"] == Question.getStringFromCategory( Category.Community ))
          data['votes'] = reports.data['votes'];
      }


      /// Save question
      DocumentReference qRef = Firestore.instance
                .collection("questions")
                .document( uniqueID );

      await transaction.set(qRef, data);
    });

    /// Save question to the lists
    Question q = new Question(uniqueID, question.getQuestion(), question.getCategoryAsCategory(),question.getCreatorID(), question.getCreatorName());
    List<Category> categories = new List<Category>();
    categories.add( Category.Any );
    categories.add( question.getCategoryAsCategory() );

    await _saveQuestionToList( q, categories );
    
    return true;

  }

  /// Saves a question to the lists of the given categories
  /// The question will be removed from other arrays it is listed in. 
  /// Will create a list if none exists yet
  static Future< void > _saveQuestionToList (Question question, List<Category> categories) async
  {

    /// Update the question list
    await Firestore.instance.runTransaction((Transaction transaction) async {
      
      /// Update question list
      DocumentReference listRef = Firestore.instance
                  .collection("questions")
                  .document( "questionList" );

      DocumentSnapshot doc = await transaction.get( listRef );

      Map<String, dynamic> newData = new Map<String, dynamic>(); 

      /// Update every relevant category list
      for (Category cat in Question.getCategoriesAsList())
      {

        /// Get the category as String
        String category = Question.getStringFromCategory( cat );

        /// Get the current List or create a new one
        List<String> questions;
        if (doc.data[ category ] != null)
        {
          List< dynamic > current = doc.data[ category ];
          questions = current.cast<String>().toList();
        } else {
          questions = new List<String>();
        }

        /// If the question SHOULD be in this list
        if (categories.contains(cat)) {

          if ( ! questions.contains( question.getQuestionID() ))
          {
            questions.add( question.getQuestionID() );
          }

          /// Set the new list
          newData[ category ] = questions;
        } 
        /// If the question should NOT be in this list
        else {
          /// Update the list
          questions.remove( question.getQuestionID() );

          /// Set the new list
          newData[ category ] = questions;
        }
      }


      await transaction.update(listRef, newData );


    });
  }


  static Future< bool > reportQuestion(Question question, ReportType reportType) async
  {
      bool updateComplete = false;

      /// Get basic question information
      var data = new Map<String, dynamic>();
      data['question'] = question.getQuestion();
      data['category'] = question.getCategory();
      data['creatorID'] = question.getCreatorID();
      data['creatorName'] = question.getCreatorName();

      /// start of transaction
      await Firestore.instance.runTransaction((Transaction transaction) async {

        DocumentReference docRef = Firestore.instance
                                    .collection("questions")
                                    .document( question.getQuestionID() );

        /// Get the amount of current reports for each type
        DocumentSnapshot live = await transaction.get( docRef );
        

        data['categoryReports'] = 0;
        data['grammarReports'] = 0;
        data['disturbingReports'] = 0;
        if (live.exists) {
          /// Get basic info from database, if existant
          if (live.data['question'] != null)
            data['question'] = live.data['question'];

          if (live.data['category'] != null)
            data['category'] = live.data['category'];

          if (live.data['creatorID'] != null)
            data['creatorID'] = live.data['creatorID'];

          if (live.data['creatorName'] != null)
            data['creatorName'] = live.data['creatorName'];



          if (live.data['categoryReports'] != null)
            data['categoryReports'] = live.data['categoryReports'];
          
          if (live.data['grammarReports'] != null)
            data['grammarReports'] = live.data['grammarReports'];

          if (live.data['disturbingReports'] != null)
            data['disturbingReports'] = live.data['disturbingReports'];
        
          switch (reportType) {
            case ReportType.CATEGORY:
              data['categoryReports'] = data['categoryReports'] + 1;
              break;
            case ReportType.GRAMMAR:
              data['grammarReports'] = data['grammarReports'] + 1;
              break;
            case ReportType.DISTURBING:
              data['disturbingReports'] = data['disturbingReports'] + 1;
              break;
          }     

          updateComplete = true;
          await transaction.set(docRef, data);

        } else {
          updateComplete = false;
        }

      });

    return updateComplete;

  }

  static Future< bool > submitIssue(Issue issue) async {
    var data = new Map<String, dynamic>();
    data['category'] = issue.category;
    data['location'] = issue.location;
    data['version'] = issue.version;
    data['description'] = issue.description;
    data['submitter'] = Constants.getUserID();

    await Firestore.instance.collection("issues").add( data );
    return true;
  }
}