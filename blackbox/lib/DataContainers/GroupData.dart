import 'package:cloud_firestore/cloud_firestore.dart';

class GroupData {
    
  String groupName;
  String groupDescription;
  String groupID;
  String adminID;
  List<String> _members = new List<String>();

  /// Create a group with the given data fields
  GroupData(this.groupName, this.groupDescription, this.groupID, this.adminID, this._members);

  /// Create a group from a DocumentSnapshot (Firebase)
  GroupData.fromDocumentSnapshot ( DocumentSnapshot snap ) :
    groupName = snap.data['name'] ?? "",
    groupDescription = snap.data['description'] ?? "",
    groupID = snap.documentID.toString(),
    adminID = snap.data['admin'],
    _members = _convertFirebaseList( snap.data['members'] );

  /// Convert a list from a DocumentSnapshot to a List<String>
  static List<String> _convertFirebaseList( dynamic data )
  {
    List<String> list = new List<String>();

    for (dynamic element in data)
    {
        list.add( element );
    }

    return list;
  }

  /// Adds a user to this group if he isn't included yet
  void addMember(String uniqueID)
  {
    if (_members.contains(uniqueID))
      return;

    _members.add(uniqueID);
  }

  /// Removes a user from this group
  void removeMember(String uniqueID)
  {
    _members.remove(uniqueID);
  }

  /// Gets the ID of the admin of this group
  String getAdminID()
  {
    return adminID;
  }

  /// Get the unique code of this group
  String getGroupCode()
  {
    return groupID;
  }

  /// Get the description of this group
  String getDescription()
  {
    return groupDescription;
  }

  /// Get the member IDs of the users in this group
  List<String> getMembers()
  {
    return _members;
  }

  /// Get the name of this group
  String getName()
  {
    return groupName;
  }

  /// A temporary method for testing by printing the contents of this group
  void printData()
  {
    String membersString = "";
    for (String member in _members)
    {
        membersString += member + ", ";
    }

    print("-----");
    print("GroupTileData debug message");
    print("Name: " + groupName + "\nGroupID: " + groupID + "\nadminID: " + adminID + "\nmembers:" + membersString);
    print("-----");
  }

}