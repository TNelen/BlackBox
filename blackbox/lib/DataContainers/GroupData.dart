class GroupData {
    
  String groupName;
  String groupDescription;
  String groupID;
  String adminID;
  List<String> members;

  GroupData(String groupName,String groupDescription, String groupID, String adminID, List<String> members)
  {
      this.groupName = groupName;
      this.groupDescription = groupDescription;
      this.groupID = groupID;
      this.adminID = adminID;
      this.members = members;
  }

  /// A temporary method for testing by printing the contents of this Object
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