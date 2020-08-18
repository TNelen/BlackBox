import 'package:auto_size_text/auto_size_text.dart';
import 'package:blackbox/Screens/HomeScreen.dart';
import 'package:blackbox/Screens/widgets/toggle_button_card.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import '../Interfaces/Database.dart';
import '../Constants.dart';

class SettingsScreen extends StatefulWidget {
  Database _database;

  SettingsScreen(Database db) {
    this._database = db;
  }

  @override
  _SettingsScreenState createState() => new _SettingsScreenState(_database);
}

class _SettingsScreenState extends State<SettingsScreen> {
  Database _database;
  TextEditingController codeController = new TextEditingController();

  _SettingsScreenState(Database db) {
    this._database = db;

    FirebaseAnalytics().logEvent(name: 'open_screen', parameters: {'screen_name': 'Settings'});
  }

  final GlobalKey<ToggleButtonCardState> blueKey = GlobalKey();
  final GlobalKey<ToggleButtonCardState> yellowKey = GlobalKey();
  final GlobalKey<ToggleButtonCardState> redKey = GlobalKey();
  final GlobalKey<ToggleButtonCardState> greenKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    bool blueAccentColor = Constants.getAccentColor(0);
    bool yellowAccentColor = Constants.getAccentColor(1);
    bool redAccentColor = Constants.getAccentColor(2);
    bool greenAccentColor = Constants.getAccentColor(3);

    // Update the toggle displays
    if (blueKey.currentState != null) blueKey.currentState.currentValue = blueAccentColor;

    if (yellowKey.currentState != null) yellowKey.currentState.currentValue = yellowAccentColor;

    if (redKey.currentState != null) redKey.currentState.currentValue = redAccentColor;

