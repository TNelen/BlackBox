import 'package:blackbox/Screens/rules_column.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import '../Constants.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:blackbox/translations/translations.i18n.dart';

import '../main.dart';
import 'animation/ScaleDownPageRoute.dart';

class RuleScreen extends StatefulWidget {
  RuleScreen() {}

  @override
  _RuleScreenState createState() => _RuleScreenState();
}

class _RuleScreenState extends State<RuleScreen> {
  _RuleScreenState() {
    FirebaseAnalytics().logEvent(
        name: 'open_screen', parameters: {'screen_name': 'RulesScreen'});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      title: 'BlackBox',
      theme: ThemeData(
          accentColor: Constants.iAccent,
          disabledColor: Constants.iAccent,
          fontFamily: "roboto",
          scaffoldBackgroundColor: Constants.iBlack),
      home: I18n(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Constants.iBlack,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        ScaleDownPageRoute(
                          fromPage: widget,
                          toPage: SplashScreen(),
                        ));
                  },
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Icon(
                          Icons.arrow_back,
                          color: Constants.iAccent,
                        ),
                      ),
                      Text(
                        'Back'.i18n,
                        style: TextStyle(
                          fontSize: Constants.smallFontSize,
                          color: Constants.iAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          body: Container(
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
              //shrinkWrap: true,
              padding: const EdgeInsets.only(
                  top: 20.0, bottom: 20, left: 50, right: 50),
              children: [
                SizedBox(height: 20.0),
                Text(
                  'Rules'.i18n,
                  style: TextStyle(
                      color: Constants.iWhite,
                      fontSize: Constants.normalFontSize,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 30.0),
                RulesColumn(),
                SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
