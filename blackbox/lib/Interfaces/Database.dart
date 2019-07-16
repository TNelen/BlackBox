import '../DataContainers/GroupTileData.dart';

abstract class Database {

  /// -----------
  /// Connections
  /// -----------

  /// Performs actions to set up the connection to the database
  void openConnection();

  /// Closes the connection to the database
  void closeConnection();



  /// -------
  /// Getters
  /// -------

  /// Returns the list of group names that a user is part of
  Future< List<GroupTileData> > getGroups(String uniqueUserID);

  /// Check whether or not a given user is an admin of a given group
  bool isUserAdmin(String uniqueUserID, String groupID);

  /// Get the unique ID of a group by providing the code
  /// Will return "" if the group does not exist!
  String getGroupIDByCode(String code);

  /// -------
  /// Setters
  /// -------

  /// Remove a given user from a group
  void removeUserFromGroup(String uniqueUserID, String groupID);

  /// Set the username of a given user
  void setUserName(String uniqueUserID, String newName);

  /// Create a new group with given name and ID of the admin
  void createGroup(String groupName, String adminID);

  /// Add a given user to a given group
  void addUserToGroup(String uniqueUserID, String groupID);
}