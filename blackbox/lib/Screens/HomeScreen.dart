import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Constants.dart';
import 'CreateGameScreen.dart';
import 'JoinGameScreen.dart';
import 'RulesScreen.dart';
import '../Interfaces/Database.dart';
import 'ProfileScreen.dart';
import 'SettingsScreen.dart';
import 'package:blackbox/DataContainers/Question.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../DataContainers/Appinfo.dart';
import 'Popup.dart';
import 'package:open_appstore/open_appstore.dart';
import 'package:store_redirect/store_redirect.dart';

class HomeScreen extends StatefulWidget {
  Database database;

  HomeScreen(Database db) {
    database = db;
  }

  @override
  _HomeScreenState createState() => _HomeScreenState(database);

  HomePage(Database db) {
    this.database = db;
  }
}

class _HomeScreenState extends State<HomeScreen> {
  Database database;
  int pageIndex = 0;
  String version = '1.0.7+7';

  _HomeScreenState(Database db) {
    this.database = db;

    isAppUpToDate();

    /// Show an update reminder when needed
    isWelcomeMSG();

    /// Show a message if one is set in the database
  }

  @Deprecated('For async testing only. Must be deleted before release!')
  void _test() async {
    print("Async start");

    /// Your async testing code here
    print("Async completed");
  }

  @Deprecated('Must be deleted before release!')
  void _addQuestions(List<String> questions) async {
    for (String q in questions) {
      await database.updateQuestion(new Question.addDefault(q));
    }
  }

  /// Renames question category in questionList
  @Deprecated('Must be deleted before release!')
  void _renameQuestionCategory(String from, String to) async {
    DocumentSnapshot snap = await Firestore.instance
        .collection("questions")
        .document("questionList")
        .get();

    List<dynamic> existing = snap.data[from];
    List<String> newer = existing.cast<String>().toList();

    var newData = new Map<String, dynamic>();

    newData[to] = newer;
    await Firestore.instance
        .collection("questions")
        .document("questionList")
        .updateData(newData);
  }

  Widget rateAppButton() {
    return FlatButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "rate this app",
              style: TextStyle(
                  color: Constants.colors[Constants.colorindex],
                  fontSize: 15,
                  fontWeight: FontWeight.w300),
            ),
            SizedBox(
              width: 10,
            ),
            Icon(
              Icons.star,
              color: Constants.colors[Constants.colorindex],
              size: 15,
            ),
          ],
        ),
        onPressed: () {
          StoreRedirect.redirect();
        });
  }

  Widget CreateGameBox() {
    return Hero(
        tag: 'toberutton',
        child: Card(
          color: Constants.iDarkGrey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: InkWell(
              splashColor: Constants.colors[Constants.colorindex],
              onTap: () {
                // if (GoogleUserHandler.isLoggedIn()) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          CreateGameScreen(database),
                    ));
                // } else {
                //Popup.makePopup(context, "Wait!", "You should be logged in to do that.");
                //}
              },
              child: Container(
                  padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.edit,
                        color: Constants.colors[Constants.colorindex],
                        size: 35,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Create Game",
                            style: TextStyle(
                                fontSize: 30.0,
                                color: Constants.iWhite,
                                fontWeight: FontWeight.w400),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Invite friends to a new game",
                            style: TextStyle(
                                fontSize: 20.0,
                                color: Constants.iLight,
                                fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                    ],
                  ))),
        ));
  }

  Widget JoinGameBox() {
    return Hero(
        tag: 'frfr',
        child: Card(
          color: Constants.iDarkGrey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: InkWell(
              splashColor: Constants.colors[Constants.colorindex],
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          JoinGameScreen(database),
                    ));
              },
              child: Container(
                  padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.search,
                        color: Constants.colors[Constants.colorindex],
                        size: 35,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Join Game",
                            style: TextStyle(
                                fontSize: 30.0,
                                color: Constants.iWhite,
                                fontWeight: FontWeight.w400),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Join with the group code",
                            style: TextStyle(
                                fontSize: 20.0,
                                color: Constants.iLight,
                                fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                    ],
                  ))),
        ));
  }

  Widget settingsProfileTop(BuildContext context) {
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

  void isAppUpToDate() async {
    Appinfo appinfo;
    if (Constants.enableMSG[Constants.enableVersionMSG]) {
      appinfo = await database.getAppInfo();
      String versionCodeDatabase = appinfo.getVersion().toString();
      if (versionCodeDatabase != version) {
        Constants.enableVersionMSG = 1;
        Popup.makePopup(context, 'Whooohooo!',
            'A new app version is available! \n\nUpdate your app to get the best experience.');
      }
    }
  }

  void isWelcomeMSG() async {
    Appinfo appinfo;
    if (Constants.enableMSG[Constants.enableWelcomeMSG]) {
      appinfo = await database.getAppInfo();
      String welcomeMessage = appinfo.getLoginMessage();
      if (welcomeMessage.length != 0) {
        Constants.enableWelcomeMSG = 1;
        Popup.makePopup(context, 'Welcome!', welcomeMessage);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: new MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: new ThemeData(
            fontFamily: "atarian",
            scaffoldBackgroundColor: Constants.iBlack,
          ),
          home: Scaffold(
            backgroundColor: Constants.iBlack,
            body: Container(
              margin: EdgeInsets.only(top: 16, left: 5, right: 5),
              child: Column(
                children: [
                  SizedBox(
                    height: height / 30,
                  ),
                  settingsProfileTop(context),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: EdgeInsets.only(
                              top: height / 10, left: 10, right: 10),
                          child: AutoSizeText(
                            'Hi, ' +
                                Constants.getUsername().split(" ")[0] +
                                '!',
                            style: TextStyle(
                                fontSize: 60,
                                color: Constants.iWhite,
                                fontWeight: FontWeight.w300),
                            maxLines: 1,
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: Text(
                              ' Welcome to BlackBox! ',
                              style: TextStyle(
                                  color: Constants.colors[Constants.colorindex],
                                  fontSize: 30,
                                  fontWeight: FontWeight.w300),
                            )),
                        SizedBox(
                          height: 25,
                        ),
                      ]),
                  SizedBox(
                    height: 55,
                  ),
                  Container(
                      padding: EdgeInsets.only(left: 45, right: 45),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(left: 10, bottom: 10),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Start playing...',
                                style: TextStyle(
                                    fontSize: 40,
                                    color: Constants.iWhite,
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                          ),
                          CreateGameBox(),
                          SizedBox(
                            height: 6,
                          ),
                          JoinGameBox(),
                          SizedBox(
                            height: 20,
                          ),
                          rateAppButton()
                        ],
                      )),
                ],
              ),
            ),
          ),
        ));
  }
}
