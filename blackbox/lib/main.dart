import 'dart:async';
import 'package:blackbox/Screens/CategoryScreen.dart';
import 'package:blackbox/push_nofitications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'Constants.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:blackbox/translations/translations.i18n.dart';

import 'Screens/widgets/HomeScreenTopIcons.dart';
import 'Util/Curves.dart';
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
    final startButton = Card(
      elevation: 5.0,
      color: Constants.iLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0),
        // splashColor: Constants.iAccent,
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => CategoryScreen(),
              ));
        },
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          height: 50,
          child: Padding(
            padding:
                const EdgeInsets.only(top: 3, left: 3.0, right: 3, bottom: 3),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Start',
                    style: TextStyle(
                        fontFamily: "roboto",
                        fontSize: Constants.smallFontSize,
                        color: Constants.iDarkGrey,
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  FaIcon(
                    FontAwesomeIcons.chevronCircleRight,
                    size: 22,
                    color: Constants.iDarkGrey,
                  )
                ]),
          ),
        ),
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''), // English, no country code
        const Locale('nl', ''), // nl, no country code
      ],
      title: 'BlackBox',
      theme: ThemeData(
          fontFamily: "roboto", scaffoldBackgroundColor: Constants.iBlack),
      home: I18n(
        child: Scaffold(
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
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                CustomPaint(
                  painter: StartCurvePainter(),
                ),
                Column(
                  children: [
                    Expanded(
                        flex: 6,
                        child: Column(children: <Widget>[
                          SizedBox(
                            height: 25,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.75,
                                    child: IconBar()),
                              ]),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 8,
                          ),
                          Text(
                            "BlackBox",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "atarian",
                                fontSize: Constants.titleFontSize,
                                fontWeight: FontWeight.w300),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "A MAGNETAR Game",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: Constants.normalFontSize,
                                fontFamily: "atarian",
                                fontWeight: FontWeight.w300),
                          ),
                        ])),
                    Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Start playing now!".i18n,
                            style: TextStyle(
                                fontSize: Constants.normalFontSize,
                                fontFamily: "roboto",
                                color: Constants.iWhite,
                                fontWeight: FontWeight.w300),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          startButton
                        ],
                      ),
                    ),
                  ],
                )
                // This is the Custom Shape Container
              ],
            ),
          ),
        ),
      ),
    );
  }
}
