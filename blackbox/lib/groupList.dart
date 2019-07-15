import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'Interfaces/Database.dart';
import 'Database/firebase.dart';
import './GroupScreen.dart';


// Tijdelijk om te kunnen testen ;)

class groupList extends StatefulWidget {
  @override
  _groupListState createState() => _groupListState();
}

class _groupListState extends State<groupList> {
  List<String> groupNames = ["Group 1", "Group 2", "Group 3","Group 4", "Group 5", "Group 6"];

  @override
  Widget buildGroupItem(BuildContext context, int index) {
    return GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (BuildContext context) => GroupScreen(groupNames[index]
            ),
          ));
        },
        onLongPress: () {
          print("long press");
          groupNames.removeAt(index);
          setState(() {
            //Nothing yet
          });
        } ,
        child: Container(
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
            //als je admin bent, daar een profile icoontje zetten
            Icon(Icons.lens, size: 25, color: Colors.amber),

          ),))
    ;
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
