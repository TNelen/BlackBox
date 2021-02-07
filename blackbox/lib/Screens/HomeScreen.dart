import 'dart:async';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

import '../Models/UserData.dart';
import '../Database/Firebase.dart';
import '../Database/GoogleUserHandler.dart';
import 'OnlineScreens/CreateGameScreen.dart';
import 'OnlineScreens/JoinGameScreen.dart';
import 'animation/ScalePageRoute.dart';
import 'widgets/HomeScreenTopIcons.dart';
import 'widgets/home_screen_button.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart' as core;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/painting.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import '../Constants.dart';
import '../Interfaces/Database.dart';
import 'PartyScreens/CreatePartyScreen.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:blackbox/translations/homescreen.i18n.dart';


import 'package:i18n_extension/i18n_widget.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
  _HomeScreenState createState() => _HomeScreenState(database, enableOnlineMode, loggedIn);
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

    FirebaseAnalytics().logEvent(name: 'open_screen', parameters: {'screen_name': 'HomeScreen'});
  }

  ScrollController _controller = ScrollController();
  bool setScrollable = true;

  void handleOfflinePreferences() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Constants.setSoundEnabled( prefs.getBool("sounds") );
    Constants.setVibrationEnabled( prefs.getBool("vibration") );
    Constants.setNotificationsEnabled( prefs.getBool("notifications") );
  }

  @override
  void initState() {
    super.initState();
    print(Constants.getUserID());
    if (Constants.getUserID() == "Some ID" || Constants.getUserID() == "") {
      setState(() {
        handleOfflinePreferences();
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



  Future<void> login() async {
    await core.Firebase.initializeApp();

    if (Constants.getUserID() == "Some ID" || Constants.getUserID() == "") {
      ///check if user isn't logged in via google already when returning to homescreen
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

            SharedPreferences prefs = await SharedPreferences.getInstance();

            /// Put user in the database and load the info into UserData @Constants
            user.setAccent(Constants.defaultColor);
            user.setSoundEnabled( prefs.getBool("sounds") );
            user.setVibrationEnabled( prefs.getBool("vibration") );
            user.setNotificationsEnabled( prefs.getBool("notifications") );
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
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('en', ''), // English, no country code
            const Locale('nl', ''), // nl, no country code
          ],
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: "atarian",
            scaffoldBackgroundColor: Colors.transparent,
          ),
          home: I18n(

            child :Scaffold(
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
                  physics: setScrollable ? AlwaysScrollableScrollPhysics() : NeverScrollableScrollPhysics(),
                  children: [
                    SizedBox(
                      height: 5.0 * MediaQuery.of(context).devicePixelRatio,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Container(width: MediaQuery.of(context).size.width * 0.75, child: IconBar(database)),
                      (!loggedIn && enableOnlineMode)
                          ? FlatButton(
                              child: Text(
                                'Login  '.i18n,
                                style: TextStyle(color: Constants.colors[Constants.colorindex], fontSize: Constants.actionbuttonFontSize, fontWeight: FontWeight.w300),
                              ),
                              onPressed: () {
                                login();
                              },
                            )
                          : SizedBox(),
                    ]),
                    Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 15 * MediaQuery.of(context).devicePixelRatio, left: 10, right: 10),
                        child: AutoSizeText(
                          'Hi, '  + Constants.getUsername().split(" ")[0] + '!',
                          style: TextStyle(fontSize: Constants.titleFontSize, color: Constants.iWhite, fontWeight: FontWeight.w300),
                          maxLines: 1,
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Text(
                            "Welcome to BlackBox!".i18n,
                            style: TextStyle(color: Constants.colors[Constants.colorindex], fontSize: Constants.normalFontSize, fontWeight: FontWeight.w300),
                          )),
                      SizedBox(
                        height: 25,
                      ),
                    ]),
                    SizedBox(
                      height: 13 * MediaQuery.of(context).devicePixelRatio,
                    ),
                    Container(
                        padding: EdgeInsets.only(left: 45, right: 45),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(left: 10, bottom: 10 * MediaQuery.of(context).devicePixelRatio),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Start playing...'.i18n,
                                  style: TextStyle(fontSize: Constants.subtitleFontSize, color: Constants.iWhite, fontWeight: FontWeight.w300),
                                ),
                              ),
                            ),
                            Hero(
                              tag: 'partymode',
                              child: HomeScreenButton('Party Mode', 'Play with all your friends on one single device'.i18n, true, true, icon: OMIcons.peopleOutline, onTap: () {
                                Navigator.push(
                                    context,
                                    ScaleUpPageRoute(
                                        CreatePartyScreen()
                                    ));
                              }),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Hero(
                              tag: 'newgame',
                              child: HomeScreenButton('Create Game'.i18n, 'Invite friends to a new game'.i18n, enableOnlineMode, loggedIn, icon: OMIcons.edit, onTap: () {
                                Navigator.push(
                                    context,
                                    ScaleUpPageRoute(
                                      CreateGameScreen(database)
                                    ));
                              }),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Hero(
                              tag: 'joingame',
                              child: HomeScreenButton("Join Game".i18n, 'Join with the group code'.i18n, enableOnlineMode, loggedIn, icon: OMIcons.search, onTap: () {
                                Navigator.push(
                                    context,
                                    ScaleUpPageRoute(
                                      JoinGameScreen(database),
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

          ),),
        ));
  }
}
