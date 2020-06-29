import 'dart:async';
import 'package:blackbox/Database/GoogleUserHandler.dart';
import 'package:flutter/material.dart';
import 'package:blackbox/Screens/Home/HomeScreen.dart';
import 'Constants.dart';
import './Database/GoogleUserHandler.dart';
import './DataContainers/UserData.dart';
import './Interfaces/Database.dart';
import 'dart:io';
import './Screens/Popup.dart';

void main() {
  try {
    runApp(MyApp());
  } catch (exception) {}
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(Constants.database));
    //home: HomeScreen( Constants.database ));
  }
}

class SplashScreen extends StatefulWidget {
  Database database;

  SplashScreen(Database db) {
    database = db;
    db.openConnection();
  }

  @override
  _SplashScreenState createState() => _SplashScreenState(database);

  SplashPage(Database db) {
    this.database = db;
  }
}

class _SplashScreenState extends State<SplashScreen> {
  Database database;
  double _progress;
  bool loggedIn = false;
  bool wifiPopup = false;

  Future<void> login() async {
    if (Constants.getUserID() == "Some ID" || Constants.getUserID() == "") {
      ///check if user isn't loged in via google already when returning to homescreen
      try {
        GoogleUserHandler guh = new GoogleUserHandler();
        guh.handleSignIn().then((user) async {
          /// Log the retreived user in and update the data in the database
          UserData saved = await database.getUserByID(user.getUserID());
          loggedIn = true;

          /// Save user if the account is new
          if (saved == null) {
            /// Put user in the database and load the info into UserData @Constants
            user.setAccent(Constants.defaultColor);
            Constants.setUserData(user);
            database.updateUser(user);
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

  _SplashScreenState(Database db) {
    this.database = db;

    login();
  }

  Future<bool> checkWifi() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _progress = 0;
    new Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        if (!wifiPopup) {
          checkWifi().then((connected) {
            if (connected) {
              wifiPopup = true;
            } else {
              Popup.makePopup(context, "Woops!",
                  "Please turn on your internet connectivity!");
              wifiPopup = true;
            }
          });
        }
        if (wifiPopup) {
          login();
        }
        if (_progress < 1.0) {
          _progress += 0.5;
          if (_progress >= 1.0) {
            _progress = 0.99;
          }
        }
        // we "finish" downloading here
        if (_progress.toStringAsFixed(2) == '0.99' && loggedIn) {
          t.cancel();
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    HomeScreen(Constants.database),
              ));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Constants.iBlack),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 5,
                child: Container(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                        backgroundColor: Constants.iBlack,
                        radius: 100,
                        child: Image.asset('images/icon_transparent.png')),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                    ),
                    Text(
                      "BlackBox",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                          fontWeight: FontWeight.w300),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "A MAGNETAR Game",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w300),
                    )
                  ],
                )),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Get to know each other!",
                      style: TextStyle(color: Constants.iAccent4, fontSize: 20),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    CircularProgressIndicator(
                      value: _progress,
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Constants.iWhite),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                    ),
                    Text(
                      (_progress * 100).toInt().toString() + "%",
                      style: TextStyle(color: Constants.iWhite, fontSize: 17),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
