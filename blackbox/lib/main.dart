// @dart=2.9

import 'package:blackbox/Screens/CategoryScreen.dart';
import 'package:blackbox/push_nofitications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'Constants.dart';
import 'package:blackbox/translations/translations.i18n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
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
  _SplashScreenState() {}

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print("Firebase app init complete");
      setState(() {});
    });
    PushNotificationsManager manager = PushNotificationsManager();
    manager.init();
    //load user data from localstorage
    Constants.loadData();
  }

  @override
  Widget build(BuildContext context) {
    final startButton = Card(
      //elevation: 5.0,
      color: Constants.iAccent,
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
                builder: (BuildContext context) => CategoryScreen(
                  showHelp: true,
                ),
              ));
        },
        child: Container(
          width: 200,
          height: 50,
          child: Center(
              child: FaIcon(
            FontAwesomeIcons.arrowRight,
            size: 22,
            color: Constants.iWhite,
          )),
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
              // decoration: BoxDecoration(
              //   gradient: LinearGradient(
              //     begin: Alignment.topRight,
              //     end: Alignment.bottomLeft,
              //     stops: [0.1, 0.9],
              //     colors: [
              //       Constants.gradient1,
              //       Constants.gradient2,
              //     ],
              //   ),
              // ),
              color: Constants.grey,
              child: Stack(
                  fit: StackFit.expand,
                  alignment: Alignment.topCenter,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              SizedBox(
                                height: 75,
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
                            ]),

                        Padding(
                          padding: EdgeInsets.only(bottom: 30),
                          child: Card(
                            //elevation: 5.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(35.0),
                            ),
                            color: Constants.black.withOpacity(0.7),
                            //color: Colors.grey.shade800,
                            child: Container(
                              height: 290,
                              width: MediaQuery.of(context).size.width - 50,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 25),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 25,
                                    ),
                                    Text(
                                      "Start playing now!".i18n,
                                      style: TextStyle(
                                          fontSize: Constants.normalFontSize,
                                          fontFamily: "roboto",
                                          color: Constants.iWhite,
                                          fontWeight: FontWeight.w400),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      "This is a placeholder text, im not sure what we have to put here. Maybe a short introduction"
                                          .i18n,
                                      style: TextStyle(
                                          fontSize: Constants.smallFontSize,
                                          fontFamily: "roboto",
                                          color:
                                              Constants.iWhite.withOpacity(0.6),
                                          fontWeight: FontWeight.w300),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    startButton,
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        // This is the Custom Shape Container
                      ],
                    ),
                    Center(
                        child: Container(
                            // foregroundDecoration: BoxDecoration(
                            //   color: Colors.grey.withOpacity(0.4),
                            //   backgroundBlendMode: BlendMode.saturation,
                            // ),
                            width: 300,
                            height: 300,
                            child: Image.asset(
                              "images/blueboxquestiongrey.png",
                              scale: 0.5,
                            ))),
                  ])),
        ),
      ),
    );
  }
}
