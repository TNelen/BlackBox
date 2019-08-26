import 'package:blackbox/Constants.dart';
import 'package:blackbox/DataContainers/GroupData.dart';
import 'package:blackbox/DataContainers/UserData.dart';
import 'package:blackbox/Exceptions/GroupNotFoundException.dart';
import '../DataContainers/Question.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Interfaces/Database.dart';
import 'dart:math';

/// For documentation: please check interfaces/Database.dart
class Firebase implements Database{

  /// Singleton pattern
  static final Firebase _firebase = new Firebase._internal();

  factory Firebase() {
    return _firebase;
  }

  Firebase._internal();


  /// -----------
  /// Connections
  /// -----------

  /// Not needed when using Firebase
  @override
  void openConnection(){}

  /// Not needed when using Firebase
  @override
  void closeConnection(){}


  /// -------
  /// Getters
  /// -------


  @override
  @Deprecated('Please use FirebaseStream instead!')
  Future< GroupData > getGroupFromUser(UserData userData) async
  {

    try {
      var result = Firestore.instance
          .collection("groups")
          .where("members", arrayContains: userData.getUserID())
          .snapshots();
      
      await for (final data in result){
          // Handle all documents one by one
          for (final DocumentSnapshot ds in data.documents)
          {

            Map<String, String> members = new Map<String, String>();
            members = ds.data['members'];

            if (ds.data['name'] == null || ds.data['description'] == null || ds.data['admin'] == null || members.length == 0)
            {
              // In this case, nothing should happen  
            } else {
              return new GroupData(ds.data['name'], ds.data['description'], ds.documentID.toString(), ds.data['admin'], members);
            }
          }

        }
    } catch (exception)
    {
        print ('Something went wrong while fetching the groups of user ' + userData.getUserID() + ' !');
    }

    return null;

  }


  @override
  @Deprecated('Multiple groups are no longer supported!')
  Future< List<GroupData> > getGroups(String uniqueUserID) async
  {
    
    List<GroupData> groups = new List<GroupData>();

    try {
      var result = Firestore.instance
          .collection("groups")
          .where("members", arrayContains: uniqueUserID)
          .snapshots();
      
      await for (final data in result){
          // Handle all documents one by one
          for (final DocumentSnapshot ds in data.documents)
          {
            
            Map<String, String> members = new Map<String, String>();
            members = ds.data['members'];

            if (ds.data['name'] == null || ds.data['description'] == null || ds.data['admin'] == null || members.length == 0)
            {
              // In this case, nothing should happen  
            } else {
              groups.add( new GroupData(ds.data['name'], ds.data['description'], ds.documentID.toString(), ds.data['admin'], members) );
            }
          }

          return groups;

        }
    } catch (exception)
    {
        print ('Something went wrong while fetching the groups of user ' + uniqueUserID + ' !');
    }

    return groups;

  }
    

  @override
  Future< UserData > getUserByID(String uniqueID) async
  {
    UserData user;

    try {
        var document = await Firestore.instance
            .collection("users")
            .document( uniqueID ).get().then( (doc) {
              user = new UserData(doc.documentID, doc.data['name']);
            });
        
        if (user.getUserID() == null || user.getUsername() == null)
        {
          return null;
        }

        return user;
    } catch (exception)
    {
        print ('Something went wrong while fetching user ' + uniqueID);
        print(exception);
    }

    return null;

  }


  @override
  Future< GroupData > getGroupByCode(String code) async
  {
    GroupData groupData;

    try {
        await Firestore.instance
          .collection("groups")
          .document( code ).get().then( (document) {

            if (document.exists) {
              groupData = GroupData.fromDocumentSnapshot( document );
            } else {
              throw new GroupNotFoundException( code );
            }

          });
        
    } catch (exception)
    {
        print ('Something went wrong while fetching group ' + code);
        print(exception);
    }

    return groupData;
  }

