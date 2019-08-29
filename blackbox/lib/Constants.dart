import 'package:blackbox/DataContainers/UserData.dart';
import 'DataContainers/GroupData.dart';
import 'Database/Firebase.dart';
import 'Interfaces/Database.dart';
import 'package:flutter/material.dart';


class Constants{

  static const groupCodeLength = 5;
  static const iBlack = Color(0xFF0E0F11);
  static const iDarkGrey = Color(0xFF30354A);
  static const iGrey = Color(0xFF577D90);
  static const iLight = Color(0xFFB5C3D7);
  static const iWhite = Color(0xFFE6E7EB);
  static const iAccent = Color(0xFF92dff3);


  static const iAccent1 = Color(0xFF92dff3);
  static const iAccent2 = Color(0xFFffbf00);
  static const iAccent3 = Color(0xFFed2939);
  static const iAccent4 = Color(0xFFA2DAAF);

 static int colorindex = 1;

  static const colors = [Color(0xFF92dff3), Color(0xFFffbf00), Color(0xFFed2939), Color(0xFFA2DAAF)];




  static UserData userData = new UserData("Some ID", "Elon MuskRat");
  static final Database database = new Firebase();

  //setaccentColor
  static void setAccentColor(int color){
   colorindex = color-1;
  }


  /// Set the UserData of this user
  static void setUserData(UserData newData)
  {
    userData = newData;
  }

  /// Get the name of the user who's logged in
  static String getUsername(){
    return userData.getUsername();
  }

  static UserData getUserData(){
    return userData;
  }


  /// Change the name of the current user
  static void setUsername(String newName)
  {
    userData.setUsername(newName);
  }


  /// Get the unique, internal ID of the user who's logged in
  static String getUserID()
  {
    return userData.getUserID();
  }


}

