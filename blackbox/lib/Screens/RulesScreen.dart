import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import '../Interfaces/Database.dart';
import '../Constants.dart';
import 'rules-list.dart';

class RuleScreen extends StatefulWidget {
  Database _database;

  RuleScreen(Database db) {
    this._database = db;
  }

  @override
  _RuleScreenState createState() => new _RuleScreenState(_database);
}

class _RuleScreenState extends State<RuleScreen> {
  Database _database;

  _RuleScreenState(Database db) {
    this._database = db;

    FirebaseAnalytics().logEvent(name: 'open_screen', parameters: {'screen_name': 'RulesScreen'});

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BlackBox',
        theme: new ThemeData(
            accentColor: Constants.colors[Constants.colorindex],
            disabledColor: Constants.colors[Constants.colorindex],
            fontFamily: "atarian",
            scaffoldBackgroundColor: Constants.iBlack),
        home: Scaffold(
            appBar: AppBar(
              backgroundColor: Constants.iBlack,
              title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Icon(
                          Icons.arrow_back,
                          color: Constants.colors[Constants.colorindex],
                        ),
                      ),
                      Text(
                        'Back',
                        style: TextStyle(
                          fontSize: 30,
                          color: Constants.colors[Constants.colorindex],
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
            body: Padding(
                padding: EdgeInsets.only(left: 22, right: 22),
                child: Center(
                  child: Container(
                    color: Constants.iBlack,
                    child: ListView(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(20.0),
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Hero(
                                tag: 'topicon1',
                                child: Icon(
                                  Icons.help,
                                  size: 50,
                                  color: Constants.colors[Constants.colorindex],
                                )),
                            SizedBox(width: 20.0),
                            Text(
                              'Game rules',
                              textAlign: TextAlign.center,
                              style: new TextStyle(
                                  color: Constants.iWhite,
                                  fontSize: 50.0,
                                  fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          height: 1.5,
                          color: Constants.iWhite,
                        ),
                        SizedBox(height: 20.0),
                        RulesList.getRules(),
                        SizedBox(height: 15.0),
                      ],
                    ),
                  ),
                ))));
  }
}
