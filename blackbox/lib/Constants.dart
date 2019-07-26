import 'package:blackbox/DataContainers/UserData.dart';
import 'DataContainers/GroupData.dart';

class Constants{

  static const List<String> choices = ['Create','Join'];
  static String username = 'timo';
  static List<GroupData> groupData = [new GroupData('group1','Dit is de descriptionsshghmgh', 'id1', 'klootzak',['lid1','lid2','klootzak','lid2','lid2']),new GroupData('group2','Dit is de blablalala', 'id2', 'timo',['lid1','timo','lid2']),new GroupData('group3','I hope this text is showing with overflow on max 2 lines as it is supposed to do in case of an overflow', 'id3', 'lid2',['lid1','lid2']),new GroupData('group4','Elon = GOD', 'id4', 'timo',['lid1','lid2','timo','lid1','lid2']),new GroupData('group5','Falcon Heavy rocks', 'id5', 'lid8',['lid1','lid4','lid1','lid8','lid1','lid25578']),new GroupData('group5','Im a musk fanboy', 'id5', 'lid8',['lid1','lid4','lid1','lid8','lid1','lid25578']),new GroupData('group5','test for string overflow to see what the list tile layout does', 'id5', 'lid8',['lid1','lid4','lid1','lid8','lid1','lid25578']),new GroupData('group5','out of inspiration', 'id5', 'lid8',['lid1','lid4','lid1','lid8','lid1','lid25578']), new GroupData('groupX','Hello There!', 'id5', 'lid8',['lid1','lid4','lid1','lid8','lid1','lid25578','lid1','lid1','lid1','lid1','lid1','lid1'])];

  static UserData userData = new UserData("timo", "someID");

  /// Set the UserData of this user
  static void setUserData(UserData newData)
  {
    userData = newData;
  }

  /// Get the name of the user who's logged in
  static String getUsername(){
    return userData.getUsername();
  }

  /// Change the name of the current user
  static void setUsername(String newName)
  {
    userData.setUsername(newName);
  }

  /// Get the unique, internal ID of the user who's logged in
  static String getUserID()
  {
    return userData.getUserID();
  }

  ///get the users of the group
  static List<String> getMembers(index)
  {
    return groupData[index].getMembers();
  }
}

