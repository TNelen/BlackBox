import '../DataContainers/GroupData.dart';
import '../DataContainers/UserData.dart';
import '../DataContainers/Question.dart';

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

  /// Get a random question within the provided category
  /// The question is guaranteed to not have appeared in the two rounds before
  /// For a list of categories: check DataContainers/Question.dart
  /// The category is currently ignored
  Future< Question > getRandomQuestion( GroupData groupData, Category category );

  /// Check whether or not a group actually exists
  Future< bool > doesGroupExist( String groupID );

  /// Check whether or not a user actually exists
  Future< bool > doesUserExist( String userID );

  /// Check whether or not a question actually exists
  Future< bool > doesQuestionExist( String questionID );


  /// -------
  /// Setters
  /// -------
  
  
  /// Cast a vote on the user with id voteeID
  /// Does not check if the votee exists
  /// Does not check if this user has voted already
  /// Returns true upon completion
  Future< bool > voteOnUser(GroupData groupData, String voteeID);

  /// Updates the user with the same unique ID in the database to the one provided. If the user does not exist, they will be added
  /// Returns true when completed
  /// Never returns false
  Future< bool > updateUser( UserData userData );

  /// Updates the group with the same unique ID. If it doesn't exist, it will be added
  /// Will automatically detect a question transfer and perform it
  /// Returns true when completed
  /// Never returns false
  Future< bool > updateGroup( GroupData groupData );

  /// Updates the question with the same unique ID. If it doesn't exist, it will be added
  /// If an identical question (just question, not the ID) already exists, the action will fail silently
  /// Returns true when completed
  /// Returns false when the question already exists
  Future< bool > updateQuestion( Question question );


  /// --------
  /// Deleters
  /// --------


  /// Delete a UserData from the database
  /// Returns true when complete
  /// Returns false when the user wasn't found
  Future< bool > deleteUser( UserData user );


  /// Delete a GroupData from the database
  /// Returns true when complete
  /// Returns false when the group wasn't found
  Future< bool > deleteGroup( GroupData group );


  /// Delete a Question from the database
  /// Returns true when complete
  /// Returns false when the question wasn't found
  Future< bool > deleteQuestion( Question question );
}