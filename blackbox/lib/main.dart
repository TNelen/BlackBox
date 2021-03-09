import 'dart:async';
import 'package:blackbox/push_nofitications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:blackbox/Screens/HomeScreen.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'Constants.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:firebase_admob/firebase_admob.dart';

import 'Screens/widgets/HomeScreenTopIcons.dart';
import 'ad_manager.dart';

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
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: "atarian",
          scaffoldBackgroundColor: Constants.iBlack,
        ),
        home: SplashScreen());
    //home: HomeScreen( Constants.database ));
  }
}

class SplashScreen extends StatefulWidget {
  SplashScreen() {}

  @override
  _SplashScreenState createState() => _SplashScreenState();

  SplashPage() {}
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  Future<void> _initAdMob() {
    return FirebaseAdMob.instance.initialize(appId: AdManager.appId);
  }

  _SplashScreenState() {}

  @override
  void initState() {
    super.initState();
    PushNotificationsManager manager = PushNotificationsManager();
    manager.init();
    _initAdMob();
    //load user data from localstorage
    Constants.loadData();
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
                    builder: (BuildContext context) => HomeScreen(),
                  ));
            },
            child: Text("Start game",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: Constants.actionbuttonFontSize)
                    .copyWith(
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
                        alignment: const Alignment(0, -0.7),
                        child: GlowingProgressIndicator(
                            child: CircleAvatar(
                          backgroundColor: Constants.iBlack,
                          radius: 70,
                          child: Image.asset('images/icon_transparent.png'),
                        ))),
                    Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 25,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.75,
                                  child: IconBar()),
                            ]),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 4,
                        ),
                        Text(
                          "BlackBox",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: Constants.subtitleFontSize,
                              fontWeight: FontWeight.w300),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "A MAGNETAR Game",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: Constants.smallFontSize,
                              fontWeight: FontWeight.w300),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 5,
                        ),

                        //  Container(height: 80, child: startButton)
                      ],
                    )),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 3,
                        child: Padding(
                          padding:
                              EdgeInsets.only(left: 15, right: 15, bottom: 25),
                          child: Card(
                            elevation: 5.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            color: Constants.iWhite,
                            child: Center(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Welcome to Blackox!",
                                  style: TextStyle(
                                      fontSize: 35,
                                      fontFamily: "roboto",
                                      color: Constants.iBlack,
                                      fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  "Get to know eachother",
                                  style: TextStyle(
                                      fontSize: Constants.smallFontSize,
                                      fontFamily: "roboto",
                                      color: Constants.iDarkGrey,
                                      fontWeight: FontWeight.w300),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  "Start playing now!",
                                  style: TextStyle(
                                      fontSize: Constants.smallFontSize,
                                      fontFamily: "roboto",
                                      color: Constants.iDarkGrey,
                                      fontWeight: FontWeight.w300),
                                  textAlign: TextAlign.center,
                                ),
                                startButton
                              ],
                            )),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
              ),
            ],
          )
        ],
      ),
    );
  }
}
