import 'dart:async';
import 'dart:io';

import 'package:blackbox/models/UserData.dart';
import 'package:blackbox/Database/Firebase.dart';
import 'package:blackbox/Database/GoogleUserHandler.dart';
import 'package:blackbox/Screens/CreateGameScreen.dart';
import 'package:blackbox/Screens/JoinGameScreen.dart';
import 'package:blackbox/Screens/widgets/HomeScreenTopIcons.dart';
import 'package:blackbox/Screens/widgets/home_screen_button.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/painting.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:package_info/package_info.dart';
import '../Constants.dart';
import '../Interfaces/Database.dart';
import 'PartyScreens/CreatePartyScreen.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../models/Appinfo.dart';
import 'popups/Popup.dart';

Future<bool> checkWifi() async {
  bool on;
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      on = true;
    }
  } on SocketException catch (_) {
    on = false;
  }
  return on;
}

class HomeScreen extends StatefulWidget {
  static Database database = Firebase();
  bool enableOnlineMode = true;
  bool loggedIn = false;

  HomeScreen() {
    // Add firebase management logic here
    // FirebaseManagement dbManagement = FirebaseManagement();
    // handleAddQuestionsFromFile( dbManagement );
  }

  /*void handleAddQuestionsFromFile(FirebaseManagement management) async {
    // Read file
    String data = await rootBundle.loadString('assets/questions.txt');
    List<String> lines = data.split('\n');

    if (lines.length <= 1) {
      print("Please add more data to the file");
      return;
    }

    List<String> validQuestions = List<String>();
    for (String q in lines)
      if (q != null &&
          q != '' &&
          q != lines[0] &&
          q != lines[0].substring(0, lines[0].length - 1))
        validQuestions.add(q);
    management.addQuestions(
        lines[0].substring(0, lines[0].length - 1), validQuestions);
  }*/

  @override
  _HomeScreenState createState() =>
      _HomeScreenState(database, enableOnlineMode, loggedIn);
}

class _HomeScreenState extends State<HomeScreen> {
  Database database;
  bool enableOnlineMode;
  bool loggedIn;
  int pageIndex = 0;

  _HomeScreenState(Database db, bool enableOnlineMode, bool loggedIn) {
    this.database = db;
    this.enableOnlineMode = enableOnlineMode;
    this.loggedIn = loggedIn;

    FirebaseAnalytics().logEvent(
        name: 'open_screen', parameters: {'screen_name': 'HomeScreen'});
    if (enableOnlineMode) {
      isAppUpToDate();

      /// Show an update reminder when needed
      isWelcomeMSG();

      /// Show a message if one is set in the database
    }
  }

  ScrollController _controller = ScrollController();
  bool setScrollable = true;

