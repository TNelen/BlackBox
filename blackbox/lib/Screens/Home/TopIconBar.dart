import 'package:blackbox/Interfaces/Database.dart';
import 'package:flutter/material.dart';
import '../../Constants.dart';
import '../ProfileScreen.dart';
import '../SettingsScreen.dart';
import '../RulesScreen.dart';

class TopIconBar {
  static Widget topIcons(BuildContext context, Database database) {
    return Container(
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Card(
          color: Constants.iDarkGrey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32.0),
          ),
          child: InkWell(
              splashColor: Constants.colors[Constants.colorindex],
              onTap: () {
                //  if (GoogleUserHandler.isLoggedIn()) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          ProfileScreen(database),
                    ));
              },
              child: Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child:
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Text(
                      "Profile",
                      style: TextStyle(
                          color: Constants.colors[Constants.colorindex],
                          fontSize: 25,
                          fontWeight: FontWeight.w300),
                    ),
                    SizedBox(width: 5),
                    Icon(
                      Icons.account_circle,
                      color: Constants.colors[Constants.colorindex],
                      size: 30,
                    )
                  ])))),
      Row(
        children: <Widget>[
          Card(
              color: Constants.iDarkGrey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32.0),
              ),
              child: InkWell(
                  splashColor: Constants.colors[Constants.colorindex],
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              RuleScreen(database),
                        ));
                  },
                  child: Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Icon(
                        Icons.help,
                        color: Constants.colors[Constants.colorindex],
                        size: 30,
                      )))),
          Card(
              color: Constants.iDarkGrey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32.0),
              ),
              child: InkWell(
                  splashColor: Constants.colors[Constants.colorindex],
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              SettingsScreen(database),
                        ));
                  },
                  child: Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Icon(
                        Icons.settings,
                        color: Constants.colors[Constants.colorindex],
                        size: 30,
                      )))),
        ],
      )
    ]));
  }
}
