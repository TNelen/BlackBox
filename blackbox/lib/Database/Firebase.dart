import 'package:blackbox/DataContainers/GroupData.dart';
import 'package:blackbox/DataContainers/UserData.dart';
import 'package:blackbox/Database/FirebaseStream.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Interfaces/Database.dart';
import 'dart:math';

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
  void openConnection(){}

  /// Not needed when using Firebase
  @override
  void closeConnection(){}


  /// -------
  /// Getters
  /// -------


  @override
  Future< GroupData > getGroupFromUser(UserData userData) async
  {

    try {
      var result = Firestore.instance
          .collection("groups")
          .where("members", arrayContains: userData.getUserID())
          .snapshots();
      
      await for (final data in result){
          // Handle all documents one by one
          for (final DocumentSnapshot ds in data.documents)
          {
            List<String> members = new List<String>();
            for (dynamic member in ds.data['members'])
            {
                members.add( member );
            }

            if (ds.data['name'] == null || ds.data['description'] == null || ds.data['admin'] == null || members.length == 0)
            {
              // In this case, nothing should happen  
            } else {
              return new GroupData(ds.data['name'], ds.data['description'], ds.documentID.toString(), ds.data['admin'], members);
            }
          }

        }
    } catch (exception)
    {
        print ('Something went wrong while fetching the groups of user ' + userData.getUserID() + ' !');
    }

    return null;

  }


  @override
  Future< List<GroupData> > getGroups(String uniqueUserID) async
  {
    
    List<GroupData> groups = new List<GroupData>();

    try {
      var result = Firestore.instance
          .collection("groups")
          .where("members", arrayContains: uniqueUserID)
          .snapshots();
      
      await for (final data in result){
          // Handle all documents one by one
          for (final DocumentSnapshot ds in data.documents)
          {
            List<String> members = new List<String>();
            for (dynamic member in ds.data['members'])
            {
                members.add( member );
            }

            if (ds.data['name'] == null || ds.data['description'] == null || ds.data['admin'] == null || members.length == 0)
            {
              // In this case, nothing should happen  
            } else {
              groups.add( new GroupData(ds.data['name'], ds.data['description'], ds.documentID.toString(), ds.data['admin'], members) );
            }
          }

          return groups;

        }
    } catch (exception)
    {
        print ('Something went wrong while fetching the groups of user ' + uniqueUserID + ' !');
    }

    return groups;

  }
    

  @override
  Future< UserData > getUserByID(String uniqueID) async
  {
    UserData user;

    try {
        var document = await Firestore.instance
            .collection("users")
            .document( uniqueID ).get().then( (doc) {
              user = new UserData(doc.documentID, doc.data['name']);
            });
        
        if (user.getUserID() == null || user.getUsername() == null)
        {
          return null;
        }

        return user;
    } catch (exception)
    {
        print ('Something went wrong while fetching user ' + uniqueID);
        print(exception);
    }

    return null;

  }


  @override
  Future< GroupData > getGroupByCode(String code) async
  {
    GroupData group;

    try {
        var documentSnap = await Firestore.instance
            .collection("groups")
            .document( code ).get().then( (document) {
              /// Get all member IDs
              List<String> members = new List<String>();           
              for (String member in document.data['members'])
              {
                members.add( member );
              }

              if (document.data['name'] == null || document.data['description'] == null || document.data['admin'] == null || members.length == 0)
              {
                return null;
              }

              ///GroupData constructor: String groupName, String groupDescription, String groupID, String adminID, List<String> members
              group = new GroupData(document.data['name'], document.data['description'], document.documentID, document.data['admin'], members);
            } );
        
        return group;
    } catch (exception)
    {
        print ('Something went wrong while fetching group ' + code);
        print(exception);
    }
    return null;
  }


  @override
  Future< String > generateUniqueGroupCode() async
  { 
    bool isTaken = true;
    String newRandom;

    // While no unique ID has been found
    while ( isTaken )
    {
        // Generate a random ID
        newRandom = _getRandomID(5);

        // Check whether or not the generated ID exists 
        var documentSnap = await Firestore.instance
            .collection("groups")
            .document( newRandom ).get().then( (document) {

              // ID does not exist, unique code found!
              if ( ! document.exists )
                isTaken = false;

            } );
    }

    return newRandom;

  }

  /// Create a random alphanumeric code
  /// Returns as a String
  String _getRandomID(int length)
  {
      var random = new Random();
      String result = "";

      // Generate 'length' characters to be added to the code
      for (int i = 0; i < length; i++)
      {
          // Generate random int => [0, 35[
          int gen = random.nextInt(35);
          
          // Smaller than 25 => Generate character
          // Otherwise, add a number
          if (gen <= 24) {
            result += _intToAlphabet( gen );
          } else {
            gen -= 25;
            result += gen.toString();
          }
      }

      return result;
  }
  
  /// The int must be in the range [0, 24]
  String _intToAlphabet(int num)
  {
      // Convert int to String
      switch (num)
      {
          case 0:
            return 'A';
          case 1:
            return 'B';
          case 2:
            return 'C';
          case 3:
            return 'D';
          case 4:
            return 'E';
          case 5:
            return 'F';
          case 6:
            return 'G';
          case 7:
            return 'H';
          case 8:
            return 'I';
          case 9:
            return 'J';
          case 10:
            return 'K';
          case 11:
            return 'L';
          case 12:
            return 'M';
          case 13:
            return 'N';
          case 14:
            return 'O';
          case 15:
            return 'P';
          case 16:
            return 'Q';
          case 17:
            return 'R';
          case 18:
            return 'S';
          case 19:
            return 'T';
          case 20:
            return 'U';
          case 21:
            return 'V';
          case 22:
            return 'W';
          case 22:
            return 'X';
          case 23:
            return 'Y';
          case 24:
            return 'Z';
          default:      // Out of bounds!!
            return "";
      }
  }



  /// -------
  /// Setters
  /// -------

  @override
  void updateGroup(GroupData groupData) async {
    String code = groupData.getGroupCode();
    
    var data = new Map<String, dynamic>();
    data['name'] = groupData.getName();
    data['description'] = groupData.getDescription();
    data['admin'] = groupData.getAdminID();
    data['members'] = groupData.getMembers();

    Firestore.instance.collection("groups").document( code ).setData(data);
  }



  @override
  void updateUser(UserData userData) async {
    String uniqueID = userData.getUserID();
    
    var data = new Map<String, dynamic>();
    data['name'] = userData.getUsername();

    Firestore.instance.collection("users").document( uniqueID ).setData(data);
  }

}