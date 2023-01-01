// @dart=2.9

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Constants {
  static const iBlack = Color(0xFF121212);
  static const iDarkGrey = Color(0xFF21272C);
  static const iGrey = Color(0xFF577D90);
  static const iLight = Color(0xFFb3b3b3);
  static const iWhite = Color(0xFFF5F5F5);
  static const iBlue = Color(0xFF00BBFF);

  static const gradient1 = Color(0xFF121212);
  static const gradient2 = Color(0xFF21272C);

  static const grey = Color(0xFF2E3139);
  static const black = Color(0xFF121924);

  static List<Color> categoryColors = [
    Colors.tealAccent[100],
    Colors.greenAccent[100],
    Colors.lightBlueAccent[100],
    Colors.deepPurple[300],
    Colors.brown[100],
    Colors.yellowAccent[100],
    Colors.deepOrange[100],
    Color.fromARGB(255, 128, 10, 55),
  ];

  //fontsizes
  static const titleFontSize = 50.0;
  static const subtitleFontSize = 40.0;
  static const normalFontSize = 30.0;
  static const smallFontSize = 20.0;
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
          _areNotificationsEnabled = _prefs.getBool("notifications"),
          _isVibrationEnabled = _prefs.getBool("vibration"),
          _isSoundEnabled = _prefs.getBool("sounds"),
        });
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
