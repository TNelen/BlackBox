import 'package:blackbox/Constants.dart';
import 'package:blackbox/DataContainers/Appinfo.dart';
import 'package:blackbox/DataContainers/GroupData.dart';
import 'package:blackbox/DataContainers/UserData.dart';
import 'package:blackbox/DataContainers/Issue.dart';
import 'package:blackbox/Exceptions/GroupNotFoundException.dart';
import '../DataContainers/Question.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Interfaces/Database.dart';
import 'dart:math';

import 'FirebaseUtility.dart';

class FirebaseDeleters {

  static Future< bool > deleteGroup(GroupData group) async {

    if ( ! await FirebaseUtility.doesGroupExist( group.getGroupCode() ) )
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
  static Future< bool > deleteQuestion(Question question) async {

    if ( ! await FirebaseUtility.doesQuestionExist( question.getQuestionID() ) )
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
  static Future< bool > deleteUser(UserData user) async {
    
    if ( ! await FirebaseUtility.doesUserExist( user.getUserID() ) )
    {
      return false;
    }

    await Firestore.instance
      .collection('users')
      .document( user.getUserID() )
      .delete();

    return true;

  }
}