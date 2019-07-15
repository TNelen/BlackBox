abstract class Database {

  /// Performs actions to set up the connection to the database
  void openConnection();

  /// -------
  /// Getters
  /// -------

  /// Returns the list of group names that a user is part of
  Future< List< String> > getGroupNames(String uniqueUserID);

  /// -------
  /// Setters
  /// -------
  
  void removeUserFromGroup(String userID, String groupID);


  /// Closes the connection to the database
  void closeConnection();

}