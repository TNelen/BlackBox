class UserData {

  String _userID;
  String _username;
  int _accent = 0;

  bool _isVibrationEnabled = true;
  bool _isSoundEnabled = true;

  UserData(this._userID, this._username);

  UserData.essential(this._userID, this._username, this._accent);

  UserData.full(this._userID, this._username, this._accent, this._isVibrationEnabled, this._isSoundEnabled);

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

  /// Get whether or not vibration has been enabled for this user
  bool getVibrationEnabled()
  {
    return _isVibrationEnabled;
  }


  /// Enable or disable vibration
  void setVibrationEnabled(bool isVibrationEnabled)
  {
    _isVibrationEnabled = isVibrationEnabled;
  }


  /// Get whether or not sound has been enabled for this user
  bool getSoundEnabled()
  {
    return _isSoundEnabled;
  }


  /// Enable or disable sound
  void setSoundEnabled(bool isSoundEnabled)
  {
    _isSoundEnabled = isSoundEnabled;
  }
}