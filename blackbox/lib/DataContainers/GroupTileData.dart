class GroupTileData {
    
  String groupName;
  String groupID;
  String adminID;
  List<String> members;

  GroupTileData(String groupName, String groupID, String adminID, List<String> members)
  {
      this.groupName = groupName;
      this.groupID = groupID;
      this.adminID = adminID;
      this.members = members;
  }

}