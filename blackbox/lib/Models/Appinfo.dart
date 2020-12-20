class Appinfo {
  String _version = "";
  String _loginMessage = "";

  Appinfo(this._version, this._loginMessage);

  /// Get the most recent version of the app
  String getVersion()
  {
    return _version;
  }

  /// Get the message that is shown on startup
  String getLoginMessage()
  {
    return _loginMessage;
  }

}