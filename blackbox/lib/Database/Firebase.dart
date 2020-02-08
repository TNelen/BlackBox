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
    return await FirebaseDeleters.deleteGroup( group ).then((value) {
        return true;
    }).catchError((error) {
        print(error);
        return false;
    });
  }


  @override
  Future<bool> deleteQuestion(Question question) async {
    return await FirebaseDeleters.deleteQuestion( question ).then((value) {
        return true;
    }).catchError((error) {
        print(error);
        return false;
    });;
  }


  @override
  Future<bool> deleteUser(UserData user) async {
    return await FirebaseDeleters.deleteUser( user ).then((value) {
        return true;
    }).catchError((error) {
        print(error);
        return false;
    });
  }


  @override
  Future<bool> cleanGroups() async {
    return await FirebaseDeleters.cleanGroups().then((value) {
        return true;
    }).catchError((error) {
        print(error);
        return false;
    });
  }

  /// -------
  /// Utility
  /// -------


  @override
  Future<bool> doesGroupExist(String groupID) async {
    return await FirebaseUtility.doesGroupExist( groupID ).then((value) {
        return true;
    }).catchError((error) {
        print(error);
        return false;
    });
  }


  @override
  Future<bool> doesQuestionExist(String questionID) async {
    return await FirebaseUtility.doesQuestionExist( questionID ).then((value) {
        return true;
    }).catchError((error) {
        print(error);
        return false;
    });
  }

  @override
  Future<bool> doesUserExist(String userID) async {
    return await FirebaseUtility.doesUserExist( userID ).then((value) {
        return value;
    }).catchError((error) {
        print(error);
        return false;
    });
  }


  @override
  Future<String> generateUniqueGroupCode() async {
    return await FirebaseUtility.generateUniqueGroupCode().then((value) {
        return value;
    }).catchError((error) {
        print(error);
        return null;
    });
  }


  /// -------
  /// Getters
  /// -------


  @override
  Future<Appinfo> getAppInfo() async {
    return await FirebaseGetters.getAppInfo().then((value) {
        return value;
    }).catchError((error) {
        print(error);
        return null;
    });
  }


  @override
  Future<GroupData> getGroupByCode(String code) async {
    return await FirebaseGetters.getGroupByCode( code ).then((value) {
        return value;
    }).catchError((error) {
        print(error);
        return new GroupData("Default", "Default group", "00000", "None", new Map<String, String>(), new List<String>());
    });
  }


  @override
  Future<Question> getRandomQuestion(GroupData groupData, Category category) async {
    return await FirebaseGetters.getRandomQuestion( groupData , category ).then((value) {
        return value;
    }).catchError((error) {
        print(error);
        return null;
    });
  }

  @override
  Future<List<String>> createQuestionList(String category) async {
    return await FirebaseGetters.createQuestionList( category).then((value) {
        return value;
    }).catchError((error) {
        print(error);
        return null;
    });
  }
  

  @override
  Future<Question> getNextQuestion(GroupData groupData) async {
    return await FirebaseGetters.getNextQuestion( groupData).then((value) {
        return value;
    }).catchError((error) {
        print(error);
        return null;
    });
  }


  @override
  Future<UserData> getUserByID(String uniqueID) async {
    return await FirebaseGetters.getUserByID( uniqueID ).then((value) {
        return value;
    }).catchError((error) {
        print(error);
        return null;
    });
  }

  /// -------
  /// Setters
  /// -------

  @override
  Future<bool> reportQuestion(Question q, ReportType reportType) async {
    return await FirebaseSetters.reportQuestion( q , reportType ).then((value) {
        return value;
    }).catchError((error) {
        print(error);
        return false;
    });
  }

  @override
  Future<bool> submitIssue(Issue issue) async {
    return await FirebaseSetters.submitIssue( issue ).then((value) {
        return value;
    }).catchError((error) {
        print(error);
        return false;
    });
  }


  @override
  Future<bool> updateGroup(GroupData groupData) async {
    return await FirebaseSetters.updateGroup( groupData ).then((value) {
        return value;
    }).catchError((error) {
        print(error);
        return false;
    });
  }

  @override
  Future<String> updateQuestion(Question question) async {
    return await FirebaseSetters.updateQuestion( question ).then((value) {
        return value;
    }).catchError((error) {
        print(error);
        return null;
    });
  }


  @override
  Future<bool> updateUser(UserData userData) async {
    return await FirebaseSetters.updateUser( userData ).then((value) {
        return value;
    }).catchError((error) {
        print(error);
        return false;
    });
  }


  @override
  Future<bool> voteOnQuestion(Question q) async {
    return await FirebaseSetters.voteOnQuestion( q ).then((value) {
        return true;
    }).catchError((error) {
        print(error);
        return false;
    });
  }


  @override
  Future<bool> voteOnUser(GroupData groupData, String voteeID) async {
    return await FirebaseSetters.voteOnUser( groupData , voteeID ).then((value) {
        return true;
    }).catchError((error) {
        print(error);
        return false;
    });
  }
}