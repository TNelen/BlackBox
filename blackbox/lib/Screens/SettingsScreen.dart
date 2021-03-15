import 'package:blackbox/Screens/widgets/toggle_button_card.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import '../Constants.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:blackbox/translations/SettingsScreen.i18n.dart';
import 'package:blackbox/Constants.dart';
import '../main.dart';
import 'animation/ScaleDownPageRoute.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen() {}

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  TextEditingController codeController = TextEditingController();

  _SettingsScreenState() {
    FirebaseAnalytics()
        .logEvent(name: 'open_screen', parameters: {'screen_name': 'Settings'});
  }


  final GlobalKey<ToggleButtonCardState> soundKey = GlobalKey();
  final GlobalKey<ToggleButtonCardState> vibrateKey = GlobalKey();
  final GlobalKey<ToggleButtonCardState> notificationsKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Update the toggle displays

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
            fontFamily: "roboto", scaffoldBackgroundColor: Colors.transparent),
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
                                // MaterialPageRoute(
                                //   builder: (BuildContext context) => HomeScreen(),
                                // ));

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
                      ]),
                ),
                body: Container(
                  alignment: Alignment.center,
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
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(
                        left: 50, right: 50, top: 20, bottom: 20),
                    children: [
                      SizedBox(height: 20.0),
                      Text(
                        'Settings'.i18n,
                        style: TextStyle(
                            color: Constants.iWhite,
                            fontSize: Constants.normalFontSize,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 40.0),
                      Text(
                        'Sounds and vibration'.i18n,
                        style: TextStyle(
                            color: Constants.iAccent,
                            fontSize: Constants.smallFontSize,
                            fontWeight: FontWeight.w300),
                      ),
                      SizedBox(height: 5),
                      ToggleButtonCard(
                        'Sounds'.i18n,
                        Constants.getSoundEnabled(),
                        key: soundKey,
                        textStyle: TextStyle(
                          color: Constants.getSoundEnabled()
                              ? Constants.iWhite
                              : Constants.iGrey,
                          fontSize: Constants.smallFontSize,
                        ),
                        icon: Icon(
                          Icons.audiotrack,
                          size: 17,
                          color: Constants.getSoundEnabled()
                              ? Constants.iAccent
                              : Constants.iGrey,
                        ),
                        onToggle: (bool value) {
                          FirebaseAnalytics().setUserProperty(
                              name: 'is_sound_enabled',
                              value: value.toString());
                          Constants.setSoundEnabled(
                              !Constants.getSoundEnabled());

                          setState(() {});
                        },
                      ),
                      SizedBox(height: 5),
                      ToggleButtonCard(
                        'Vibration'.i18n,
                        Constants.getVibrationEnabled(),
                        key: vibrateKey,
                        textStyle: TextStyle(
                          color: Constants.getVibrationEnabled()
                              ? Constants.iWhite
                              : Constants.iGrey,
                          fontSize: Constants.smallFontSize,
                        ),
                        icon: Icon(
                          Icons.vibration,
                          size: 17,
                          color: Constants.getVibrationEnabled()
                              ? Constants.iAccent
                              : Constants.iGrey,
                        ),
                        onToggle: (bool value) {
                          FirebaseAnalytics().setUserProperty(
                              name: 'is_vibration_enabled',
                              value: value.toString());
                          Constants.setVibrationEnabled(
                              !Constants.getVibrationEnabled());

                          setState(() {});
                        },
                      ),
                      SizedBox(height: 40.0),
                      Text(
                        'Notifications'.i18n,
                        style: TextStyle(
                            color: Constants.iAccent,
                            fontSize: Constants.smallFontSize,
                            fontWeight: FontWeight.w300),
                      ),
                      SizedBox(height: 5),
                      ToggleButtonCard(
                        'Notifications'.i18n,
                        Constants.getNotificationsEnabled(),
                        key: notificationsKey,
                        textStyle: TextStyle(
                          color: Constants.getNotificationsEnabled()
                              ? Constants.iWhite
                              : Constants.iGrey,
                          fontSize: Constants.smallFontSize,
                        ),
                        icon: Icon(
                          Icons.notifications,
                          size: 17,
                          color: Constants.getNotificationsEnabled()
                              ? Constants.iAccent
                              : Constants.iGrey,
                        ),
                        onToggle: (bool value) {
                          FirebaseAnalytics().setUserProperty(
                              name: 'enable_notifications',
                              value: value.toString());
                          Constants.setNotificationsEnabled(
                              !Constants.getNotificationsEnabled());

                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ))));
  }
}