  @override
  Future< Question > getRandomQuestion( GroupData groupData, Category category ) async
  {
    Question randomQuestion;
    String randomQuestionID;

    /// Select a random ID from the right category
    var doc = await Firestore.instance
          .collection("questions")
          .document("questionList")
          .get()
          .then (
            (document) {
              /// Convert List<dynamic> to List<String>
              List<dynamic> existing = document.data[ Question.getStringFromCategory( category ) ];
              List<String> questions = existing.cast<String>().toList();

              int randomID;
              if (questions.length > 1) {
                bool isSearching;
                var random = new Random();

                do {
                  isSearching = false;
                  randomID = random.nextInt( questions.length );
                  randomQuestionID = questions[randomID];

                  /// Make sure the question is not a duplicate
                  if (groupData.getLastQuestion().getQuestionID() == randomQuestionID) 
                    isSearching = true;
                  else if (groupData.getQuestion().getQuestionID() == randomQuestionID)
                    isSearching = true;
                  else 
                    isSearching = false;
                  
                } while (isSearching && questions.length > 3);

              } else if (questions[0] != null) {
                randomQuestionID = questions[0];
              } else {
                return new Question.add("Something went wrong wile fetching the question!", Category.Default);
              }
            }
          );

      

      /// Get a random question
      var documentSnap = await Firestore.instance
            .collection("questions")
            .document( randomQuestionID ).get().then( (document) {
              Category category = Category.Default;

              for (Category cat in Category.values)
              {
                String comparableCategory = cat.toString().split('.').last;
                if (document.data['category'] == null)
                {
                  cat = Category.Default;
                }

                if ( comparableCategory == document.data['category'] )
                {
                  category = cat;
                }
              }

              randomQuestion = new Question(document.documentID, document.data['question'], category, document.data['creatorID'], document.data['creatorName']);
            } );

      return randomQuestion;
  }


  @override
  Future< String > generateUniqueGroupCode() async
  { 
    bool isTaken = true;
    String newRandom;

    // While no unique ID has been found
    while ( isTaken )
    {
        // Generate a random ID
        newRandom = _getRandomID( Constants.groupCodeLength );

        // Check whether or not the generated ID exists 
        var documentSnap = await Firestore.instance
            .collection("groups")
            .document( newRandom ).get().then( (document) {

              // ID does not exist, unique code found!
              if ( ! document.exists )
                isTaken = false;

            } );
    }

    return newRandom;

  }

  @override
  Future< String > _generateUniqueQuestionCode() async
  { 
    bool isTaken = true;
    String newRandom;

    // While no unique ID has been found
    while ( isTaken )
    {
        // Generate a random ID
        newRandom = _getRandomID(6);

        // Check whether or not the generated ID exists 
        var documentSnap = await Firestore.instance
            .collection("questions")
            .document( newRandom ).get().then( (document) {

              // ID does not exist, unique code found!
              if ( ! document.exists )
                isTaken = false;

            } );
    }

    return newRandom;

  }


  @override
  Future< bool > doesGroupExist( String groupID ) async
  {
    bool exists = false;

    /// Get group with ID
    var documentSnap = await Firestore.instance
        .collection("groups")
        .document( groupID ).get().then( (document) {

          // Group exists!
          if ( document.exists )
            exists = true;

        } );

    return exists;
  }

  @override
  Future< bool > doesUserExist( String userID ) async
  {
    bool exists = false;

    /// Get group with ID
    var documentSnap = await Firestore.instance
        .collection("groups")
        .document( userID ).get().then( (document) {

          // Group exists!
          if ( document.exists )
            exists = true;

        } );

    return exists;
  }

  @override
  Future< bool > doesQuestionExist( String questionID ) async
  {
    bool exists = false;

    /// Get group with ID
    var documentSnap = await Firestore.instance
        .collection("questions")
        .document( questionID ).get().then( (document) {
          
          // Group exists!
          if ( document.exists )
            exists = true;

        } );

    return exists;
  }


  /// Check if this same question already exists
  /// Returns true if the question exists and has a different ID
  /// Returns false if the existing question has the same ID or if the question does not exist
  Future< bool > _hasIdenticalQuestion( Question question ) async
  {
    bool exists = false;

    /// Get group with ID
    var documentSnap = await Firestore.instance
        .collection("questions")
        .where( "question", isEqualTo: question.getQuestion()  )
        .getDocuments()
        .then( (documents) {
          
          documents.documents.forEach( (document){
            /// Group exists!
            if ( document.exists && document.documentID != question.getQuestionID())
              exists = true;
          } );        

        } );

    return exists;
  }

  Future< bool > _doesQuestionIDExist( Question question ) async
  {
    bool exists = false;

    if (question.getQuestionID() == null || question.getQuestionID() == "")
    {
      return false;
    }

    /// Get group with ID
    await Firestore.instance
        .collection("questions")
        .document( question.getQuestionID() )
        .get()
        .then( (document) {
          
          /// Group with the same ID exists!
          if ( document != null && document.exists)
            exists = true;      

        } );

    return exists;
  }

  /// -------
  /// Setters
  /// -------

