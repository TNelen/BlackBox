import 'package:blackbox/Assets/questions.dart' as offlineQuestions;
import 'package:blackbox/Models/OfflineGroupData.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import '../../Constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:blackbox/translations/popups/popups.i18n.dart';

class Popup {
  static void makePopup(BuildContext context, String title, String message) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: Constants.iBlack,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0))),
          title: Text(
            title,
            style: TextStyle(
                fontFamily: "atarian",
                color: Constants.colors[Constants.colorindex],
                fontSize: Constants.normalFontSize),
          ),
          content: Text(
            message,
            style: TextStyle(
                fontFamily: "atarian",
                color: Constants.iWhite,
                fontSize: Constants.smallFontSize),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text(
                "Close".i18n,
                style: TextStyle(
                    fontFamily: "atarian",
                    color: Constants.colors[Constants.colorindex],
                    fontSize: Constants.actionbuttonFontSize,
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

  static void makeNotSatisfiedPopup(
      BuildContext context, String title, String message) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: Constants.iBlack,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0))),
          title: Text(
            title,
            style: TextStyle(
                fontFamily: "atarian",
                color: Constants.colors[Constants.colorindex],
                fontSize: Constants.normalFontSize),
          ),
          content: Container(
              height: 120,
              child: Column(children: [
                Text(
                  message,
                  style: TextStyle(
                      fontFamily: "atarian",
                      color: Constants.iWhite,
                      fontSize: Constants.smallFontSize),
                ),
                FlatButton(
                  onPressed: _launchURL,
                  //color: Constants.iDarkGrey,
                  child: Text(
                    "Contact us!".i18n,
                    style: TextStyle(
                        fontFamily: "atarian",
                        color: Constants.colors[Constants.colorindex],
                        fontSize: Constants.smallFontSize),
                  ),
                ),
              ])),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text(
                "Close".i18n,
                style: TextStyle(
                    fontFamily: "atarian",
                    color: Constants.colors[Constants.colorindex],
                    fontSize: Constants.actionbuttonFontSize,
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

  static void submitQuestionOfflinePopup(
      BuildContext context, OfflineGroupData offlineGroupData) {
    TextEditingController questionController = TextEditingController();

    // ignore: unnecessary_final
    final questionfield = Theme(
        data: ThemeData(
          primaryColor: Constants.colors[Constants.colorindex],
          primaryColorDark: Constants.colors[Constants.colorindex],
        ),
        child: TextField(
          obscureText: false,
          keyboardType: TextInputType.multiline,
          autocorrect: false,
          maxLength: 100,
          maxLines: 1,
          controller: questionController,
          style: TextStyle(
              fontFamily: "atarian",
              fontSize: Constants.smallFontSize,
              color: Constants.iWhite),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 40.0),
              fillColor: Constants.iBlack,
              filled: true,
              hintText: "Start typing here...".i18n,
              hintStyle: TextStyle(
                  fontFamily: "atarian",
                  fontSize: Constants.smallFontSize,
                  color: Constants.iGrey),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0))),
        ));

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: Constants.iBlack,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0))),
          title: Text(
            'Ask a question...'.i18n,
            style: TextStyle(
                fontFamily: "atarian",
                color: Constants.colors[Constants.colorindex],
                fontSize: Constants.subtitleFontSize),
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
                "Cancel".i18n,
                style: TextStyle(
                    fontFamily: "atarian",
                    color: Constants.colors[Constants.colorindex],
                    fontSize: Constants.actionbuttonFontSize,
                    fontWeight: FontWeight.bold),
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
                "Submit".i18n,
                style: TextStyle(
                    fontFamily: "atarian",
                    color: Constants.iBlack,
                    fontSize: Constants.actionbuttonFontSize,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                String question = questionController.text;
                //print('-' + question+ '-');
                if (question.length == 0) {
                  Popup.makePopup(context, 'Whoops!',
                      'You cannot submit an empty question'.i18n);
                } else if (question.length >= 5) {
                  FirebaseAnalytics().logEvent(
                      name: 'action_performed',
                      parameters: {'action_name': 'AddQuestionParty'});
                  //offlinequestions is prefix
                  offlineQuestions.QuestionList questionList =
                      offlineGroupData.getQuestionList();
                  questionList.addQuestion(question);
                  Navigator.pop(context);
                } else
                  Popup.makePopup(
                      context,
                      'Whoops!',
                      'You cannot submit a question shorter than 5 characters'
                          .i18n);
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
