import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

List<String> groupNames;

class GroupList extends StatelessWidget {


  /*
   * Get all groups that the given user is part of
   * For testing: use gtqnKc2lyo5ip2fqOAkq as input!
   * Returns a List<String> of group names.
   */
  void updateGroups(String uniqueUserID)
  {
    groupNames = new List<String>();
    groupNames = ["Groep 1", "Groep 2", "Groep 3", "Groep 4"];

    Firestore.instance
        .collection("groups")
        //.where("admin", isEqualTo: uniqueUserID)
        .snapshots().listen((snapshot) {
            for (DocumentSnapshot ds in snapshot.documents)
            {
              groupNames.add(ds.data['name']);
            }
        });
  }

  Widget buildGroupItem(BuildContext context, int index) {
    return new Container(
        //height: 50,
        color: Colors.white,
        child:ListTile(
          title: Text(
            groupNames[index],
            style: TextStyle(
              fontSize: 17,
              color: Colors.black,
            ),
          ),
          trailing:
          Icon(Icons.more_vert, size: 25, color: Colors.amber,),
    ),);
  }

  @override
  Widget build(BuildContext context) {

    updateGroups("gtqnKc2lyo5ip2fqOAkq");

    return new ListView.separated(
      scrollDirection:  Axis.vertical,
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.all(8.0),
      itemCount: groupNames.length,
      itemBuilder: buildGroupItem,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }
}