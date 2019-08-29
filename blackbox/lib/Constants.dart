import 'package:blackbox/DataContainers/UserData.dart';
import 'DataContainers/GroupData.dart';
import 'Database/Firebase.dart';
import 'Interfaces/Database.dart';
import 'package:flutter/material.dart';


class Constants{

  static const groupCodeLength = 5;
  static const iBlack = Color(0xFF090C16);
  static const iDarkGrey = Color(0xFF404655);
  static const iGrey = Color(0xFF577D90);
  static const iLight = Color(0xFFB5C3D7);
  static const iWhite = Color(0xFFE6E7EB);
  static const iAccent = Color(0xFFA2DAAF );

   static UserData userData = new UserData("Some ID", "Elon Muskrat");
  static final Database database = new Firebase();


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

