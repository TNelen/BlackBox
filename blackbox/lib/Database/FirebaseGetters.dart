import 'package:blackbox/Models/Appinfo.dart';
import 'package:blackbox/Models/GroupData.dart';
import 'package:blackbox/Models/QuestionCategory.dart';
import 'package:blackbox/Models/UserData.dart';
import 'package:blackbox/Database/QuestionListGetter.dart';
import 'package:blackbox/Exceptions/GroupNotFoundException.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/Question.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:blackbox/Constants.dart';

class FirebaseGetters {

  static Future<UserData> getUserByID(String uniqueID) async {

    UserData user;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(uniqueID)
          .get()
          .then((doc) {
        if (doc.exists && doc.data()['name'] != null) {

          String name = doc.data()['name'] as String;

          bool hasVibration = prefs.containsKey('vibration');
          bool hasSounds = prefs.containsKey('sounds');
          bool hasNotifications = prefs.containsKey('notifications');

          bool localVibration = prefs.getBool('vibration');
          bool localSounds = prefs.getBool('sounds');
          bool localNotifications = prefs.getBool('notifications');

          // Get settings if they exist, or use default values
          int accentId        = doc.data()['accent']        == null ? Constants.defaultColor : doc.data()['accent'] as int;
          bool vibration      = hasVibration      ? localVibration      : doc.data()['vibration']     != null ? doc.data()['vibration']     as bool : true;
          bool sounds         = hasSounds         ? localSounds         : doc.data()['sounds']        != null ? doc.data()['sounds']        as bool : true;
          bool notifications  = hasNotifications  ? localNotifications  : doc.data()['notifications'] != null ? doc.data()['notifications'] as bool : true;

          user = UserData.full(doc.id, name, accentId, vibration, sounds, notifications);
        }
      });

      if (user == null ||
          user.getUserID() == null ||
          user.getUsername() == null) {
        return null;
      }

      return user;
    } catch (exception) {
      print('Something went wrong while fetching user ' + uniqueID);
      print(exception);
    }

    return null;
  }

  static Future<GroupData> getGroupByCode(String code) async {
    GroupData groupData;

    try {
      await FirebaseFirestore.instance
          .collection("groups")
          .doc(code)
          .get()
          .then((document) {
        if (document.exists) {
          groupData = GroupData.fromDocumentSnapshot(document);
        } else {
          throw GroupNotFoundException(code);
        }
      });
    } catch (exception) {
      print('Something went wrong while fetching group ' + code);
      print(exception);
    }

    return groupData;
  }

  ///Get all the questions form the selected category and return it as a list
  static Future<List<String>> createQuestionList(String category) async {
    List<String> questionlist;
    await FirebaseFirestore.instance
        .collection("questionsv2")
        .doc("questionList")
        .get()
        .then((document) {
      /// Convert List<dynamic> to List<String>
      List<dynamic> existing = document.data()[category] as List;
      questionlist = existing.cast<String>().toList();
      if (questionlist.length > 1) {
        questionlist.removeAt(0);
        return questionlist;
        // questionlist.shuffle(Random.secure());
      } else {
        return [];
      }
    });
    return questionlist;
  }

  static Future<Question> getNextQuestion(GroupData groupData) async {
    QuestionListGetter getter = QuestionListGetter.instance;
    List<QuestionCategory> categories = await getter.getCategories();

    //get next question from arraylist.
    Question randomQuestion;
    if (groupData.getQuestionList().length != 0) {
      String questionId = groupData.getQuestionList().removeLast();
      await FirebaseFirestore.instance
          .collection("questionsv2")
          .doc(questionId)
          .get()
          .then((document) {
        QuestionCategory category = QuestionCategory.community();
        for (QuestionCategory cat in categories)
          if (cat.name == document.data()['category']) category = cat;

        randomQuestion = Question(
            document.id,
            document.data()['question'] as String,
            category,
            document.data()['creatorID'] as String,
            document.data()['creatorName'] as String);
      });

      return randomQuestion;
    } else
      return Question(
          "END",
          "The game has ended, please start a new game, or submit your own questions!",
          QuestionCategory.community(),
          "BlackBox",
          "BlackBox");
  }

  static Future<Appinfo> getAppInfo() async {
    Appinfo appinfo;
    await FirebaseFirestore.instance
        .collection("appinfo")
        .doc("appinfo")
        .get()
        .then((DocumentSnapshot snap) {
      if (snap.exists) {
        if (snap.data()['current_version'] != null &&
            snap.data()['current_version'] != "") {
          String msg = "";
          if (snap.data()['login_message'] != null &&
              snap.data()['login_message'] != "") {
            msg = snap.data()['login_message'] as String;
          }

          appinfo = Appinfo(snap.data()['current_version'] as String, msg);
        }
      } else {
        print("snap does not exists");
      }
    });
    return appinfo;
  }

  static Future<List<QuestionCategory>> getQuestionCategories() async {
    List<QuestionCategory> categories = List<QuestionCategory>();

    await FirebaseFirestore.instance
        .collection("questionsv2")
        .doc("questionList")
        .get()
        .then((document) {
      if (document.exists) {
        Map<String, dynamic> data = document.data();
        for (MapEntry e in data.entries) {
          if (e.value is List<dynamic>) {
            List<String> list = List<String>();
            for (dynamic element in e.value) {
              list.add(element.toString());
            }

            String description = list.removeAt(0);
            QuestionCategory qc =
                QuestionCategory(e.key.toString(), description, list);
            print('Category: ' +
                qc.name +
                ", description: " +
                qc.description +
                ", size: " +
                qc.amount.toString());
            categories.add(qc);
          }
        }
      }
    });
    print("return");
    // print([categories, descriptions, amounts]);
    return categories;
  }
}