  @override
  void initState() {
    super.initState();
    print(Constants.getUserID());
    if (Constants.getUserID() == "Some ID" || Constants.getUserID() == "") {
      setState(() {
        loggedIn = false;
      });
    } else {
      setState(() {
        loggedIn = true;
      });
    }

    checkWifi().then((connected) {
      if (connected != enableOnlineMode) {
        setState(() {
          enableOnlineMode = connected;
        });
        database.openConnection();
      }
    });

    Timer.periodic(Duration(seconds: 2), (Timer t) {
      checkWifi().then((connected) {
        if (connected != enableOnlineMode) {
          setState(() {
            enableOnlineMode = connected;
          });
          database.openConnection();
        }
      });
    });

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (setScrollable && _controller.position.extentAfter == 0)
        setState(() {
          setScrollable = false;
        });
    });
  }

  void isAppUpToDate() async {
    // Grab the build number of the current app from pubspec
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String buildNumberString = packageInfo.buildNumber;

    // Compare the current version by that in the database
    Appinfo appinfo;

    // Only proceed if this popup is enabled
    if (Constants.enableMSG[Constants.enableVersionMSG]) {
      appinfo = await database.getAppInfo();
      List<String> versionParts = appinfo.getVersion().toString().split('+');

      // Build numbers must exist and may not be null (see int.tryParse docs)
      if (buildNumberString == null ||
          versionParts.length < 2 ||
          versionParts[1] == null) return;

      // Convert the versions in String to int
      int currentBuid = int.tryParse(buildNumberString);
      int latestBuild = int.tryParse(versionParts[1]);

      // int.tryParse returns null on error, return if this happened
      if (currentBuid == null || latestBuild == null) return;

      print(
          'Current build number: $currentBuid - Latest build number: $latestBuild');

      // Simple version comparison
      if (currentBuid < latestBuild) {
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

  Future<void> login() async {
    if (Constants.getUserID() == "Some ID" || Constants.getUserID() == "") {
      ///check if user isn't loged in via google already when returning to homescreen
      try {
        GoogleUserHandler guh = GoogleUserHandler();
        await guh.handleSignIn().then((user) async {
          /// Log the retreived user in and update the data in the database
          UserData saved = await database.getUserByID(user.getUserID());
          setState(() {
            loggedIn = true;
          });

          /// Save user if the account is new
          if (saved == null) {
            /// Put user in the database and load the info into UserData @Constants
            user.setAccent(Constants.defaultColor);
            Constants.setUserData(user);
            await database.updateUser(user);
          } else {
            /// Load database info into UserData @Constants
            Constants.setUserData(saved);
          }
        });
      } catch (e) {
        print(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: "atarian",
            scaffoldBackgroundColor: Colors.transparent,
          ),
          home: Scaffold(
            backgroundColor: Colors.transparent,
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  stops: [0.1, 0.9],
                  colors: [
                    Constants.gradient1,
                    Constants.gradient2,
                  ],
                ),
              ),
              //margin: EdgeInsets.only(top: 16, left: 5, right: 5),
              child: ListView(
                //shrinkWrap: true,
                controller: _controller,
                physics: setScrollable
                    ? AlwaysScrollableScrollPhysics()
                    : NeverScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: 5.0 * MediaQuery.of(context).devicePixelRatio,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            width: MediaQuery.of(context).size.width * 0.75,
                            child: IconBar(database)),
                        (!loggedIn && enableOnlineMode)
                            ? FlatButton(
                                child: Text(
                                  'Login  ',
                                  style: TextStyle(
                                      color: Constants
                                          .colors[Constants.colorindex],
                                      fontSize: Constants.actionbuttonFontSize,
                                      fontWeight: FontWeight.w300),
                                ),
                                onPressed: () {
                                  login();
                                },
                              )
                            : SizedBox(),
                      ]),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: EdgeInsets.only(
                              top: 15 * MediaQuery.of(context).devicePixelRatio,
                              left: 10,
                              right: 10),
                          child: AutoSizeText(
                            'Hi, ' +
                                Constants.getUsername().split(" ")[0] +
                                '!',
                            style: TextStyle(
                                fontSize: Constants.titleFontSize,
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
                                  fontSize: Constants.normalFontSize,
                                  fontWeight: FontWeight.w300),
                            )),
                        SizedBox(
                          height: 25,
                        ),
                      ]),
                  SizedBox(
                    height: 25 * MediaQuery.of(context).devicePixelRatio,
                  ),
                  Container(
                      padding: EdgeInsets.only(left: 45, right: 45),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(
                                left: 10,
                                bottom: 10 *
                                    MediaQuery.of(context).devicePixelRatio),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Start playing...',
                                style: TextStyle(
                                    fontSize: Constants.subtitleFontSize,
                                    color: Constants.iWhite,
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                          ),
                          Hero(
                            tag: 'newgame',
                            child: HomeScreenButton(
                                'Create Game',
                                'Invite friends to a new game',
                                enableOnlineMode,
                                loggedIn,
                                icon: OMIcons.edit, onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        CreateGameScreen(database),
                                  ));
                            }),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Hero(
                            tag: 'joingame',
                            child: HomeScreenButton(
                                'Join Game',
                                'Join with the group code',
                                enableOnlineMode,
                                loggedIn,
                                icon: OMIcons.search, onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        JoinGameScreen(database),
                                  ));
                            }),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Hero(
                            tag: 'partymode',
                            child: HomeScreenButton(
                                'Party Mode',
                                'Play with all your friends on one single device',
                                true,
                                true,
                                icon: OMIcons.peopleOutline, onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        CreatePartyScreen(),
                                  ));
                            }),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ),
        ));
  }
}
