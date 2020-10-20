import 'package:blackbox/DataContainers/UserData.dart';
import 'Database/Firebase.dart';
import 'Interfaces/Database.dart';
import 'package:flutter/material.dart';

class Constants {
  static const groupCodeLength = 5;
  static const iBlack = Color(0xFF121212);
  static const iDarkGrey = Color(0xFF252525);
  static const iGrey = Color(0xFF577D90);
  static const iLight = Color(0xFFB5C3D7);
  static const iWhite = Color(0xFFE6E7EB);
  static const iAccent = Color(0xFF92dff3);


  static int colorindex = 1;

  /// The standard color in the app, before a user is loaded
  static int defaultColor = 1;

  /// The default color that a new user will get

  //accent color list
  static const colors = [Color(0xFF92dff3), Color(0xFFffe082), Color(0xFFcd5c5c), Color(0xFFA2DAAF)];


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

  static int enableGrammar = 0;
  static int enableDisturbing = 0;
  static int enableLove = 0;

  static void setGrammar(int bool) {
    enableGrammar = bool;
  }

  static void setDisturbing(int bool) {
    enableDisturbing = bool;
  }

  static void setLove(int bool) {
    enableLove = bool;
  }

  static const enable = [true, false];

  static UserData userData = new UserData("Some ID", "Player");
  static final Database database = new Firebase();

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
