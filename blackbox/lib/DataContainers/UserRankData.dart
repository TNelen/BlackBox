class UserRankData {
  
  final String id; 
  String _username;
  int _numVotes;


  /// Create a leaderboard field with a username and amount of votes
  UserRankData(this.id, this._username, this._numVotes);


  /// Get the name of this user
  String getUserName()
  {
    return _username;
  }


  /// get the amount of votes this user received
  int getNumVotes()
  {
    return _numVotes;
  }


  /// This method will print the UserRankData contents to the console
  /// Overrides Object#toString()
  @override
  String toString()
  {
    return _username + " has " + _numVotes.toString() + " votes";
  }

}