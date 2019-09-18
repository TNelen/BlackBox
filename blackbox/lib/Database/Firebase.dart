import 'package:blackbox/DataContainers/Appinfo.dart';
import 'package:blackbox/DataContainers/GroupData.dart';
import 'package:blackbox/DataContainers/UserData.dart';
import 'package:blackbox/DataContainers/Issue.dart';
import 'package:blackbox/Database/FirebaseDeleters.dart';
import 'package:blackbox/Database/FirebaseGetters.dart';
import 'package:blackbox/Database/FirebaseUtility.dart';
import '../DataContainers/Question.dart';
import '../Interfaces/Database.dart';

import 'FirebaseSetters.dart';

/// For documentation: please check interfaces/Database.dart
class Firebase implements Database{

  /// Singleton pattern
  static final Firebase _firebase = new Firebase._internal();

  factory Firebase() {
    return _firebase;
  }

  Firebase._internal();


  /// -----------
  /// Connections
  /// -----------


  /// Not needed when using Firebase
  @override
  void openConnection() async {}


  /// Not needed when using Firebase
  @override
  void closeConnection() async {}


  /// --------
  /// Deleters
  /// --------


  @override
  Future<bool> deleteGroup(GroupData group) async {
    return await FirebaseDeleters.deleteGroup( group );
  }


  @override
  Future<bool> deleteQuestion(Question question) async {
    return await FirebaseDeleters.deleteQuestion( question );
  }


  @override
  Future<bool> deleteUser(UserData user) async {
    return await FirebaseDeleters.deleteUser( user );
  }


  /// -------
  /// Utility
  /// -------


  @override
  Future<bool> doesGroupExist(String groupID) async {
    return await FirebaseUtility.doesGroupExist( groupID );
  }


  @override
  Future<bool> doesQuestionExist(String questionID) async {
    return await FirebaseUtility.doesQuestionExist( questionID );
  }

  @override
  Future<bool> doesUserExist(String userID) async {
    return await FirebaseUtility.doesUserExist( userID );
  }


  @override
  Future<String> generateUniqueGroupCode() async {
    return await FirebaseUtility.generateUniqueGroupCode();
  }


  /// -------
  /// Getters
  /// -------


  @override
  Future<Appinfo> getAppInfo() async {
    return await FirebaseGetters.getAppInfo();
  }


  @override
  Future<GroupData> getGroupByCode(String code) async {
    return await FirebaseGetters.getGroupByCode( code );
  }


  @override
  Future<Question> getRandomQuestion(GroupData groupData, Category category) async {
    return await FirebaseGetters.getRandomQuestion( groupData , category );
  }


  @override
  Future<UserData> getUserByID(String uniqueID) async {
    return await FirebaseGetters.getUserByID( uniqueID );
  }

  /// -------
  /// Setters
  /// -------

  @override
  Future<bool> reportQuestion(Question q, ReportType reportType) async {
    return await FirebaseSetters.reportQuestion( q , reportType );
  }

  @override
  Future<bool> submitIssue(Issue issue) async {
    return await FirebaseSetters.submitIssue( issue );
  }


  @override
  Future<bool> updateGroup(GroupData groupData) async {
    return await FirebaseSetters.updateGroup( groupData );
  }

  @override
  Future<bool> updateQuestion(Question question) async {
    return await FirebaseSetters.updateQuestion( question );
  }


  @override
  Future<bool> updateUser(UserData userData) async {
    return await FirebaseSetters.updateUser( userData );
  }


  @override
  Future<bool> voteOnQuestion(Question q) async {
    return await FirebaseSetters.voteOnQuestion( q );
  }


  @override
  Future<bool> voteOnUser(GroupData groupData, String voteeID) async {
    return await FirebaseSetters.voteOnUser( groupData , voteeID );
  }
}