import 'package:cloud_firestore/cloud_firestore.dart';
import '../Interfaces/Database.dart';

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
  Future< List<String> > getGroupNames(String uniqueUserID) async
  {

    List<String> groupNames = new List<String>();

    try {
      Firestore.instance
          .collection("groups")
          //.where("users", arrayContains: uniqueUserID)
          .snapshots()
          .listen (
            (snapshot) {
              for (DocumentSnapshot ds in snapshot.documents)
              {
                groupNames.add( ds.data['name'] );
              }
            }
          );

      return groupNames;

    } catch (Exception)
    {
        print ('Something went wrong while fetching the groups!');
    } finally {
      return groupNames;
    }
  }

}