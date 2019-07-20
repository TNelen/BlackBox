import 'package:flutter/material.dart';

import '../Interfaces/Database.dart';
import 'package:blackbox/Screens/GroupScreen.dart';
import '../DataContainers/GroupData.dart';
import '../main.dart';
import '../Constants.dart';




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

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;


     GroupData removed;
     IconData trailing;
     if (Constants.groupData[index].adminID == Constants.username) {
         trailing = Icons.star;
     }
     else  trailing = Icons.people_outline;

       return GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (BuildContext context) => GroupScreen(Constants.groupData[index]
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
                    Constants.groupData.insert(index, removed);
                    setState(() {
                      //Nothing yet
                    });
          },),),);
            removed = Constants.groupData[index];
          Constants.groupData.removeAt(index);
            setState(() {
              //Nothing yet
            });

        } ,
        child: Container(
          //height: 50,
          color: Colors.white,
          child:ListTile(
            title: Row(children: <Widget>[Container(child:Icon(trailing, size: 25,color: Colors.amber,), padding: EdgeInsets.only(right: 7),),
              Container(
                constraints: BoxConstraints(minWidth: 100, maxWidth: width-120 ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,

                  children: [
                  Text(
                    Constants.groupData[index].groupName,
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                ),
                  Text(
                    Constants.groupData[index].groupDescription,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  )

                ],),),
              ],),
            trailing:

            //als je admin bent, daar een profile icoontje zetten
            Icon(Icons.arrow_forward_ios, size: 18, color: Colors.black)//}
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
      itemCount: Constants.groupData.length,
      itemBuilder: buildGroupItem,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );

  }

}
