import 'package:blackbox/DataContainers/GroupData.dart';
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
          title: new Text(
            title,
            style: TextStyle(fontFamily: "atarian", color: Constants.colors[Constants.colorindex], fontSize: Constants.normalFontSize),
          ),
          content: new Text(
            message,
            style: TextStyle(fontFamily: "atarian", color: Constants.iWhite, fontSize: Constants.smallFontSize),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
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
          title: new Text(
            title,
            style: TextStyle(fontFamily: "atarian", color: Constants.colors[Constants.colorindex], fontSize: Constants.normalFontSize),
          ),
          content: Container(
              height: 120,
              child: Column(children: [
                new Text(
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
            new FlatButton(
              child: new Text(
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
    TextEditingController usernameController = new TextEditingController();

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
          title: new Text(
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
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Update",
                style: TextStyle(fontFamily: "atarian", color: Constants.colors[Constants.colorindex], fontSize: Constants.actionbuttonFontSize, fontWeight: FontWeight.bold),
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
                        builder: (BuildContext context) => HomeScreen(Constants.database),
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
      String id = await database.updateQuestion(new Question.addFromUser(q, Constants.userData));
      groupData.addQuestionToList(id);
      database.updateGroup(groupData);
    }
  }

  static void submitQuestionIngamePopup(BuildContext context, Database database, GroupData groupData) {
    TextEditingController questionController = new TextEditingController();

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
          title: new Text(
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
            new FlatButton(
              child: new Text(
                "Cancel",
                style: TextStyle(fontFamily: "atarian", color: Constants.colors[Constants.colorindex], fontSize: Constants.actionbuttonFontSize, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),

            new FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
                //side: BorderSide(color: Colors.red)
              ),
              color: Constants.colors[Constants.colorindex],
              child: new Text(
                "Submit",
                style: TextStyle(fontFamily: "atarian", color: Constants.iBlack, fontSize: Constants.actionbuttonFontSize, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                String question = questionController.text;
                //print('-' + question+ '-');
                if (question.length == 0) {
                  Popup.makePopup(context, 'Whoops!', 'You cannot submit an empty question');
                } else if (question.length >= 20) {
                  FirebaseAnalytics().logEvent(name: 'action_performed', parameters: {'action_name': 'AddQuestionIngame'});

                  List<String> questions = new List<String>();
                  questions.add(question);
                  _addQuestions(questions, database, groupData);
                  Navigator.pop(context);
                } else
                  Popup.makePopup(context, 'Whoops!', 'You cannot submit a question shorter than 20 characters');
              },
            ),
          ],
        );
      },
    );
  }

  static String addPlayer(BuildContext context, Database database, GroupData groupData) {
    TextEditingController playerNameController = new TextEditingController();

    final namefield = TextField(
      obscureText: false,
      keyboardType: TextInputType.text,
      autocorrect: false,
      maxLength: 15,
      maxLines: 1,
      controller: playerNameController,
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
          title: new Text(
            'Player Name',
            style: TextStyle(fontFamily: "atarian", color: Constants.colors[Constants.colorindex], fontSize: Constants.subtitleFontSize),
          ),
          content: Container(
              height: 230,
              child: Column(children: [
                SizedBox(height: 25),
                namefield,
              ])),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Cancel",
                style: TextStyle(fontFamily: "atarian", color: Constants.colors[Constants.colorindex], fontSize: Constants.actionbuttonFontSize, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),

            new FlatButton(
              child: new Text(
                "Submit",
                style: TextStyle(fontFamily: "atarian", color: Constants.colors[Constants.colorindex], fontSize: Constants.actionbuttonFontSize, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                String name = playerNameController.text;
                //print('-' + question+ '-');
                if (name.length <= 2) {
                  Popup.makePopup(context, 'Whoops!', 'Player nqme is too short');
                } else {
                  FirebaseAnalytics().logEvent(name: 'action_performed', parameters: {'action_name': 'addPlayer'});

                  return name;
                }
              },
            ),
          ],
        );
      },
    );
  }

  static void togglePlaying(groupData) {
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
          title: new Text(
            'End game?',
            style: TextStyle(fontFamily: "atarian", color: Constants.colors[Constants.colorindex], fontSize: Constants.subtitleFontSize),
          ),
          content: Text(
            'Are you sure to end the game? \nThe game will end for all users.',
            style: TextStyle(fontFamily: "atarian", color: Constants.iWhite, fontSize: Constants.smallFontSize),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
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

_launchURL() async {
  const url = 'mailto:magnetar.apps@gmail.com?subject=Problem report&body=';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
