import 'package:blackbox/models/Appinfo.dart';

import '../models/GroupData.dart';
import '../models/UserData.dart';
import '../models/Question.dart';
import '../models/Issue.dart';

/// An enum, designated to reporting a question
enum ReportType { CATEGORY, GRAMMAR, DISTURBING, LOVE }

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

  /// Get the unique ID of a group by providing the code
  /// Will return null if the group does not exist
  /// Will return a default group (see below) when an error occurred
  /// new GroupData("Default", "Default group", "00000", "None", new Map<String, String>(), new List<String>());
  Future<GroupData> getGroupByCode(String code);

  /// Get UserData from a given user ID
  /// Will return null if user does not exist or an error occurred
  Future<UserData> getUserByID(String uniqueID);

  /// Generates and returns a unique group ID
  /// This ID is ONLY unique for groups!!
  /// Returns null if an error occurred
  Future<String> generateUniqueGroupCode();

  /// Get the next question in the list
  /// Returns null if an error occurred
  Future<Question> getNextQuestion(GroupData groupData);

  ///Create question list
  /// Returns null if an error occurred
  Future<List<String>> createQuestionList(String category);

  /// Check whether or not a group actually exists
  /// Returns true if the group exists
  /// Returns false if the group does not exist or an error occurred
  Future<bool> doesGroupExist(String groupID);

  /// Check whether or not a user actually exists
  /// Returns true if the user exists
  /// Returns false if the user does not exist or an error occurred
  Future<bool> doesUserExist(String userID);

  /// Check whether or not a question actually exists
  /// Returns true if the question exists
  /// Returns false if the question does not exist or an error occurred
  Future<bool> doesQuestionExist(String questionID);

  /// Get the most up-to-date app info
  /// Returns null if an error occurred
  Future<Appinfo> getAppInfo();

  /// -------
  /// Setters
  /// -------

  /// Cast a vote on the user with id voteeID
  /// Does not check if the votee exists
  /// Does not check if this user has voted already
  /// Returns true upon completion
  /// Returns false if the update failed
  Future<bool> voteOnUser(GroupData groupData, String voteeID);

  /// Cast a vote on this community question
  /// Users can vote multiple times, no check is included
  /// Returns false if the question is not a community question or when the question has no ID
  /// Will also return false if the question was not found in the database
  /// Returns true upon completion
  /// Returns false if the update failed
  Future<bool> voteOnQuestion(Question q);

  /// Updates the user with the same unique ID in the database to the one provided. If the user does not exist, they will be added
  /// Returns true when completed
  /// Returns false if the update failed
  Future<bool> updateUser(UserData userData);

  /// Updates the group with the same unique ID. If it doesn't exist, it will be added
  /// Will automatically detect a question transfer and perform it
  /// Returns true when completed
  /// Returns false if the update failed
  Future<bool> updateGroup(GroupData groupData);

  /// Updates the question with the same unique ID. If it doesn't exist, it will be added
  /// If an identical question (just question, not the ID) already exists, the action will fail silently
  /// Returns questionID when completed
  /// Returns null when the question already exists or an error occurred
  Future<String> updateQuestion(Question question);

  /// Send a new issue to the database
  /// Returns true when completed
  /// Returns false on error
  Future<bool> submitIssue(Issue issue);

  /// --------
  /// Deleters
  /// --------

  /// Delete a UserData from the database
  /// Returns true when complete
  /// Returns false when the user wasn't found or an error occurred
  Future<bool> deleteUser(UserData user);

  /// Delete a GroupData from the database
  /// Returns true when complete
  /// Returns false when the group wasn't found or an error occurred
  Future<bool> deleteGroup(GroupData group);

  /// Delete unused and/or testing groups from the database
  /// This action is PERMANENT. A group is deleted if it complies with ONE of the following criteria:
  ///   (- Has no members) -> Not possible with Firebase. A workaround may be added
  ///   - Only has one member with ID: a developer's ID
  ///   - Group name is equal to 'debug'
  /// AND must comply with the following:
  ///   - Its name is not ORVFA or S1REQ
  /// Returns true upon successful completion
  /// Returns false after an error
  Future<bool> cleanGroups();
}
