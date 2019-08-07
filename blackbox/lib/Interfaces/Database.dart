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

  /// Returns the list of all the groups that a user is part of
  @Deprecated('Multiple groups are no longer supported!')
  Future< List<GroupData> > getGroups(String uniqueUserID);

  /// Get the group of a given user
  /// Returns null if no group was found
  @Deprecated('Please use FirebaseStream instead!')
  Future< GroupData > getGroupFromUser( UserData userData );

  /// Get the unique ID of a group by providing the code
  /// Will return null if the group does not exist
  Future< GroupData > getGroupByCode(String code);

  /// Get UserData from a given user ID
  /// Will return null if user does not exist
  Future< UserData > getUserByID(String uniqueID);

  /// Generates and returns a unique group ID
  /// This ID is ONLY unique for groups!!
  Future< String > generateUniqueGroupCode();


  /// -------
  /// Setters
  /// -------

  /// Updates the user with the same ID in the database to the one provided. If the user does not exist, they will be added
  void updateUser(UserData userData);

  /// Updates the group with the same unique ID. If it doesn't exist, it will be added
  void updateGroup(GroupData groupData);
}