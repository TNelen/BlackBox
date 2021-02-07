import 'package:blackbox/Screens/HomeScreen.dart';
import 'package:blackbox/Screens/popups/Popup.dart';
import 'package:blackbox/Screens/widgets/toggle_button_card.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Interfaces/Database.dart';
import '../Constants.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:blackbox/translations/SettingsScreen.i18n.dart';

import 'animation/ScaleDownPageRoute.dart';

class SettingsScreen extends StatefulWidget {
  Database _database;

  SettingsScreen(Database db) {
    this._database = db;
  }

  @override
  _SettingsScreenState createState() => _SettingsScreenState(_database);
}

class _SettingsScreenState extends State<SettingsScreen> {

  Database _database;
  SharedPreferences _prefs;
  TextEditingController codeController = TextEditingController();

  _SettingsScreenState(Database db) {
    _database = db;

    FirebaseAnalytics()
        .logEvent(name: 'open_screen', parameters: {'screen_name': 'Settings'});
  }

  final GlobalKey<ToggleButtonCardState> blueKey = GlobalKey();
  final GlobalKey<ToggleButtonCardState> yellowKey = GlobalKey();
  final GlobalKey<ToggleButtonCardState> redKey = GlobalKey();
  final GlobalKey<ToggleButtonCardState> greenKey = GlobalKey();

