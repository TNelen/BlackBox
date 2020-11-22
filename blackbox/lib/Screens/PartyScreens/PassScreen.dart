import 'package:blackbox/DataContainers/GroupData.dart';
import 'package:blackbox/DataContainers/UserData.dart';
import 'package:blackbox/Screens/PartyScreens/PartyResultsScreen.dart';
import 'package:blackbox/Screens/popups/Popup.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import '../../Constants.dart';
import '../../Interfaces/Database.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import 'package:blackbox/Screens/HomeScreen.dart';
import 'PartyQuestionScreen.dart';

class PassScreen extends StatefulWidget {
  Database _database;
  GroupData groupData;
  String code;
  Map<UserData, int> playerVotes;

  PassScreen(Database db, GroupData groupData, String code,
      Map<UserData, int> playerVotes) {
    this._database = db;
    this.groupData = groupData;
    this.code = code;
    this.playerVotes = playerVotes;
  }

  @override
  _PassScreenState createState() =>
      new _PassScreenState(_database, groupData, code, playerVotes);
}

class _PassScreenState extends State<PassScreen> {
  Database _database;
  GroupData groupData;
  String code;
  Map<UserData, int> playerVotes;

  _PassScreenState(
      this._database, this.groupData, this.code, this.playerVotes) {
    FirebaseAnalytics().logEvent(
        name: 'open_screen', parameters: {'screen_name': 'RulesScreen'});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BlackBox',
        theme: new ThemeData(
            fontFamily: "atarian", scaffoldBackgroundColor: Constants.iBlack),
        home: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Constants.iBlack,
            title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            HomeScreen(_database),
                      ));
                },
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
                        fontSize: Constants.actionbuttonFontSize,
                        color: Constants.colors[Constants.colorindex],
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
          body: Center(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomLeft,
                  stops: [0.1, 1.0],
                  colors: [
                    Constants.gradient1,
                    Constants.gradient2,
                  ],
                ),
              ),
              child: ListView(
                padding: const EdgeInsets.only(
                    top: 20.0, bottom: 20, left: 50, right: 50),
                children: [
                  SizedBox(height: 40.0),
                  Text(
                    'pass the phone',
                    textAlign: TextAlign.center,
                    style: new TextStyle(
                        color: Constants.iWhite,
                        fontSize: Constants.titleFontSize,
                        fontWeight: FontWeight.w300),
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    height: 1.5,
                    color: Constants.iWhite,
                  ),
                  SizedBox(height: 40.0),
                  Card(
                    elevation: 5.0,
                    color: Constants.iDarkGrey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  PartyQuestionScreen(
                                      _database, groupData, code, playerVotes),
                            ));
                      },
                      child: Container(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 5, left: 10.0, right: 10, bottom: 5),
                            child: Column(
                              children: [
                                Text(
                                  "Vote!",
                                  style: new TextStyle(
                                      color: Constants.iWhite,
                                      fontSize: Constants.normalFontSize,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "New vote for this round",
                                  textAlign: TextAlign.center,
                                  style: new TextStyle(
                                      color: Constants.iLight,
                                      fontSize: Constants.smallFontSize,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 5),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Card(
                    elevation: 5.0,
                    color: Constants.iDarkGrey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: InkWell(
                      onTap: () {
                        Popup.submitQuestionIngamePopup(
                            context, _database, groupData);
                      },
                      child: Container(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 5, left: 10.0, right: 10, bottom: 5),
                            child: Column(
                              children: [
                                Text(
                                  "Add Question",
                                  style: new TextStyle(
                                      color: Constants.iWhite,
                                      fontSize: Constants.normalFontSize,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "Want to ask a question? Submit it here!",
                                  textAlign: TextAlign.center,
                                  style: new TextStyle(
                                      color: Constants.iLight,
                                      fontSize: Constants.smallFontSize,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 5),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: ConfirmationSlider(
            backgroundColor: Constants.iDarkGrey,
            foregroundColor: Constants.colors[Constants.colorindex],
            backgroundShape: BorderRadius.circular(16.0),
            foregroundShape: BorderRadius.circular(16.0),
            text: "Go to results",
            textStyle: TextStyle(
                color: Constants.iWhite,
                fontSize: Constants.smallFontSize,
                fontWeight: FontWeight.bold),
            icon: Icons.chevron_right,
            onConfirmation: () {
              String currentQuestion = groupData.getQuestionID();
              String currentQuestionString = groupData.getNextQuestionString();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => PartyResultScreen(
                        _database,
                        groupData,
                        code,
                        currentQuestion,
                        currentQuestionString,
                        playerVotes),
                  ));
            },
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        ));
  }
}
