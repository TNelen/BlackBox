import 'UserData.dart';

class UserGameData extends UserData {

  bool _isReady = false;

  UserGameData(String userID, String username) : super(userID, username);

  /// Set the user ready to play
  void setReady()
  {
    _isReady = true;
  }

  /// Set the user unready to play
  void setUnready()
  {
    _isReady = false;
  }

  /// Toggle the ready status of the user
  void toggleReady()
  {
    _isReady = !_isReady;
  }

  /// Check whether or not the user is ready. Returns true or false
  bool isReady()
  {
    return _isReady;
  }

}