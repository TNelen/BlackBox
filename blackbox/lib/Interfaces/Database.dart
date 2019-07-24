import '../DataContainers/GroupData.dart';
import '../DataContainers/UserData.dart';

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
  Future< List<GroupData> > getGroups(String uniqueUserID);

  /// Get the unique ID of a group by providing the code
  /// Will return "" if the group does not exist!
  Future< GroupData > getGroupByCode(String code);

  /// Get UserData from a given user ID
  /// Will return 0 if user does no exist
  Future< UserData > getUserByID(String uniqueID);



  /// -------
  /// Setters
  /// -------

  /// Updates the user with the same ID in the database to the one provided. If the user does not exist, they will be added
  void updateUser(UserData userData);

  /// Updates the group with the same unique ID. If it doesn't exist, it will be added
  void updateGroup(GroupData groupData);
}