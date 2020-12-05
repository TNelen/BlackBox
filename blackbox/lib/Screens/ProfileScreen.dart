import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import '../Interfaces/Database.dart';
import 'popups/Popup.dart';
import '../Constants.dart';
import 'HomeScreen.dart';

class ProfileScreen extends StatefulWidget {
  Database _database;

  ProfileScreen(Database db) {
    this._database = db;
  }

  @override
  _ProfileScreenState createState() => _ProfileScreenState(_database);
}

class _ProfileScreenState extends State<ProfileScreen> {
  Database _database;
  TextEditingController codeController = TextEditingController();

  _ProfileScreenState(Database db) {
    this._database = db;

    FirebaseAnalytics().logEvent(name: 'open_screen', parameters: {'screen_name': 'Profile'});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BlackBox',
        theme: ThemeData(fontFamily: "atarian", scaffoldBackgroundColor: Constants.iBlack),
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
                          builder: (BuildContext context) => HomeScreen(_database),
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
                  padding: const EdgeInsets.only(top: 20.0, bottom: 20, left: 50, right: 50),
                  children: [
                    SizedBox(height: 40.0),
                    Text(
                      'Your Profile',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Constants.iWhite, fontSize: Constants.titleFontSize, fontWeight: FontWeight.w300),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      height: 1.5,
                      color: Constants.iWhite,
                    ),
                    SizedBox(height: 40.0),
                    Hero(
                        tag: 'topicon1',
                        child: Icon(
                          Icons.perm_identity,
                          size: 75,
                          color: Constants.colors[Constants.colorindex],
                        )),
                    SizedBox(height: 20.0),
                    SizedBox(height: 20.0),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text(
                        Constants.getUsername(),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Constants.iWhite, fontSize: Constants.normalFontSize, fontWeight: FontWeight.w300),
                      ),
                      InkWell(
                        splashColor: Constants.colors[Constants.colorindex],
                        onTap: () {
                          Popup.makeChangeUsernamePopup(context, _database);
                        },
                        child: Icon(Icons.create, color: Constants.colors[Constants.colorindex], size: 30),
                      )
                    ]),
                    SizedBox(height: 15.0),
                  ],
                ),
              ),
            )));
  }
}
