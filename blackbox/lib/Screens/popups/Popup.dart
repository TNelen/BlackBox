import 'package:blackbox/Assets/questions.dart' as offlineQuestions;
import 'package:blackbox/DataContainers/GroupData.dart';
import 'package:blackbox/DataContainers/OfflineGroupData.dart';
import 'package:blackbox/Screens/SettingsScreen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import '../../Constants.dart';
import '../../Interfaces/Database.dart';
import '../../DataContainers/Question.dart';
import '../HomeScreen.dart';
import 'package:url_launcher/url_launcher.dart';

class Popup {
  static void makePopup(BuildContext context, String title, String message) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: Constants.iBlack,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
          title: Text(
            title,
            style: TextStyle(fontFamily: "atarian", color: Constants.colors[Constants.colorindex], fontSize: Constants.normalFontSize),
          ),
          content: Text(
            message,
            style: TextStyle(fontFamily: "atarian", color: Constants.iWhite, fontSize: Constants.smallFontSize),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text(
                "Close",
                style: TextStyle(fontFamily: "atarian", color: Constants.colors[Constants.colorindex], fontSize: Constants.actionbuttonFontSize, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  static void makeNotSatisfiedPopup(BuildContext context, String title, String message) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: Constants.iBlack,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
          title: Text(
            title,
            style: TextStyle(fontFamily: "atarian", color: Constants.colors[Constants.colorindex], fontSize: Constants.normalFontSize),
          ),
          content: Container(
              height: 120,
              child: Column(children: [
                Text(
                  message,
                  style: TextStyle(fontFamily: "atarian", color: Constants.iWhite, fontSize: Constants.smallFontSize),
                ),
                FlatButton(
                  onPressed: _launchURL,
                  //color: Constants.iDarkGrey,
                  child: Text(
                    "Contact us!",
                    style: TextStyle(fontFamily: "atarian", color: Constants.colors[Constants.colorindex], fontSize: Constants.smallFontSize),
                  ),
                ),
              ])),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text(
                "Close",
                style: TextStyle(fontFamily: "atarian", color: Constants.colors[Constants.colorindex], fontSize: Constants.actionbuttonFontSize, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  static void makeChangeUsernamePopup(BuildContext context, Database database) {
    TextEditingController usernameController = TextEditingController();

    final usernameField = TextField(
      obscureText: false,
      keyboardType: TextInputType.multiline,
      autocorrect: false,
      maxLength: 20,
      maxLines: 1,
      controller: usernameController,
      style: TextStyle(fontFamily: "atarian", fontSize: 20, color: Constants.iWhite),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 40.0),
          fillColor: Constants.iBlack,
          filled: true,
          hintText: Constants.getUsername(),
          hintStyle: TextStyle(fontFamily: "atarian", fontSize: Constants.smallFontSize, color: Constants.iGrey),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0))),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: Constants.iBlack,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
          title: Text(
            'Change username',
            style: TextStyle(fontFamily: "atarian", color: Constants.colors[Constants.colorindex], fontSize: Constants.normalFontSize),
          ),
          content: Container(
              height: 230,
              child: Column(children: [
                Text(
                  'This name will be shown in the game, make sure others recognise you!',
                  style: TextStyle(fontFamily: "atarian", color: Constants.iWhite, fontSize: Constants.smallFontSize, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 25),
                usernameField,
              ])),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "Cancel",
                style: TextStyle(fontFamily: "atarian", color: Constants.colors[Constants.colorindex], fontSize: Constants.actionbuttonFontSize, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            // usually buttons at the bottom of the dialog
            FlatButton(
              color: Constants.colors[Constants.colorindex],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(26.0),
              ),
              child: Text(
                "Update",
                style: TextStyle(fontFamily: "atarian", color: Constants.iBlack, fontSize: Constants.actionbuttonFontSize, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                if (usernameController.text.toString().length < 3) {
                  Popup.makePopup(context, 'Oops!', 'Please enter more then 3 characters');
                } else {
                  Constants.setUsername(usernameController.text.toString());
                  Constants.setAccentColor(Constants.colorindex + 1);
                  database.updateUser(Constants.getUserData());
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => SettingsScreen(database),
                      ));
                }
              },
            ),
          ],
        );
      },
    );
  }

  static void _addQuestions(List<String> questions, Database database, GroupData groupData) async {
    for (String q in questions) {
      String id = await database.updateQuestion(Question.addFromUser(q, Constants.userData));
      groupData.addQuestionToList(id);
      await database.updateGroup(groupData);
    }
  }

  static void submitQuestionIngamePopup(BuildContext context, Database database, GroupData groupData) {
    TextEditingController questionController = TextEditingController();

    // ignore: unnecessary_final
    final questionfield = TextField(
      obscureText: false,
      keyboardType: TextInputType.multiline,
      autocorrect: false,
      maxLength: 100,
      maxLines: 1,
      controller: questionController,
      style: TextStyle(fontFamily: "atarian", fontSize: Constants.smallFontSize, color: Constants.iWhite),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 40.0),
          fillColor: Constants.iBlack,
          filled: true,
          hintText: "Start typing here...",
          hintStyle: TextStyle(fontFamily: "atarian", fontSize: Constants.smallFontSize, color: Constants.iGrey),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0))),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: Constants.iBlack,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
          title: Text(
            'Ask a question...',
            style: TextStyle(fontFamily: "atarian", color: Constants.colors[Constants.colorindex], fontSize: Constants.subtitleFontSize),
          ),
          content: Container(
              height: 230,
              child: Column(children: [
                SizedBox(height: 25),
                questionfield,
              ])),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text(
                "Cancel",
                style: TextStyle(fontFamily: "atarian", color: Constants.colors[Constants.colorindex], fontSize: Constants.actionbuttonFontSize, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),

            FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
                //side: BorderSide(color: Colors.red)
              ),
              color: Constants.colors[Constants.colorindex],
              child: Text(
                "Submit",
                style: TextStyle(fontFamily: "atarian", color: Constants.iBlack, fontSize: Constants.actionbuttonFontSize, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                String question = questionController.text;
                //print('-' + question+ '-');
                if (question.length == 0) {
                  Popup.makePopup(context, 'Whoops!', 'You cannot submit an empty question');
                } else if (question.length >= 5) {
                  FirebaseAnalytics().logEvent(name: 'action_performed', parameters: {'action_name': 'AddQuestionIngame'});

                  List<String> questions = List<String>();
                  questions.add(question);
                  _addQuestions(questions, database, groupData);
                  Navigator.pop(context);
                } else
                  Popup.makePopup(context, 'Whoops!', 'You cannot submit a question shorter than 5 characters');
              },
            ),
          ],
        );
      },
    );
  }

  static void submitQuestionOfflinePopup(BuildContext context, OfflineGroupData offlineGroupData) {
    TextEditingController questionController = TextEditingController();

    // ignore: unnecessary_final
    final questionfield = TextField(
      obscureText: false,
      keyboardType: TextInputType.multiline,
      autocorrect: false,
      maxLength: 100,
      maxLines: 1,
      controller: questionController,
      style: TextStyle(fontFamily: "atarian", fontSize: Constants.smallFontSize, color: Constants.iWhite),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 40.0),
          fillColor: Constants.iBlack,
          filled: true,
          hintText: "Start typing here...",
          hintStyle: TextStyle(fontFamily: "atarian", fontSize: Constants.smallFontSize, color: Constants.iGrey),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0))),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: Constants.iBlack,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
          title: Text(
            'Ask a question...',
            style: TextStyle(fontFamily: "atarian", color: Constants.colors[Constants.colorindex], fontSize: Constants.subtitleFontSize),
          ),
          content: Container(
              height: 230,
              child: Column(children: [
                SizedBox(height: 25),
                questionfield,
              ])),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text(
                "Cancel",
                style: TextStyle(fontFamily: "atarian", color: Constants.colors[Constants.colorindex], fontSize: Constants.actionbuttonFontSize, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),

            FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
                //side: BorderSide(color: Colors.red)
              ),
              color: Constants.colors[Constants.colorindex],
              child: Text(
                "Submit",
                style: TextStyle(fontFamily: "atarian", color: Constants.iBlack, fontSize: Constants.actionbuttonFontSize, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                String question = questionController.text;
                //print('-' + question+ '-');
                if (question.length == 0) {
                  Popup.makePopup(context, 'Whoops!', 'You cannot submit an empty question');
                } else if (question.length >= 5) {
                  FirebaseAnalytics().logEvent(name: 'action_performed', parameters: {'action_name': 'AddQuestionParty'});
                  //offlinequestions is prefix
                  offlineQuestions.QuestionList questionList = offlineGroupData.getQuestionList();
                  questionList.addQuestion(question);
                  Navigator.pop(context);
                } else
                  Popup.makePopup(context, 'Whoops!', 'You cannot submit a question shorter than 5 characters');
              },
            ),
          ],
        );
      },
    );
  }

  static void togglePlaying(groupData) {
    // ignore: invariant_booleans
    groupData.setIsPlaying(!groupData.getIsPlaying());
  }

  static void confirmEndGame(BuildContext context, Database database, GroupData groupData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: Constants.iDarkGrey,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
          title: Text(
            'End game?',
            style: TextStyle(fontFamily: "atarian", color: Constants.colors[Constants.colorindex], fontSize: Constants.subtitleFontSize),
          ),
          content: Text(
            'Are you sure to end the game? \nThe game will end for all users.',
            style: TextStyle(fontFamily: "atarian", color: Constants.iWhite, fontSize: Constants.smallFontSize),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text(
                "Yes I'm sure",
                style: TextStyle(fontFamily: "atarian", color: Constants.colors[Constants.colorindex], fontSize: Constants.actionbuttonFontSize, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                togglePlaying(groupData);
                database.updateGroup(groupData);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}

void _launchURL() async {
  const url = 'mailto:magnetar.apps@gmail.com?subject=Problem report&body=';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
