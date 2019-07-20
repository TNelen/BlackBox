class UserData {

  String _userID;
  String _username;

  UserData(String userID, String username)
  {
    this._userID = userID;
    this._username = username;
  }

  /// Get this user's display name
  String getUsername()
  {
    return _username;
  }

  /// Change the display name of this user
  void setUsername(String newName)
  {
    _username = newName;
  }

  /// Get this user's internal ID
  String getUserID()
  {
    return _userID;
  }

}