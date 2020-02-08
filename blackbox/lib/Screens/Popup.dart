import 'package:blackbox/DataContainers/GroupData.dart';
import 'package:flutter/material.dart';
import '../Constants.dart';
import '../Interfaces/Database.dart';
import '../DataContainers/UserData.dart';
import '../DataContainers/Question.dart';

class Popup {
  static void makePopup(BuildContext context, String title, String message) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: Constants.iWhite,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0))),
          title: new Text(
            title,
            style: TextStyle(color: Constants.iBlack, fontSize: 25),
          ),
          content: new Text(
            message,
            style: TextStyle(color: Constants.iDarkGrey, fontSize: 20),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Close",
                style: TextStyle(
                    color: Constants.colors[Constants.colorindex],
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
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
      style: TextStyle(fontSize: 20, color: Constants.iBlack),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 40.0),
          fillColor: Constants.iWhite,
          filled: true,
          hintText: Constants.getUsername(),
          hintStyle: TextStyle(fontSize: 18, color: Constants.iDarkGrey),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(16.0))),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: Constants.iWhite,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0))),
          title: new Text(
            'Change username',
            style: TextStyle(
                color: Constants.colors[Constants.colorindex], fontSize: 25),
          ),
          content: Container(
              height: 230,
              child: Column(children: [
                Text(
                  'This name will be shown in the game, make sure others recognise you!',
                  style: TextStyle(
                      color: Constants.iDarkGrey,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 25),
                usernameField,
              ])),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Update",
                style: TextStyle(
                    color: Constants.colors[Constants.colorindex],
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                if (usernameController.text.toString().length < 3) {
                  Popup.makePopup(
                      context, 'Oops!', 'Please enter more then 3 characters');
                } else {
                  Constants.setUsername(usernameController.text.toString());
                  Constants.setAccentColor(Constants.colorindex);
                  database.updateUser(Constants.getUserData());
                  Navigator.pop(context);
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
      String id = await database
          .updateQuestion(new Question.addFromUser(q, Constants.userData));
      groupData.addQuestionToList(id);
      database.updateGroup(groupData);
    }
  }

  static void submitQuestionIngamePopup(
    BuildContext context, Database database, GroupData groupData) {
    TextEditingController questionController = new TextEditingController();

    final questionfield = TextField(
      obscureText: false,
      keyboardType: TextInputType.multiline,
      autocorrect: false,
      maxLength: 100,
      maxLines: 1,
      controller: questionController,
      style: TextStyle(fontSize: 20, color: Constants.iBlack),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 40.0),
          fillColor: Constants.iWhite,
          filled: true,
          hintText: "Start typing here...",
          hintStyle: TextStyle(fontSize: 18, color: Constants.iGrey),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(16.0))),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: Constants.iWhite,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0))),
          title: new Text(
            'Ask a question...',
            style: TextStyle(
                color: Constants.colors[Constants.colorindex], fontSize: 25),
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
                "Submit",
                style: TextStyle(
                    color: Constants.colors[Constants.colorindex],
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                String question = questionController.text;
                //print('-' + question+ '-');
                if (question.length == 0) {
                  Popup.makePopup(context, 'Whoops!',
                      'You cannot submit an empty question');
                } else if (question.length >= 20) {
                  if (question.endsWith('?')) {
                    List<String> questions = new List<String>();
                    questions.add(question);
                    _addQuestions(questions, database, groupData);
                    Navigator.pop(context);
                  } else
                    Popup.makePopup(context, 'Whoops',
                        'Please end your question with a question mark');
                } else
                  Popup.makePopup(context, 'Whoops!',
                      'You cannot submit a question shorter than 20 characters');
              },
            ),
          ],
        );
      },
    );
  }
}
