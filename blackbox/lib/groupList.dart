import 'package:flutter/material.dart';

import 'Interfaces/Database.dart';
import 'Database/firebase.dart';
import './GroupScreen.dart';


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
  List<String> groupNames = ["group 1", "group 2", "group 3", "group 4", "group 5", "group 6"];


  _GroupListState(Database db)
  {
      this.database = db;
  }

  void refresh()
  {
      database.getGroupNames("").then( (names) => setState(() {

          groupNames = names;

        })
      );
  }

  Widget buildGroupItem(BuildContext context, int index) {
     String removed;
    return GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (BuildContext context) => GroupScreen(groupNames[index]
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
                    groupNames.insert(index, removed);
                    setState(() {
                      //Nothing yet
                    });
          },),),);
            removed = groupNames[index];
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

    refresh();

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
