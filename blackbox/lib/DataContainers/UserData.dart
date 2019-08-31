class UserData {

  String _userID;
  String _username;
  int _accent = 0;

  UserData(this._userID, this._username);

  UserData.full(this._userID, this._username, this._accent);

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

  /// Set the accent of this user
  void setAccent(int accent)
  {
    _accent = accent;
  }

  /// Get the accent of this user
  int getAccent()
  {
    return _accent;
  }
}