  @override
  Future< bool > voteOnUser(GroupData groupData, String voteeID) async {

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

    @override
  Future< bool > voteOnQuestion(Question q) async
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


  @override
  Future< bool > updateGroup(GroupData groupData) async {
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


  @override
  Future< bool > updateUser(UserData userData) async {
    String uniqueID = userData.getUserID();
      
    var data = new Map<String, dynamic>();
    data['name'] = userData.getUsername();

    await Firestore.instance.runTransaction((Transaction transaction) async {
      DocumentReference docRef = Firestore.instance.collection("users").document( uniqueID );
      transaction.set(docRef, data);
    });

    return true;
  }


  @override
  Future< bool > updateQuestion( Question question ) async
  {
    /// Return false if the question is a duplicate (same ID doesn't count as duplicate)
    if ( await _hasIdenticalQuestion( question ))
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
      uniqueID = await _generateUniqueQuestionCode();
    }

    bool doesQuestionIDExist = await _doesQuestionIDExist( question );

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
  Future< void > _saveQuestionToList (Question question, List<Category> categories) async
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


  @override
  Future< bool > reportQuestion(Question question, ReportType reportType) async
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

  /// --------
  /// Deleters
  /// --------


  @override
  Future< bool > deleteGroup(GroupData group) async {

    if ( ! await doesGroupExist( group.getGroupCode() ) )
    {
      return false;
    }

    await Firestore.instance
      .collection('groups')
      .document( group.getGroupCode() )
      .delete();

    return true;

  }

  @override
  Future< bool > deleteQuestion(Question question) async {

    if ( ! await doesQuestionExist( question.getQuestionID() ) )
    {
      return false;
    }

    Firestore.instance.runTransaction((Transaction transaction) async {
            
      /// Get the document containing the lists
      DocumentReference listRef = Firestore.instance
                                  .collection('questions')
                                  .document( 'questionList' );
      DocumentSnapshot snap = await transaction.get( listRef );


      /// Create empty Map
      Map<String, dynamic> newLists = new Map<String, dynamic>();
      /// Fill the Map with new data, based on the current data
      for (Category cat in Question.getCategoriesAsList())
      {
        /// Convert to String
        String catString = Question.getStringFromCategory( cat );

        /// Get list of questions
        List<String> questions;
        
        if (snap.data[catString] != null)
        {
          List<dynamic> existing = snap.data[ catString ];
          questions = existing.cast<String>().toList();

          questions.remove( question.getQuestionID() );
        } else {
          questions = new List<String>();
        }

        newLists[ catString ] = questions;
      }

      /// Update list
      await transaction.set(listRef, newLists);
    });

    /// Delete question document
    await Firestore.instance
      .collection('questions')
      .document( question.getQuestionID() )
      .delete();


    return true;

  }

  @override
  Future< bool > deleteUser(UserData user) async {
    
    if ( ! await doesUserExist( user.getUserID() ) )
    {
      return false;
    }

    await Firestore.instance
      .collection('users')
      .document( user.getUserID() )
      .delete();

    return true;

  }


  /// -------
  /// Utility
  /// -------

  /// Create a random alphanumeric code
  /// Returns as a String
  String _getRandomID(int length)
  {
      var random = new Random();
      String result = "";

      // Generate 'length' characters to be added to the code
      for (int i = 0; i < length; i++)
      {
          // Generate random int => [0, 35[
          int gen = random.nextInt(35);
          
          // Smaller than 25 => Generate character
          // Otherwise, add a number
          if (gen <= 24) {
            result += _intToAlphabet( gen );
          } else {
            gen -= 25;
            result += gen.toString();
          }
      }

      return result;
  }
  
  /// The int must be in the range [0, 24]
  String _intToAlphabet(int num)
  {
      // Convert int to String
      switch (num)
      {
          case 0:
            return 'A';
          case 1:
            return 'B';
          case 2:
            return 'C';
          case 3:
            return 'D';
          case 4:
            return 'E';
          case 5:
            return 'F';
          case 6:
            return 'G';
          case 7:
            return 'H';
          case 8:
            return 'I';
          case 9:
            return 'J';
          case 10:
            return 'K';
          case 11:
            return 'L';
          case 12:
            return 'M';
          case 13:
            return 'N';
          case 14:
            return 'O';
          case 15:
            return 'P';
          case 16:
            return 'Q';
          case 17:
            return 'R';
          case 18:
            return 'S';
          case 19:
            return 'T';
          case 20:
            return 'U';
          case 21:
            return 'V';
          case 22:
            return 'W';
          case 22:
            return 'X';
          case 23:
            return 'Y';
          case 24:
            return 'Z';
          default:      // Out of bounds!!
            return "";
      }
  }
}