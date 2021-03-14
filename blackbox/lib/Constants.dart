import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Constants {
  static const iBlack = Color(0xFF121212);
  static const iDarkGrey = Color(0xFF21272C);
  static const iGrey = Color(0xFF577D90);
  static const iLight = Color(0xFFb3b3b3);
  static const iWhite = Color(0xFFF5F5F5);
  static const iAccent = Color(0xFF92dff3);
  static const gradient1 = Color(0xFF121212);
  static const gradient2 = Color(0xFF21272C);

  //static const gradient2 = Color(0xFF21272C);

  static int colorindex;

  //accent color list
  static const colors = [
    Color(0xFF92dff3),
    Color(0xFFffe082),
    Color(0xFFcd5c5c),
    Color(0xFF1DB854)
  ];

  static List<Color> categoryColors = [
    Colors.tealAccent[100],
    Colors.greenAccent[100],
    Colors.lightBlueAccent[100],
    Colors.deepPurple[300],
    Colors.brown[100],
    Colors.yellowAccent[100],
    Colors.deepOrange[100]
  ];

  //fontsizes
  static const titleFontSize = 50.0;
  static const subtitleFontSize = 40.0;
  static const normalFontSize = 26.0;
  static const smallFontSize = 16.0;
  static const miniFontSize = 11.0;

  static const actionbuttonFontSize = 22.0;

  static int enableVersionMSG = 0;
  static int enableWelcomeMSG = 0;
  static const enableMSG = [true, false];

  static bool _areNotificationsEnabled;
  static bool _isVibrationEnabled;
  static bool _isSoundEnabled;

  static SharedPreferences _prefs;

  static void loadData() {
    SharedPreferences.getInstance().then((value) => {
          _prefs = value,
          colorindex =
              _prefs.getInt("accent") == null ? 0 : _prefs.getInt("accent"),
          _areNotificationsEnabled = _prefs.getBool("notifications"),
          _isVibrationEnabled = _prefs.getBool("vibration"),
          _isSoundEnabled = _prefs.getBool("sounds"),
        });
  }

  //setaccentColor
  static void setAccentColor(int color) {
    colorindex = color;
    _prefs.setInt("accent", colorindex);
  }

  static bool getIsAccentcolor(int color) {
    return colorindex == color ? true : false;
  }

  //getAccentcolor
  //returns true is colorindex == color
  static int getAccentColor() {
    return colorindex ??= 0;
  }

  /// Get whether or not vibration has been enabled for this user
  static bool getVibrationEnabled() {
    return _isVibrationEnabled ??= true;
  }

  static bool getSoundEnabled() {
    return _isSoundEnabled ??= true;
  }

  static bool getNotificationsEnabled() {
    return _areNotificationsEnabled ??= true;
  }

  /// Enable or disable vibration
  static void setVibrationEnabled(bool isVibrationEnabled) {
    _isVibrationEnabled = isVibrationEnabled;
    _prefs.setBool("vibration", isVibrationEnabled);
  }

  static void setNotificationsEnabled(bool enableNotifications) {
    _areNotificationsEnabled = enableNotifications;
    _prefs.setBool("notifications", enableNotifications);
  }

  static void setSoundEnabled(bool isSoundEnabled) {
    _isSoundEnabled = isSoundEnabled;
    _prefs.setBool("sounds", isSoundEnabled);
  }
}
