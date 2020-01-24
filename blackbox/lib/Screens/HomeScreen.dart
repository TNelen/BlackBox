import 'package:blackbox/Database/GoogleUserHandler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Constants.dart';
import '../Database/GoogleUserHandler.dart';
import 'CreateGameScreen.dart';
import 'JoinGameScreen.dart';
import 'ReportScreen.dart';
import 'SubmitQuestionScreen.dart';
import '../Interfaces/Database.dart';
import 'ProfileScreen.dart';
import 'SettingsScreen.dart';
import 'package:blackbox/DataContainers/Question.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../DataContainers/Appinfo.dart';
import '../DataContainers/UserData.dart';
import 'Popup.dart';

class HomeScreen extends StatefulWidget {
  Database database;

  HomeScreen(Database db) {
    database = db;
    db.openConnection();
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
  String version = '1.0.0+1';

  _HomeScreenState(Database db) {
    this.database = db;

    /// Log a user in and update variables accordingly
    if (Constants.getUserID() == "Some ID" || Constants.getUserID() == "") {
      ///check if user isn't loged in via google already when returning to homescreen
      try {
        GoogleUserHandler guh = new GoogleUserHandler();
        guh.handleSignIn().then((user) async {
          /// Log the retreived user in and update the data in the database
          UserData saved = await database.getUserByID( user.getUserID() );
          
          /// Update the in-app user data
          Constants.setUserData( user );
          
          /// Save user if the account is new
          if (saved == null)
          {
            database.updateUser( user );
          }

          /// Refresh the homescreen
          setState(() {

          });

          isAppUpToDate();  /// Show an update reminder when needed
          isWelcomeMSG();   /// Show a message if one is set in the database

          _test();
        });
      } catch (e) {
        print(e.toString());
      }
    }

    /*if (versionCodeDatabase != versionCodeYAML){
      Popup.makePopup(context, 'Whooohooo!', 'There is a new app version available!');
    }*/
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
  void _renameQuestionCategory( String from, String to) async
  {
    DocumentSnapshot snap = await Firestore.instance.collection("questions").document( "questionList" ).get();

    List<dynamic> existing = snap.data[ from ];
    List<String> newer = existing.cast<String>().toList();

    var newData = new Map<String, dynamic>();

    newData[ to ] = newer;
    await Firestore.instance.collection("questions").document( "questionList" ).updateData( newData );
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
                padding: EdgeInsets.fromLTRB(15, 25, 25, 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.create,
                      color: Constants.colors[Constants.colorindex],
                      size: 50,
                    ),
                    Text(
                      "Create Game",
                      style: TextStyle(fontSize: 20.0, color: Constants.iWhite),
                    ),
                  ],
                ),
              )),
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
                // if (GoogleUserHandler.isLoggedIn()) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          JoinGameScreen(database),
                    ));
                 //} else {
                 //Popup.makePopup(context, "Wait!", "You should be logged in to do that.");
                  //}
              },
              child: Container(
                padding: EdgeInsets.fromLTRB(15, 25, 25, 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.search,
                      color: Constants.colors[Constants.colorindex],
                      size: 50,
                    ),
                    Text(
                      "Join Game",
                      style: TextStyle(fontSize: 20.0, color: Constants.iWhite),
                    ),
                  ],
                ),
              )),
        ));
  }

  final controller = PageController(
    initialPage: 0,
    keepPage: false,
    viewportFraction: 0.5,
  );

  Widget profileCard(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 6),
        child: Card(
            color: Constants.iDarkGrey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
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
                  // } else {
                  //Popup.makePopup(context, "Wait!", "You should be logged in to do that.");
                  //}
                },
                child: Container(
                    padding: EdgeInsets.fromLTRB(25, 25, 25, 25),
                    child: Column(
                      children: <Widget>[
                        Hero(
                            tag: 'topicon1',
                            child: Icon(
                              Icons.perm_identity,
                              color: Constants.colors[Constants.colorindex],
                              size: 30,
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        AutoSizeText(
                          "Profile",
                          style:
                              TextStyle(fontSize: 15, color: Constants.iWhite),
                          maxLines: 1,
                        ),
                      ],
                    )))));
  }

  Widget settingsCard(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 6),
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
                            SettingsScreen(database),
                      ));
                },
                child: Container(
                    padding: EdgeInsets.fromLTRB(25, 25, 25, 25),
                    child: Column(
                      children: <Widget>[
                        Hero(
                            tag: 'topicon2',
                            child: Icon(
                              Icons.settings,
                              color: Constants.colors[Constants.colorindex],
                              size: 30,
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        AutoSizeText(
                          "Settings",
                          style:
                              TextStyle(fontSize: 15, color: Constants.iWhite),
                          maxLines: 1,
                        ),
                      ],
                    )))));
  }

  Widget reportIssueCard(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 6),
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
                            ReportScreen(database),
                      ));
                },
                child: Container(
                    padding: EdgeInsets.fromLTRB(25, 25, 25, 25),
                    child: Column(
                      children: <Widget>[
                        Hero(
                            tag: 'topicon3',
                            child: Icon(
                              Icons.report_problem,
                              color: Constants.colors[Constants.colorindex],
                              size: 30,
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        AutoSizeText(
                          "Report Problem",
                          style:
                              TextStyle(fontSize: 15, color: Constants.iWhite),
                          maxLines: 1,
                        ),
                      ],
                    )))));
  }

  Widget submitQuestionCard(BuildContext context) {
    return Hero(
        tag: 'topicon4',
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 6),
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
                                SubmitQuestionScreen(database),
                          ));
                    },
                    child: Container(
                        padding: EdgeInsets.fromLTRB(25, 25, 25, 25),
                        child: Column(
                          children: <Widget>[
                            Icon(
                              Icons.library_add,
                              color: Constants.colors[Constants.colorindex],
                              size: 30,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            AutoSizeText(
                              "Submit Question",
                              style: TextStyle(
                                  fontSize: 15, color: Constants.iWhite),
                              maxLines: 1,
                            ),
                          ],
                        ))))));
  }

  void pageChanged(int index) {
    setState(() {
      pageIndex = index;
    });
  }

  void isAppUpToDate() async {
    Appinfo appinfo;
    if (Constants.enableMSG[Constants.enableVersionMSG]) {
      appinfo = await database.getAppInfo();
      String versionCodeDatabase = appinfo.getVersion().toString();
      print(versionCodeDatabase);
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
      print(welcomeMessage);
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

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        scaffoldBackgroundColor: Constants.iBlack,
      ),
      home: Scaffold(
        backgroundColor: Constants.iBlack,
        body: Container(
          margin: EdgeInsets.only(top: 16, left: 8, right: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(children: <Widget>[
                Container(
                  padding:
                      EdgeInsets.only(top: height / 10, left: 10, right: 10),
                  child: AutoSizeText(
                    'Hi, ' + Constants.getUsername() + '!',
                    style: TextStyle(
                        fontSize: 50,
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
                          fontSize: 25,
                          fontWeight: FontWeight.w300),
                    )),
                SizedBox(
                  height: 25,
                ),
                Container(
                  height: 120,
                  child: PageView(
                    onPageChanged: (index) {
                      pageChanged(index);
                    },
                    scrollDirection: Axis.horizontal,
                    controller: controller,
                    children: <Widget>[
                      profileCard(context),
                      settingsCard(context),
                      reportIssueCard(context),
                      submitQuestionCard(context),
                    ],
                  ),
                ),
                DotsIndicator(
                  dotsCount: 4,
                  position: pageIndex,
                  decorator: DotsDecorator(
                    color: Constants.iWhite,
                    activeColor: Constants.colors[Constants.colorindex],
                  ),
                )
              ]),
              Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left: 10, bottom: 10),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Start playing',
                            style: TextStyle(
                                fontSize: 30,
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
                        height: 35,
                      )
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
