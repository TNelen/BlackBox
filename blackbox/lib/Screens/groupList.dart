import 'package:flutter/material.dart';

import '../Interfaces/Database.dart';
import '../Database/firebase.dart';
import 'package:blackbox/Screens/GroupScreen.dart';
import '../DataContainers/GroupTileData.dart';
import '../main.dart';


// Tijdelijk om te kunnen testen ;)

class GroupList extends StatefulWidget {

  Database database;


  GroupList( Database db ) {
    this.database = db;
  }

  @override
  _GroupListState createState() => _GroupListState( database );
}

class _GroupListState extends State<GroupList> {

  Database database;
  List<GroupTileData> groupData = [new GroupTileData('group1', 'id1', 'klootzak',['lid1','lid2','klootzak','lid2','lid2']),new GroupTileData('group2', 'id2', 'timo',['lid1','timo','lid2']),new GroupTileData('group3', 'id3', 'lid2',['lid1','lid2']),new GroupTileData('group4', 'id4', 'timo',['lid1','lid2','timo','lid1','lid2']),new GroupTileData('group5', 'id5', 'lid8',['lid1','lid4','lid1','lid8','lid1','lid25578']),];



  _GroupListState(Database db)
  {
      this.database = db;
  }

  void refresh()
  {
      //database.getGroupNames("").then( (names) => setState(() {

          //groupNames = names;

       // })
      //);
  }

  Widget buildGroupItem(BuildContext context, int index) {
     GroupTileData removed;
     IconData trailing;
     if (groupData[index].adminID == username) {
         trailing = Icons.star;
     }
     else  trailing = Icons.people_outline;

       return GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (BuildContext context) => GroupScreen(groupData[index]
            ),
          ));
        },
        onLongPress: () {
          print("long press");
          Scaffold.of(context).showSnackBar(SnackBar(
              content: Text('Group removed',style: TextStyle(color: Colors.white, fontSize: 15,
              ),),
              backgroundColor: Colors.black,
            duration: const Duration(seconds: 3),
              action: SnackBarAction(
                  label: 'Undo',
                  textColor: Colors.amber,
                  onPressed: () {
                    groupData.insert(index, removed);
                    setState(() {
                      //Nothing yet
                    });
          },),),);
            removed = groupData[index];
            groupData.removeAt(index);
            setState(() {
              //Nothing yet
            });

        } ,
        child: Container(
          //height: 50,
          color: Colors.white,
          child:ListTile(
            title: Text(
              groupData[index].groupName,
              style: TextStyle(
                fontSize: 17,
                color: Colors.black,
              ),
            ),
            trailing:

            //als je admin bent, daar een profile icoontje zetten
            Icon(trailing, size: 25, color: Colors.amber)//}
            //else{},

          ),))
    ;
  }

  @override
  Widget build(BuildContext context) {

    refresh();

    return new ListView.separated(
      scrollDirection:  Axis.vertical,
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.all(8.0),
      itemCount: groupData.length,
      itemBuilder: buildGroupItem,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );

  }

}
