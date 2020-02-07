import '../DataContainers/Question.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Constants.dart';
import 'dart:math';

class FirebaseUtility {
  
  static Future< bool > doesGroupExist( String groupID ) async
  {
    try {
      bool exists = false;

      /// Get group with ID
      await Firestore.instance
          .collection("groups")
          .document( groupID ).get().then( (document) {

            // Group exists!
            if ( document.exists )
              exists = true;

          } );

      return exists;
    } catch(exception) {
      print("Something went wrong while checking if a group exists");
      print(exception);
      return false;
    }
  }

  static Future< bool > doesUserExist( String userID ) async
  {
    try {
      bool exists = false;

      /// Get group with ID
      await Firestore.instance
          .collection("groups")
          .document( userID ).get().then( (document) {

            // Group exists!
            if ( document.exists )
              exists = true;

          } );

      return exists;
    } catch(exception) {
      print("Something went wrong while checking if a user exists");
      print(exception);
      return false;
    }
  }

  static Future< bool > doesQuestionExist( String questionID ) async
  {
    try {
      bool exists = false;

      /// Get group with ID
      await Firestore.instance
          .collection("questions")
          .document( questionID ).get().then( (document) {
            
            // Group exists!
            if ( document.exists )
              exists = true;

          } );

      return exists;
    } catch(exception) {
      print("Something went wrong while checking if a question exists");
      print(exception);
      return false;
    }
  }

  static Future< bool > doesQuestionIDExist( Question question ) async
  {
    try {
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
    } catch(exception) {
      print("Something went wrong while checking whether a question ID exists");
      print(exception);
      return false;
    }
  }

  /// Check if this same question already exists
  /// Returns true if the question exists and has a different ID
  /// Returns false if the existing question has the same ID or if the question does not exist
  static Future< bool > hasIdenticalQuestion( Question question ) async
  {
    try {
      bool exists = false;

      /// Get group with ID
      await Firestore.instance
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
    } catch(exception) {
      print("Something went wrong while checking whether a duplicate question already exists");
      print(exception);
      return false;
    }
  }

  static Future< String > generateUniqueQuestionCode() async
  { 
    try {
      bool isTaken = true;
      String newRandom;

      // While no unique ID has been found
      while ( isTaken )
      {
          // Generate a random ID
          newRandom = getRandomID(6);

          // Check whether or not the generated ID exists 
          await Firestore.instance
              .collection("questions")
              .document( newRandom ).get().then( (document) {

                // ID does not exist, unique code found!
                if ( ! document.exists )
                  isTaken = false;

              } );
      }

      return newRandom;
    } catch(exception) {
      print("Something went wrong while generating a unique question code");
      print(exception);
      return null;
    }

  }


  static Future< String > generateUniqueGroupCode() async
  { 
    try {
      bool isTaken = true;
      String newRandom;

      // While no unique ID has been found
      while ( isTaken )
      {
          // Generate a random ID
          newRandom = FirebaseUtility.getRandomID( Constants.groupCodeLength );

          // Check whether or not the generated ID exists 
          await Firestore.instance
              .collection("groups")
              .document( newRandom ).get().then( (document) {

                // ID does not exist, unique code found!
                if ( ! document.exists )
                  isTaken = false;

              } );
      }

      return newRandom;
    } catch(exception) {
      print("Something went wrong while generating a unique group code");
      print(exception);
      return null;
    }

  }

  /// Create a random alphanumeric code
  /// Returns as a String
  static String getRandomID(int length)
  {
    try {
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
    } catch(exception) {
      print("Something went wrong while getting a random ID");
      print(exception);
      return null;
    }
  }
  
  /// The int must be in the range [0, 24]
  static String _intToAlphabet(int num)
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