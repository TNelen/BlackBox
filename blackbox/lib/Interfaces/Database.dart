abstract class Database {

  /**
   * Performs actions to set up the connection to the database
   */
  void openConnection();

  /**
   * Returns the list of group names that a user is part of
   */
  Future< List<String> > getGroupNames(String uniqueUserID);

  /**
   * Closes the connection to the database
   */
  void closeConnection();

}