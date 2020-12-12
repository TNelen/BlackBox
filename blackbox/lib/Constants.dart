import 'package:blackbox/DataContainers/UserData.dart';
import 'Database/Firebase.dart';
import 'Interfaces/Database.dart';
import 'package:flutter/material.dart';

class Constants {
  static const groupCodeLength = 5;
  static const iBlack = Color(0xFF121212);
  static const iDarkGrey = Color(0xFF21272C);
  static const iGrey = Color(0xFF577D90);
  static const iLight = Color(0xFFb3b3b3);
  static const iWhite = Color(0xFFF5F5F5);
  static const iAccent = Color(0xFF92dff3);
  static const gradient1 = Color(0xFF121212);
  static const gradient2 = Color(0xFF21272C);
  //static const gradient3 = Color(0xFF0c4d4d);

  static int colorindex = 0;

  /// The standard color in the app, before a user is loaded
  static int defaultColor = 0;

  /// The default color that a new user will get

  //accent color list
  static const colors = [
    Color(0xFF92dff3),
    Color(0xFFffe082),
    Color(0xFFcd5c5c),
    Color(0xFF1DB854)
  ];

  //fontsizes
  static const titleFontSize = 50.0;
  static const subtitleFontSize = 40.0;
  static const normalFontSize = 30.0;
  static const smallFontSize = 18.0;
  static const miniFontSize = 13.0;

  static const actionbuttonFontSize = 25.0;

  static int enableVersionMSG = 0;
  static int enableWelcomeMSG = 0;
  static const enableMSG = [true, false];

  static UserData userData = UserData("Some ID", "Player");
  static final Database database = Firebase();

  //setaccentColor
  static void setAccentColor(int color) {
    colorindex = color - 1;
    userData.setAccent(colorindex);
    database.updateUser(userData);
  }

  //getAccentcolor
  //returns true is colorindex == color
  static bool getAccentColor(int color) {
    if (colorindex == color) {
      return true;
    } else
      return false;
  }

  /// Set the UserData of this user
  static void setUserData(UserData newData) {
    userData = newData;
    colorindex = newData.getAccent();
  }

  /// Get the name of the user who's logged in
  static String getUsername() {
    return userData.getUsername();
  }

  static UserData getUserData() {
    return userData;
  }

  /// Change the name of the current user
  static void setUsername(String newName) {
    userData.setUsername(newName);
  }

  /// Get the unique, internal ID of the user who's logged in
  static String getUserID() {
    return userData.getUserID();
  }

  /// Get whether or not vibration has been enabled for this user
  static bool getVibrationEnabled() {
    return userData.getVibrationEnabled();
  }

  /// Enable or disable vibration
  static void setVibrationEnabled(bool isVibrationEnabled) {
    userData.setVibrationEnabled(isVibrationEnabled);
  }

  /// Get whether or not sound has been enabled for this user
  static bool getSoundEnabled() {
    return userData.getSoundEnabled();
  }

  /// Enable or disable sound
  static void setSoundEnabled(bool isSoundEnabled) {
    userData.setSoundEnabled(isSoundEnabled);
  }
}