    if (greenKey.currentState != null) greenKey.currentState.currentValue = greenAccentColor;

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BlackBox',
        theme: new ThemeData(fontFamily: "atarian", scaffoldBackgroundColor: Constants.iBlack),
        home: Scaffold(
            appBar: AppBar(
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
                          fontSize: 30,
                          color: Constants.colors[Constants.colorindex],
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
            body: Padding(
                padding: EdgeInsets.only(left: 22, right: 22),
                child: Center(
                    child: Container(
                  alignment: Alignment.center,
                  color: Constants.iBlack,
                  child: ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(20.0),
                    children: [
                      SizedBox(height: 20.0),
                      Hero(
                          tag: 'topicon2',
                          child: Icon(
                            Icons.settings,
                            size: 75,
                            color: Constants.colors[Constants.colorindex],
                          )),
                      SizedBox(height: 20.0),
                      Container(
                        height: 1.5,
                        color: Constants.iWhite,
                      ),
                      SizedBox(height: 40.0),
                      Text(
                        'Settings',
                        style: new TextStyle(color: Constants.colors[Constants.colorindex], fontSize: 40.0, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 40.0),
                      Text(
                        'Sounds and vibration',
                        style: new TextStyle(color: Constants.colors[Constants.colorindex], fontSize: 30.0, fontWeight: FontWeight.w300),
                      ),
                      SizedBox(height: 5),
                      _buildMediaSetting(Icons.audiotrack, 'Sounds', 'is_sound_enabled', Constants.getSoundEnabled(), _soundAction),
                      SizedBox(height: 5),
                      _buildMediaSetting(Icons.vibration, 'Vibration', 'is_vibration_enabled', Constants.getVibrationEnabled(), _vibrationAction),
                      SizedBox(height: 40.0),
                      Text(
                        'Personalization',
                        style: new TextStyle(color: Constants.colors[Constants.colorindex], fontSize: 30.0, fontWeight: FontWeight.w300),
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
                          'Choose your accent color...',
                          style: new TextStyle(color: Constants.iWhite, fontSize: 25.0, fontWeight: FontWeight.w300),
                        ),
                      ]),
                      SizedBox(
                        height: 15,
                      ),
                      ToggleButtonCard(
                        'Blue',
                        blueAccentColor,
                        key: blueKey,
                        icon: Icon(
                          Icons.lens,
                          size: 17,
                          color: Constants.iAccent1,
                        ),
                        onToggle: (bool value) {
                          if (value) {
                            FirebaseAnalytics().setUserProperty(name: "accent_color", value: "Blue");
                            Constants.setAccentColor(1);
                            setState(() {});
                          } else {
                            blueKey.currentState.currentValue = true;
                          }
                        },
                      ),
                      SizedBox(height: 5),
                      ToggleButtonCard(
                        'Yellow',
                        yellowAccentColor,
                        key: yellowKey,
                        icon: Icon(
                          Icons.lens,
                          size: 17,
                          color: Constants.iAccent2,
                        ),
                        onToggle: (bool value) {
                          if (value) {
                            FirebaseAnalytics().setUserProperty(name: "accent_color", value: "Yellow");
                            Constants.setAccentColor(2);
                            setState(() {});
                          } else {
                            yellowKey.currentState.currentValue = true;
                          }
                        },
                      ),
                      SizedBox(height: 5),
                      ToggleButtonCard(
                        'Red',
                        redAccentColor,
                        key: redKey,
                        icon: Icon(
                          Icons.lens,
                          size: 17,
                          color: Constants.iAccent3,
                        ),
                        onToggle: (bool value) {
                          if (value) {
                            FirebaseAnalytics().setUserProperty(name: "accent_color", value: "Red");
                            Constants.setAccentColor(3);
                            setState(() {});
                          } else {
                            redKey.currentState.currentValue = true;
                          }
                        },
                      ),
                      SizedBox(height: 5),
                      ToggleButtonCard(
                        'Green',
                        greenAccentColor,
                        key: greenKey,
                        icon: Icon(
                          Icons.lens,
                          size: 17,
                          color: Constants.iAccent4,
                        ),
                        onToggle: (bool value) {
                          if (value) {
                            FirebaseAnalytics().setUserProperty(name: "accent_color", value: "Green");
                            Constants.setAccentColor(4);
                            setState(() {});
                          } else {
                            greenKey.currentState.currentValue = true;
                          }
                        },
                      ),
                    ],
                  ),
                )))));
  }

  void plusOne() => 1;

  void _vibrationAction() => Constants.setVibrationEnabled(!Constants.getVibrationEnabled());

  void _soundAction() => Constants.setSoundEnabled(!Constants.getSoundEnabled());

  Container _buildMediaSetting(IconData icon, String label, String analyticsUserProperty, bool isEnabled, Function() action) {
    Color foregroundColor;
    Color textColor;
    Color backgroundColor;
    if (isEnabled) {
      foregroundColor = Constants.colors[Constants.colorindex];
      textColor = Constants.iWhite;
      backgroundColor = Constants.iDarkGrey;
    } else {
      foregroundColor = Constants.iGrey;
      textColor = Constants.iGrey;
      backgroundColor = Constants.iDarkGrey;
    }

    return Container(
        constraints: BoxConstraints(minWidth: 100, maxWidth: 120),
        child: Card(
            color: backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Container(
                padding: EdgeInsets.fromLTRB(15, 6, 15, 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(children: [
                      Hero(
                          tag: 'topicon' + label,
                          child: Icon(
                            icon,
                            color: foregroundColor,
                            size: 17,
                          )),
                      SizedBox(
                        width: 10,
                      ),
                      AutoSizeText(
                        label,
                        style: TextStyle(fontSize: 25, color: textColor),
                        maxLines: 1,
                      ),
                    ]),
                    Switch(
                      value: isEnabled,
                      onChanged: (value) {
                        FirebaseAnalytics().setUserProperty(name: analyticsUserProperty, value: value.toString());
                        action();
                        _database.updateUser(Constants.getUserData());
                        setState(() {});
                      },
                      activeTrackColor: foregroundColor,
                      activeColor: Constants.iWhite,
                    ),
                  ],
                ))));
  }
}
