import 'package:blackbox/Database/FirebaseManagement.dart';
import 'package:blackbox/Screens/widgets/RateAppButton.dart';
import 'package:blackbox/Screens/widgets/TopIconBar.dart';
import 'package:blackbox/Screens/CreateGameScreen.dart';
import 'package:blackbox/Screens/widgets/RateAppButton.dart';
import 'package:blackbox/Screens/JoinGameScreen.dart';
import 'package:blackbox/Screens/widgets/home_screen_button.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import '../Constants.dart';
import '../Interfaces/Database.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../DataContainers/Appinfo.dart';
import 'popups/Popup.dart';

class HomeScreen extends StatefulWidget {
  final Database database;

  HomeScreen(Database db) : database = db {
    // Add firebase management logic here
    // FirebaseManagement dbManagement = FirebaseManagement();
    // handleAddQuestionsFromFile( dbManagement );
  }

  void handleAddQuestionsFromFile(FirebaseManagement management) async {
    // Read file
    String data = await rootBundle.loadString('assets/questions.txt');
    List<String> lines = data.split('\n');

    if (lines.length <= 1) {
      print("Please add more data to the file");
      return;
    }

    List<String> validQuestions = List<String>();
    for (String q in lines) if (q != null && q != '' && q != lines[0] && q != lines[0].substring(0, lines[0].length - 1)) validQuestions.add(q);
    management.addQuestions(lines[0].substring(0, lines[0].length - 1), validQuestions);
  }

  @override
  _HomeScreenState createState() => _HomeScreenState(database);
}

class _HomeScreenState extends State<HomeScreen> {
  Database database;
  int pageIndex = 0;

  _HomeScreenState(Database db) {
    this.database = db;

    FirebaseAnalytics().logEvent(name: 'open_screen', parameters: {'screen_name': 'HomeScreen'});

    isAppUpToDate();

    /// Show an update reminder when needed
    isWelcomeMSG();

    /// Show a message if one is set in the database
  }

  ScrollController _controller = ScrollController();
  bool setScrollable = true;

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (setScrollable && _controller.position.extentAfter == 0)
        setState(() {
          setScrollable = false;
        });
    });
  }

  void isAppUpToDate() async {
    // Grab the version of the current app from pubspec
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version + '+' + packageInfo.buildNumber;

    // Compare the current version by that in the database
    Appinfo appinfo;
    if (Constants.enableMSG[Constants.enableVersionMSG]) {
      appinfo = await database.getAppInfo();
      String versionCodeDatabase = appinfo.getVersion().toString();
      if (versionCodeDatabase != version) {
        Constants.enableVersionMSG = 1;
        Popup.makePopup(context, 'Whooohooo!', 'A new app version is available! \n\nUpdate your app to get the best experience.');
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
              child: ListView(
                shrinkWrap: true,
                controller: _controller,
                physics: setScrollable ? AlwaysScrollableScrollPhysics() : NeverScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: 5.0 * MediaQuery.of(context).devicePixelRatio,
                  ),
                  TopIconBar.topIcons(context, database),
                  Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 15 * MediaQuery.of(context).devicePixelRatio, left: 10, right: 10),
                      child: AutoSizeText(
                        'Hi, ' + Constants.getUsername().split(" ")[0] + '!',
                        style: TextStyle(fontSize: 60, color: Constants.iWhite, fontWeight: FontWeight.w300),
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
                          style: TextStyle(color: Constants.colors[Constants.colorindex], fontSize: 30, fontWeight: FontWeight.w300),
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
                            padding: EdgeInsets.only(left: 10, bottom: 10 * MediaQuery.of(context).devicePixelRatio),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Start playing...',
                                style: TextStyle(fontSize: 40, color: Constants.iWhite, fontWeight: FontWeight.w300),
                              ),
                            ),
                          ),
                          Hero(
                            tag: 'toberutton',
                            child: HomeScreenButton('Create Game', 'Invite friends to a new game', icon: Icons.edit, onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => CreateGameScreen(database),
                                  ));
                            }),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Hero(
                            tag: 'frfr',
                            child: HomeScreenButton('Join Game', 'Join with the group code', icon: Icons.search, onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => JoinGameScreen(database),
                                  ));
                            }),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          RateAppButton.rateAppButton(context, database)
                        ],
                      )),
                ],
              ),
            ),
          ),
        ));
  }
}
