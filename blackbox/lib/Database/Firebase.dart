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

    var doc = await Firestore.instance
          .collection("questions")
          .document("questionList")
          .get()
          .then (
            (document) {
              /// Convert List<dynamic> to List<String>
              List<dynamic> existing = document.data['questionList'];
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

              } else randomID = 0;

              print ("RANDOM QUESTION: " + randomQuestionID);
            }
          );

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
        newRandom = _getRandomID(5);

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
  Future< bool > _hasIdenticalQuestion( String question ) async
  {
    bool exists = false;

    /// Get group with ID
    var documentSnap = await Firestore.instance
        .collection("questions")
        .where( "question", isEqualTo: question  )
        .getDocuments()
        .then( (documents) {
          
          documents.documents.forEach( (document){
            /// Group exists!
            if ( document.exists )
              exists = true;
          } );        

        } );

    return exists;
  }

  /// -------
  /// Setters
  /// -------

  @override
  Future< bool > voteOnUser(GroupData groupData, String voteeID) async {

    Firestore.instance.runTransaction((Transaction transaction) async {
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
  Future< bool > updateGroup(GroupData groupData) async {
    String code = groupData.getGroupCode();
    String userID = Constants.getUserID();

    Firestore.instance.runTransaction((Transaction transaction) async {

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

    Firestore.instance.runTransaction((Transaction transaction) async {
      DocumentReference docRef = Firestore.instance.collection("users").document( uniqueID );
      transaction.set(docRef, data);
    });

    return true;
  }


  @override
  Future< bool > updateQuestion( Question question ) async
  {

    if ( await _hasIdenticalQuestion( question.getQuestion() ) )
    {
        return false;
    }

    var data = new Map<String, dynamic>();
    data['question'] = question.getQuestion();
    data['category'] = question.getCategory();
    data['creatorID'] = question.getCreatorID();
    data['creatorName'] = question.getCreatorName();
    
    Firestore.instance.runTransaction((Transaction transaction) async {

      /// Generate a unique ID
      String uniqueID;
      if (question.getQuestionID() != null)
        uniqueID = question.getQuestionID();
      else 
        uniqueID = "";
      
      if (uniqueID == "")
      {
        uniqueID = await _generateUniqueQuestionCode();
      }


      /// Update question list
      DocumentReference docRef = Firestore.instance
                  .collection("questions")
                  .document("questionList");

      List<String> questions;
      await transaction.get(docRef)
            .then (
              (document) {
                /// Convert List<dynamic> to List<String>
                List<dynamic> existing = document.data['questionList'];
                questions = existing.cast<String>().toList();

              }
            );
      
      if ( ! questions.contains(uniqueID) )
      {
        questions.add( uniqueID );
        var newData = new Map<String, dynamic>();
        newData['questionList'] = questions;

        transaction.set(docRef, newData );
      }


      /// Save question
      docRef = Firestore.instance
                .collection("questions")
                .document( uniqueID );
      transaction.set(docRef, data);
    });

    return true;

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
            
      DocumentReference listRef = Firestore.instance
                                  .collection('questions')
                                  .document( 'questionList' );

      /// Get list of questions
      List<String> questions = new List<String>();
      await transaction.get( listRef ).then(
        (snap) {
          List<dynamic> existing = snap.data['questions'];
          questions = existing.cast<String>().toList();
        }
      );

      questions.remove( question.getQuestionID() );


      Map<String, dynamic> newList = new Map<String, dynamic>();
      newList['questionList'] = questions;

      /// Update list
      await transaction.set(listRef, newList);
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