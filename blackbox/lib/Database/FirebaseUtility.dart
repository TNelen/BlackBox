import 'dart:io';
import '../Models/Question.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Constants.dart';
import 'dart:math';

class FirebaseUtility {
  static Future<bool> doesGroupExist(String groupID) async {
    bool exists = false;

    /// Get group with ID
    await FirebaseFirestore.instance
        .collection("groups")
        .doc(groupID)
        .get()
        .then((document) {
      // Group exists!
      if (document.exists) exists = true;
    });

    return exists;
  }

  static Future<bool> doesUserExist(String userID) async {
    bool exists = false;

    /// Get group with ID
    await FirebaseFirestore.instance
        .collection("groups")
        .doc(userID)
        .get()
        .then((document) {
      // Group exists!
      if (document.exists) exists = true;
    });

    return exists;
  }

  static Future<bool> doesQuestionExist(String questionID) async {
    bool exists = false;

    /// Get group with ID
    await FirebaseFirestore.instance
        .collection("questionsv2")
        .doc(questionID)
        .get()
        .then((document) {
      // Group exists!
      if (document.exists) exists = true;
    });

    return exists;
  }

  static Future<bool> doesQuestionIDExist(Question question) async {
    bool exists = false;

    if (question.getQuestionID() == null || question.getQuestionID() == "") {
      return false;
    }

    /// Get group with ID
    await FirebaseFirestore.instance
        .collection("questionsv2")
        .doc(question.getQuestionID())
        .get()
        .then((document) {
      /// Group with the same ID exists!
      if (document != null && document.exists) exists = true;
    });

    return exists;
  }

  /// Check if this same question already exists
  /// Returns true if the question exists and has a different ID
  /// Returns false if the existing question has the same ID or if the question does not exist
  static Future<bool> hasIdenticalQuestion(Question question) async {
    bool exists = false;

    /// Get group with ID
    await FirebaseFirestore.instance
        .collection("questionsv2")
        .where("question", isEqualTo: question.getQuestion())
        .get()
        .then((documents) {
      documents.docs.forEach((document) {
        /// Group exists!
        if (document.exists && document.id != question.getQuestionID())
          exists = true;
      });
    });

    return exists;
  }

  static Future<String> generateUniqueQuestionCode() async {
    bool isTaken = true;
    String newRandom;

    // While no unique ID has been found
    while (isTaken) {
      // Generate a random ID
      newRandom = getRandomID(6);

      // Check whether or not the generated ID exists
      await FirebaseFirestore.instance
          .collection("questionsv2")
          .doc(newRandom)
          .get()
          .then((document) {
        // ID does not exist, unique code found!
        if (!document.exists) isTaken = false;
      });
    }

    return newRandom;
  }

  static Future<String> generateUniqueGroupCode() async {
    bool isTaken = true;
    String newRandom;

    // While no unique ID has been found
    while (isTaken) {
      // Generate a random ID
      newRandom = FirebaseUtility.getRandomID(Constants.groupCodeLength);

      // Check whether or not the generated ID exists
      await FirebaseFirestore.instance
          .collection("groups")
          .doc(newRandom)
          .get()
          .then((document) {
        // ID does not exist, unique code found!
        if (!document.exists) isTaken = false;
      });
    }

    return newRandom;
  }

  /// Create a random alphanumeric code
  /// Returns as a String
  /// Contains A-Z and 2-9. One and Zero are excluded to prevent confusion with 1-I and 0-O
  static String getRandomID(int length) {
    var random = Random();
    String result = "";

    // Generate 'length' characters to be added to the code
    for (int i = 0; i < length; i++) {
      // Generate random int => [0, 35[
      int gen = random.nextInt(33);

      // Smaller than 25 => Generate character
      // Otherwise, add a number
      if (gen <= 24) {
        result += _intToAlphabet(gen);
      } else {
        gen -= 23;
        result += gen.toString();
      }
    }

    return result;
  }

  /// The int must be in the range [0, 24]
  static String _intToAlphabet(int num) {
    // Convert int to String
    switch (num) {
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
      default: // Out of bounds!!
        return "";
    }
  }

  /// Backup the database
  /// Creates a copy of all questions
  static void backupDatabase() async {
    /// Get all questions
    Map<String, Map<String, dynamic>> questions = Map<String,
        Map<String, dynamic>>(); // Mapping document ID to its contents

    await FirebaseFirestore.instance
        .collection("questionsv2")
        .get()
        .then((docs) {
      // Get ALL questions and add them to the Map
      for (DocumentSnapshot document in docs.docs) {
        questions[document.id] = document.data();
      }
    });

    try {
      /// Make a backup of each question
      var collection = FirebaseFirestore.instance.collection("questionsBackup");
      questions.forEach((id, data) {
        DocumentReference reference =
            collection.doc(id); // Reference to the document

        FirebaseFirestore.instance
            .runTransaction((Transaction transaction) async {
          // Perform the transaction
          await transaction.set(reference, data); // Update the document
        });

        Duration delay = Duration(milliseconds: 10);
        sleep(delay);
      });
    } catch (e) {
      print(e);
    }
  }
}
