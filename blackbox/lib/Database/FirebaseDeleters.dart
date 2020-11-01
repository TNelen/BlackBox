import 'package:blackbox/DataContainers/GroupData.dart';
import 'package:blackbox/DataContainers/UserData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'FirebaseUtility.dart';

class FirebaseDeleters {


  static Future< bool > deleteGroup(GroupData group) async {

    if ( ! await FirebaseUtility.doesGroupExist( group.getGroupCode() ) )
    {
      return false;
    }

    await Firestore.instance
      .collection('groups')
      .document( group.getGroupCode() )
      .delete();

    return true;

  }


  static Future< bool > deleteUser(UserData user) async {
    
    if ( ! await FirebaseUtility.doesUserExist( user.getUserID() ) )
    {
      return false;
    }

    await Firestore.instance
      .collection('users')
      .document( user.getUserID() )
      .delete();

    return true;

  }


  static Future< bool > cleanGroups() async {

    List<Query> queries = new List<Query>();         /// This list will contain all queries and will get all documents to be deleted
    List<String> failedGroups = new List<String>();  /// These are groups that are probably no longer compatible

    CollectionReference groupsRef = Firestore.instance.collection('groups');  /// Create a reference to the groups collection
    
    String dieterPath = 'members.BCQ9i6Z3qBZCNxhlzuhjsNnwRIs2';
    String timoPath   = 'members.GPY2pK6fqsdU0AU5IlGXhJpK8ej1';

    // Set up queries
    Query membersEmpty = groupsRef.where('members',  isNull: true);             /// Groups that have no members 
    //Query memberDieter = groupsRef.where(dieterPath, isEqualTo: 'Dieter');      /// Dieter is member
    //Query memberTimo   = groupsRef.where(timoPath,   isEqualTo: 'Timo Nelen');  /// Timo is member
    Query nameDebug    = groupsRef.where('name',     isEqualTo: 'debug');       /// Groupname = debug
    //  Does not work on maps:  Query memberName   = groupsRef.where('members', arrayContains: 'name');                         /// Testing ID 'name' is member
    //  Does not work on maps:  Query memberTe     = groupsRef.where('members', arrayContains: 'te');                           /// Testing ID 'te' is member

    // Add all queries to the list
    queries.add(membersEmpty);  //queries.add(memberDieter);
    //queries.add(memberTimo);    
    queries.add(nameDebug);

    // For logging purposes
    List<String> queryTypes = ['membersEmpty', 'memberDieter', 'memberTimo', 'groupNameDebug', 'memberTe', 'nameDebug'];  /// A list of the query names: for debugging purposes

    int i = 0;    /// To keep track of which query type to log
    /// Loop through all queries and delete groups that sattisfy all requirements
    for (Query query in queries)
    {
      await query.getDocuments().then( (groups) async {
        int numDeleted = groups.documents.length;

        for (DocumentSnapshot group in groups.documents)
        {
          try {
            GroupData groupData = GroupData.fromDocumentSnapshot(group);
            //if (groupData.getNumMembers() < 2)
            //{
              if (groupData.getName() != "S1REQ" && groupData.getName() != "ORVFA")
              {
                await deleteGroup(groupData);
              } else {
                numDeleted--;
              }
            //} else {
            //  numDeleted--;
            //}
          } catch (exception)
          {
            String groupID = group.documentID.toString();
            print("Something went wrong when reading groupdata from or deleting group " + groupID + "! Trying again later.");
            failedGroups.add(groupID);    /// Add to failed groups to try again later
          }
        }

        if (failedGroups.length != 0)
        {
          print("Retrying failed groups..");
        }

        for (String id in failedGroups)
        {
          if (id != "S1REQ" && id != "ORVFA")
          {
            try {
              GroupData groupData = new GroupData("", "", false, true, id, "", new Map<String, String>(), new List<String>()); /// Create empty group with the right ID
              await deleteGroup(groupData);                                 // Delete the group
              print("The group with ID " + id + " has now been deleted!");  // Print info
              numDeleted++;
            } catch(exc)
            {
              print("The group with ID " + id + " could NOT be deleted! Cancelling...");
            }
          }
        }

        if (numDeleted > 0)
        {
          print("Deleting groups based on: " + queryTypes[i] + " ... " + numDeleted .toString()+ " groups have been deleted!");
        }
      });

      i++;

    }   

    return true;
  }
}