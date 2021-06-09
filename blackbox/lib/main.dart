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

import 'Screens/widgets/HomeScreenTopIcons.dart';
import 'Util/Curves.dart';

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
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(25.0),
        // splashColor: Constants.iAccent,
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => CategoryScreen(),
              ));
        },
        child: Container(
          width: 50,
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    SafeArea(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                width: MediaQuery.of(context).size.width * 0.75,
                                child: IconBar()),
                          ]),
                    ),
                    SizedBox(
                      height: 30,
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
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                      padding: EdgeInsets.only(bottom: 30),
                      child: Stack(alignment: Alignment.topCenter, children: [
                        Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 3,
                              ),
                              Card(
                                //elevation: 5.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(35.0),
                                ),
                                color: Colors.grey.shade800,
                                child: Container(
                                  height: 200,
                                  width: MediaQuery.of(context).size.width - 50,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 30,
                                      ),
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
                              ),
                            ]),
                        Center(
                            child: Container(
                                // foregroundDecoration: BoxDecoration(
                                //   color: Colors.grey.withOpacity(0.4),
                                //   backgroundBlendMode: BlendMode.saturation,
                                // ),
                                width: 250,
                                height: 250,
                                child: Image.asset(
                                  "images/blueboxquestiongrey.png",
                                  scale: 0.5,
                                ))),
                      ])),
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
