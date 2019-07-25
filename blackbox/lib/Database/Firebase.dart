import 'package:blackbox/DataContainers/GroupData.dart';
import 'package:blackbox/DataContainers/UserData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Interfaces/Database.dart';

/// For documentation: please check interfaces/Database.dart
class Firebase implements Database{

  /// Not needed when using Firebase
  @override
  void openConnection(){}

  /// Not needed when using Firebase
  @override
  void closeConnection(){}

  @override
  Future< List<GroupData> > getGroups(String uniqueUserID) async
  {

    List<GroupData> groups = new List<GroupData>();

    try {
      Firestore.instance
          .collection("groups")
          .where("users", arrayContains: uniqueUserID)
          .snapshots()
          .listen (
            (snapshot) {
              // Handle all documents one by one
              for (DocumentSnapshot ds in snapshot.documents)
              {
                List<String> members = new List<String>();                

                // Get all member IDs
                for (DocumentReference dr in ds.data['members'])
                {
                  members.add(dr.path);
                }

                groups.add( new GroupData(ds.data['name'], ds.data['description'], ds.documentID.toString(), ds.data['admin'].path, members) );
              }
            }
          );

      return groups;

    } catch (Exception)
    {
        print ('Something went wrong while fetching the groups!');
    }
  }
    

  @override
  Future< UserData > getUserByID(String uniqueID) async
  {
    UserData user;

    try {
      Firestore.instance
          .collection("users")
          .where("googleID", isEqualTo: uniqueID)
          .snapshots()
          .listen (
            (snapshot) {
              // Handle all documents one by one
              for (DocumentSnapshot ds in snapshot.documents)
              {
                user = new UserData(ds.data['googleID'], ds.data['username']);
                return user;
              }
            }
          );

      return user;

    } catch (Exception)
    {
        print ('Something went wrong while fetching user ' + uniqueID);
    }
  }


  @override
  Future< GroupData > getGroupByCode(String code) async {

    try {
      Firestore.instance
          .collection("groups")
          .where("code", isEqualTo: code)
          .snapshots()
          .listen (
            (snapshot) {
              // Handle all documents one by one
              for (DocumentSnapshot ds in snapshot.documents)
              {
                List<String> members = new List<String>();                

                // Get all member IDs
                for (DocumentReference dr in ds.data['members'])
                {
                  members.add(dr.path);
                }

                return new GroupData(ds.data['name'], ds.data['description'], ds.documentID.toString(), ds.data['admin'].path, members);
              }
            }
          );

      return null;

    } catch (Exception)
    {
        print ('Something went wrong while fetching the group with id ' + code);
    }
  }



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