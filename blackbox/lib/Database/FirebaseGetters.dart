import 'package:blackbox/Constants.dart';
import 'package:blackbox/DataContainers/Appinfo.dart';
import 'package:blackbox/DataContainers/GroupData.dart';
import 'package:blackbox/DataContainers/UserData.dart';
import 'package:blackbox/Exceptions/GroupNotFoundException.dart';
import '../DataContainers/Question.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

import 'FirebaseUtility.dart';

class FirebaseGetters {
  
  @Deprecated('Please use FirebaseStream instead!')
  static Future< GroupData > getGroupFromUser(UserData userData) async
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


  @Deprecated('Multiple groups are no longer supported!')
  static Future< List<GroupData> > getGroups(String uniqueUserID) async
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
    

  static Future< UserData > getUserByID(String uniqueID) async
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


  static Future< GroupData > getGroupByCode(String code) async
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

  static Future< Question > getRandomQuestion( GroupData groupData, Category category ) async
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
                return new Question.add("Something went wrong wile fetching the question!", Category.Official);
              }
            }
          );

      

      /// Get a random question
      var documentSnap = await Firestore.instance
            .collection("questions")
            .document( randomQuestionID ).get().then( (document) {
              Category category = Category.Official;

              for (Category cat in Category.values)
              {
                String comparableCategory = cat.toString().split('.').last;
                if (document.data['category'] == null)
                {
                  cat = Category.Official;
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


  static Future< Appinfo > getAppInfo() async
  {
    Appinfo appinfo;
    await Firestore.instance.runTransaction((Transaction transaction) async {
      /// Get the app info document
      DocumentReference docRef = Firestore.instance.collection("appinfo").document("appinfo");
      DocumentSnapshot snap = await transaction.get(docRef);

      if (snap.exists)
      {
        if (snap.data['current_version'] != null && snap.data['current_version'] != "")
        {
          String msg = "";
          if (snap.data['login_message'] != null && snap.data['login_message'] != "")
          {
            msg = snap.data['login_message'];
          }

          appinfo = new Appinfo(snap.data['current_version'], msg);

        }
      }

    });
    return appinfo;
  }

}