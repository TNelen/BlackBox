import 'dart:async';
import 'package:blackbox/Database/GoogleUserHandler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:blackbox/Screens/HomeScreen.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'Constants.dart';
import './Database/GoogleUserHandler.dart';
import './DataContainers/UserData.dart';
import './Interfaces/Database.dart';
import 'dart:io';
import './Screens/popups/Popup.dart';
import 'package:progress_indicators/progress_indicators.dart';

void main() {
  try {
    runApp(MyApp());
  } catch (exception) {}
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(debugShowCheckedModeBanner: false, home: SplashScreen(Constants.database));
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

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  Database database;
  double _progress;
  bool loggedIn = false;
  bool wifiPopup = false;

  Future<void> login() async {
    if (Constants.getUserID() == "Some ID" || Constants.getUserID() == "") {
      ///check if user isn't loged in via google already when returning to homescreen
      try {
        GoogleUserHandler guh = GoogleUserHandler();
        await guh.handleSignIn().then((user) async {
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

  @override
  void initState() {
    super.initState();

    _progress = 0;
    Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        if (!wifiPopup) {
          checkWifi().then((connected) {
            if (connected) {
              wifiPopup = true;
            } else {
              Popup.makePopup(context, "Woops!", "Please turn on your internet connectivity!");
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
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final startButton = Padding(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 80),
        child: Material(
          elevation: 1.0,
          borderRadius: BorderRadius.circular(28.0),
          color: Constants.iDarkGrey,
          child: MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28.0),
            ),
            minWidth: MediaQuery.of(context).size.width,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => HomeScreen(Constants.database),
                  ));
            },
            child: Text("Start game",
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: "atarian", fontSize: Constants.actionbuttonFontSize).copyWith(
                  color: Constants.iWhite,
                )),
          ),
        ));

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
                flex: 1,
                child: Container(
                    child: Stack(
                  children: <Widget>[
                    Align(
                        alignment: const Alignment(0, -0.5),
                        child: GlowingProgressIndicator(
                            child: CircleAvatar(
                          backgroundColor: Constants.iBlack,
                          radius: 70,
                          child: Image.asset('images/icon_transparent.png'),
                        ))),
                    Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 4,
                        ),
                        Text(
                          "BlackBox",
                          style: TextStyle(fontFamily: "atarian", color: Colors.white, fontSize: Constants.subtitleFontSize, fontWeight: FontWeight.w300),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "A MAGNETAR Game",
                          style: TextStyle(fontFamily: "atarian", color: Colors.white, fontSize: Constants.smallFontSize, fontWeight: FontWeight.w300),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 5,
                        ),
                        loggedIn
                            ? Container(height: 80, child: startButton)
                            : Container(
                                height: 80,
                                child: FadingText(
                                  "Logging you in...",
                                  style: TextStyle(fontFamily: "atarian", color: Constants.iWhite, fontSize: Constants.smallFontSize, fontWeight: FontWeight.w300),
                                )),
                      ],
                    ))
                  ],
                )),
              ),
              /*SizedBox(
                height: MediaQuery.of(context).size.height / 2.5,
              )*/
            ],
          )
        ],
      ),
    );
  }
}
