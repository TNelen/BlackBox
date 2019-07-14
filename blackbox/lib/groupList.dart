import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'Interfaces/Database.dart';
import 'Database/firebase.dart';
import './GroupScreen.dart';


// Tijdelijk om te kunnen testen ;)
List<String> groupNames = ["Group 1", "Group 2", "Group 3"];

class GroupList extends StatelessWidget {

  /*Database database;
  List<String> groupNames;

  GroupList( Database db )
  {
    database = db;
  }*/


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
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (BuildContext context) => GroupScreen(groupNames[index]
              ),
            ));
          },


    ),);
  }

  @override
  Widget build(BuildContext context) {

    // Gebruik globaal één instance van Database, dit is tijdelijk!
    // Via FutureBuilder zou je Widgets kunnen bouwen na te wachten op database resultaat
    //Future< List<String> > groupNames = db.getGroupNames("gtqnKc2lyo5ip2fqOAkq");



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