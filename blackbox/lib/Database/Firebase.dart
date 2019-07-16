import 'package:blackbox/DataContainers/GroupTileData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Interfaces/Database.dart';

import '../DataContainers/GroupTileData.dart';

/// For documentation: please check interfaces/Database.dart
class Firebase implements Database{

  /// Not needed when using Firebase
  @override
  void openConnection(){}

  /// Not needed when using Firebase
  @override
  void closeConnection(){}

  @override
  Future< List<GroupTileData> > getGroups(String uniqueUserID) async
  {

    List<GroupTileData> groups = new List<GroupTileData>();

    try {
      Firestore.instance
          .collection("groups")
          //.where("users", arrayContains: uniqueUserID)
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

                groups.add( new GroupTileData(ds.data['name'], ds.documentID.toString(), ds.data['admin'].path, members) );
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
    void removeUserFromGroup(String userID, String groupID) {}



  @override
  void addUserToGroup(String uniqueUserID, String groupID) {
    // TODO: implement addUserToGroup
  }



  @override
  void createGroup(String groupName, String adminID) {
    // TODO: implement createGroup
  }



  @override
  String getGroupIDByCode(String code) {
    // TODO: implement getGroupIDByCode
    return null;
  }

  @override
  bool isUserAdmin(String uniqueUserID, String groupID) {
    // TODO: implement isUserAdmin
    return null;
  }



  @override
  void setUserName(String uniqueUserID, String newName) {
    // TODO: implement setUserName
  }

}