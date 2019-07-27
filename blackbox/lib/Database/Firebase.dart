import 'package:blackbox/DataContainers/GroupData.dart';
import 'package:blackbox/DataContainers/UserData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Interfaces/Database.dart';

/// For documentation: please check interfaces/Database.dart
class Firebase implements Database{

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

            groups.add( new GroupData(ds.data['name'], ds.data['description'], ds.documentID.toString(), ds.data['admin'], members) );
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
            .document( uniqueID ).get();
        
        user = new UserData(document.documentID, document.data['name']);
    } catch (Exception)
    {
        print ('Something went wrong while fetching user ' + uniqueID);
    }

    return user;

  }


  @override
  Future< GroupData > getGroupByCode(String code) async
  {
    GroupData groups;

    try {
        var document = await Firestore.instance
            .collection("groups")
            .document( code ).get();

        /// Get all member IDs
        List<String> members = new List<String>();           
        for (String member in document.data['members'])
        {
          members.add( member );
        }

        ///GroupData constructor: String groupName, String groupDescription, String groupID, String adminID, List<String> members
        groups = new GroupData(document.data['name'], document.data['description'], document.documentID, document.data['admin'].path.toString(), members);
    } catch (Exception)
    {
        print ('Something went wrong while fetching group ' + code);
    }

    return groups;
  }


  @override
  String generateUniqueGroupCode()
  {
    DocumentReference ref = Firestore.instance.collection("groups").document();
    return ref.documentID;
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