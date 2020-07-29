import 'dart:io';
import 'dart:typed_data';

import 'package:blackbox/Database/FirebaseManagement.dart';
import 'package:blackbox/Screens/Home/CreateGameBox.dart';
import 'package:blackbox/Screens/Home/RateAppButton.dart';
import 'package:blackbox/Screens/Home/TopIconBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../Constants.dart';
import 'CreateGameBox.dart';
import 'JoinGameBox.dart';
import '../../Interfaces/Database.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../DataContainers/Appinfo.dart';
import '../Popup.dart';

class HomeScreen extends StatefulWidget {
  Database database;

  HomeScreen(Database db) {
    database = db;
    
    // Add firebase management logic here
    FirebaseManagement dbManagement = FirebaseManagement();
    // handleAddQuestionsFromFile( dbManagement );
  }

  void handleAddQuestionsFromFile(FirebaseManagement management) async {
    
    // Read file
    String data = await rootBundle.loadString( 'assets/questions.txt' );
    List<String> lines = data.split('\n');

    if (lines.length <= 1) {
      print("Please add more data to the file");
      return;
    }

    List<String> validQuestions = List<String>();
    for (String q in lines)
      if (q != null && q != '' && q != lines[0] && q!= lines[0].substring(0, lines[0].length-1))
        validQuestions.add( q );
    management.addQuestions(lines[0].substring(0, lines[0].length-1), validQuestions);
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
  String version = '1.0.8+8';

  _HomeScreenState(Database db) {
    this.database = db;

    isAppUpToDate();

    /// Show an update reminder when needed
    isWelcomeMSG();

    /// Show a message if one is set in the database
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
                  TopIconBar.topIcons(context, database),
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
                          CreateGameBox.createGame(context, database),
                          SizedBox(
                            height: 6,
                          ),
                          JoinGameBox.joinGame(context, database),
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