  final GlobalKey<ToggleButtonCardState> soundKey = GlobalKey();
  final GlobalKey<ToggleButtonCardState> vibrateKey = GlobalKey();
  final GlobalKey<ToggleButtonCardState> notificationsKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((value) => _prefs = value);
  }

  @override
  Widget build(BuildContext context) {

    bool blueAccentColor    = Constants.getAccentColor(0);
    bool yellowAccentColor  = Constants.getAccentColor(1);
    bool redAccentColor     = Constants.getAccentColor(2);
    bool greenAccentColor   = Constants.getAccentColor(3);

    // Update the toggle displays
    if (blueKey.currentState != null)
      blueKey.currentState.currentValue = blueAccentColor;

    if (yellowKey.currentState != null)
      yellowKey.currentState.currentValue = yellowAccentColor;

    if (redKey.currentState != null)
      redKey.currentState.currentValue = redAccentColor;

    if (greenKey.currentState != null)
      greenKey.currentState.currentValue = greenAccentColor;

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
            fontFamily: "atarian", scaffoldBackgroundColor: Colors.transparent),
        home: I18n(

        child :Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Constants.iBlack,
              title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        // MaterialPageRoute(
                        //   builder: (BuildContext context) => HomeScreen(),
                        // ));

                        ScaleDownPageRoute(
                          fromPage: widget,
                          toPage: HomeScreen(),
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
                        'Back'.i18n,
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
                        fontSize: Constants.subtitleFontSize,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 30.0),
                  Text(
                    'Change username'.i18n,
                    style: TextStyle(
                        color: Constants.colors[Constants.colorindex],
                        fontSize: Constants.normalFontSize,
                        fontWeight: FontWeight.w300),
                  ),
                  SizedBox(height: 5),
                  Card(
                    elevation: 5.0,
                    color: Constants.iDarkGrey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: InkWell(
                      splashColor: Constants.colors[Constants.colorindex],
                      onTap: () {
                        Popup.makeChangeUsernamePopup(context, _database);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: <Widget>[
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                Constants.getUsername(),
                                style: TextStyle(
                                    color: Constants.iWhite,
                                    fontSize: Constants.actionbuttonFontSize,
                                    fontWeight: FontWeight.w300),
                              ),
                            ]),
                            Container(
                              width: 40,
                              child: Icon(
                                OMIcons.edit,
                                size: 25,
                                color: Constants.colors[Constants.colorindex],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40.0),
                  Text(
                    'Sounds and vibration'.i18n,
                    style: TextStyle(
                        color: Constants.colors[Constants.colorindex],
                        fontSize: Constants.normalFontSize,
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
                      fontSize: Constants.actionbuttonFontSize,
                    ),
                    icon: Icon(
                      Icons.audiotrack,
                      size: 17,
                      color: Constants.getSoundEnabled()
                          ? Constants.colors[Constants.colorindex]
                          : Constants.iGrey,
                    ),
                    onToggle: (bool value) {
                      FirebaseAnalytics().setUserProperty(
                          name: 'is_sound_enabled', value: value.toString());
                      Constants.setSoundEnabled(!Constants.getSoundEnabled());
                      _prefs.setBool("sounds", Constants.getSoundEnabled());
                      _database.updateUser(Constants.getUserData());
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
                      fontSize: Constants.actionbuttonFontSize,
                    ),
                    icon: Icon(
                      Icons.vibration,
                      size: 17,
                      color: Constants.getVibrationEnabled()
                          ? Constants.colors[Constants.colorindex]
                          : Constants.iGrey,
                    ),
                    onToggle: (bool value) {
                      FirebaseAnalytics().setUserProperty(
                          name: 'is_vibration_enabled',
                          value: value.toString());
                      Constants.setVibrationEnabled(!Constants.getVibrationEnabled());
                      _prefs.setBool("vibration", Constants.getVibrationEnabled());
                      _database.updateUser(Constants.getUserData());
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 40.0),
                  Text(
                    'Notifications'.i18n,
                    style: TextStyle(
                        color: Constants.colors[Constants.colorindex],
                        fontSize: Constants.normalFontSize,
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
                      fontSize: Constants.actionbuttonFontSize,
                    ),
                    icon: Icon(
                      Icons.notifications,
                      size: 17,
                      color: Constants.getNotificationsEnabled()
                          ? Constants.colors[Constants.colorindex]
                          : Constants.iGrey,
                    ),
                    onToggle: (bool value) {
                      FirebaseAnalytics().setUserProperty(
                          name: 'enable_notifications', value: value.toString());
                      Constants.setNotificationsEnabled(!Constants.getNotificationsEnabled());
                      _prefs.setBool("notifications", Constants.getNotificationsEnabled());
                      _database.updateUser(Constants.getUserData());
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 40.0),
                  Text(
                    'Personalization'.i18n,
                    style: TextStyle(
                        color: Constants.colors[Constants.colorindex],
                        fontSize: Constants.normalFontSize,
                        fontWeight: FontWeight.w300),
                  ),
                  SizedBox(height: 20.0),
                  Row(children: <Widget>[
                    Icon(
                      Icons.palette,
                      size: 20,
                      color: Constants.iWhite,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Choose your accent color...'.i18n,
                      style: TextStyle(
                          color: Constants.iWhite,
                          fontSize: Constants.smallFontSize,
                          fontWeight: FontWeight.w300),
                    ),
                  ]),
                  SizedBox(
                    height: 15,
                  ),
                  ToggleButtonCard(
                    'Blue'.i18n,
                    blueAccentColor,
                    key: blueKey,
                    icon: Icon(
                      Icons.lens,
                      size: 17,
                      color: Constants.colors[0],
                    ),
                    splashColor: Constants.colors[0],
                    onToggle: (bool value) {
                      if (value) {
                        FirebaseAnalytics().setUserProperty(
                            name: "accent_color", value: "Blue");
                        Constants.setAccentColor(1);
                        setState(() {});
                      } else {
                        blueKey.currentState.currentValue = true;
                      }
                    },
                  ),
                  SizedBox(height: 5),
                  ToggleButtonCard(
                    'Yellow'.i18n,
                    yellowAccentColor,
                    key: yellowKey,
                    icon: Icon(
                      Icons.lens,
                      size: 17,
                      color: Constants.colors[1],
                    ),
                    splashColor: Constants.colors[1],
                    onToggle: (bool value) {
                      if (value) {
                        FirebaseAnalytics().setUserProperty(
                            name: "accent_color", value: "Yellow");
                        Constants.setAccentColor(2);
                        setState(() {});
                      } else {
                        yellowKey.currentState.currentValue = true;
                      }
                    },
                  ),
                  SizedBox(height: 5),
                  ToggleButtonCard(
                    'Red'.i18n,
                    redAccentColor,
                    key: redKey,
                    icon: Icon(
                      Icons.lens,
                      size: 17,
                      color: Constants.colors[2],
                    ),
                    splashColor: Constants.colors[2],
                    onToggle: (bool value) {
                      if (value) {
                        FirebaseAnalytics().setUserProperty(
                            name: "accent_color", value: "Red");
                        Constants.setAccentColor(3);
                        setState(() {});
                      } else {
                        redKey.currentState.currentValue = true;
                      }
                    },
                  ),
                  SizedBox(height: 5),
                  ToggleButtonCard(
                    'Green'.i18n,
                    greenAccentColor,
                    key: greenKey,
                    icon: Icon(
                      Icons.lens,
                      size: 17,
                      color: Constants.colors[3],
                    ),
                    splashColor: Constants.colors[3],
                    onToggle: (bool value) {
                      if (value) {
                        FirebaseAnalytics().setUserProperty(
                            name: "accent_color", value: "Green");
                        Constants.setAccentColor(4);
                        setState(() {});
                      } else {
                        greenKey.currentState.currentValue = true;
                      }
                    },
                  ),
                ],
              ),
            ))));
  }
}
