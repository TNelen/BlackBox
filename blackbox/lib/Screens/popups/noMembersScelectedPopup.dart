import 'package:flutter/material.dart';
import '../../Constants.dart';
import 'package:blackbox/translations/translations.i18n.dart';

class NoMemberSelectedPopup {
  static void noMemberSelectedPopup(BuildContext context) {
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
            "No member selected".i18n,
            style: TextStyle(
                fontFamily: "roboto",
                color: Constants.iAccent,
                fontSize: Constants.smallFontSize),
          ),
          content: Text(
            "Please make a valid choice".i18n,
            style: TextStyle(
                fontFamily: "roboto",
                color: Constants.iWhite,
                fontSize: Constants.smallFontSize),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text(
                "Close".i18n,
                style: TextStyle(
                    fontFamily: "roboto",
                    color: Constants.iAccent,
                    fontSize: Constants.smallFontSize,
                    fontWeight: FontWeight.bold),
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
