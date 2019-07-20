import 'package:blackbox/DataContainers/UserData.dart';

class Constants{

  static const List<String> choices = ['Create','Join'];
  static String username = 'timo';
  UserData userData = new UserData("timo", "someID");

  /// Get the name of the user who's logged in
  String getUsername(){
    return userData.getUsername();
  }

  /// Change the name of the current user
  void setUsername(String newName)
  {
    userData.setUsername(newName);
  }

  /// Get the unique, internal ID of the user who's logged in
  String getUserID()
  {
    return userData.getUserID();
  }
}

