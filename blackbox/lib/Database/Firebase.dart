import 'package:blackbox/DataContainers/GroupTileData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Interfaces/Database.dart';

import '../DataContainers/GroupTileData.dart';

class Firebase implements Database{

  @override
  void openConnection(){}

  @override
  void closeConnection(){}

  /*
   * Get all groups that the given user is part of
   * For testing: use gtqnKc2lyo5ip2fqOAkq as input!
   * Returns a List<String> of group names.
   */
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

}