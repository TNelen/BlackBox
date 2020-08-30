import 'package:flutter/material.dart';
import '../../Interfaces/Database.dart';
import '../../Constants.dart';
import '../GameScreen.dart';
import 'package:share/share.dart';


class NoMemberSelectedPopup {



  static void noMemberSelectedPopup(BuildContext context) {
    // flutter defined function
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            backgroundColor: Constants.iBlack,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
            title: new Text(
              "No members selected",
              style: TextStyle(fontFamily: "atarian", color: Constants.colors[Constants.colorindex], fontSize: Constants.normalFontSize),
            ),
            content: new Text(
              "Please make a valid choice",
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
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
