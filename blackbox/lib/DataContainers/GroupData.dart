class GroupData {
    
  String groupName;
  String groupDescription;
  String groupID;
  String adminID;
  List<String> members;

  GroupData(String groupName, String groupDescription, String groupID, String adminID, List<String> members)
  {
      this.groupName = groupName;
      this.groupDescription = groupDescription;
      this.groupID = groupID;
      this.adminID = adminID;
      this.members = members;
  }

  /// Adds a user to this group if he isn't included yet
  void addMember(String uniqueID)
  {
    if (members.contains(uniqueID))
      return;

    members.add(uniqueID);
  }

  /// Removes a user from this group
  void removeMember(String uniqueID)
  {
    members.remove(uniqueID);
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
    return members;
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
    for (String member in members)
    {
        membersString += member + ", ";
    }

    print("-----");
    print("GroupTileData debug message");
    print("Name: " + groupName + "\nGroupID: " + groupID + "\nadminID: " + adminID + "\nmembers:" + membersString);
    print("-----");
  }

}