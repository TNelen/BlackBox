import 'package:flutter/material.dart';

import '../Interfaces/Database.dart';
import 'package:blackbox/Screens/GroupScreen.dart';
import '../DataContainers/GroupData.dart';
import '../main.dart';
import '../Constants.dart';

class GroupList extends StatefulWidget {
  Database database;

  GroupList(Database db) {
    this.database = db;
  }

  @override
  _GroupListState createState() => _GroupListState(database);
}

class _GroupListState extends State<GroupList> {
  Database database;
  GroupData removed;


  _GroupListState(Database db) {
    this.database = db;
  }

  void refresh() {
    //database.getGroupNames("").then( (names) => setState(() {

    //groupNames = names;

    // })
    //);
  }


  void _showDialog(int index) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0))),
          title: Row(children: <Widget>[new Text(
            "Remove this group?",
            style: TextStyle(color: Colors.black, fontSize: 25),
          ),],),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(
                    color: Colors.amber,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                print("long press");

                removed = Constants.groupData[index];
                Constants.groupData.removeAt(index);
                Navigator.of(context).pop();

                setState(() {
                  //Nothing yet
                });
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildGroupItem(BuildContext context, int index) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    IconData trailing;
    if (Constants.groupData[index].adminID == Constants.username) {
      trailing = Icons.star;
    } else
      trailing = Icons.people_outline;

    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    GroupScreen(Constants.groupData[index]),
              ));
        },
        onLongPress: () {
          _showDialog(index);

        },
        child: Container(
          //height: 50,
          color: Colors.white,
          child: ListTile(
              title: Row(
                children: <Widget>[
                  Container(
                    child: Icon(
                      trailing,
                      size: 25,
                      color: Colors.amber,
                    ),
                    padding: EdgeInsets.only(right: 7),
                  ),
                  Container(
                    constraints:
                        BoxConstraints(minWidth: 100, maxWidth: width - 120),
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
                      ],
                    ),
                  ),
                ],
              ),
              trailing:

                  //als je admin bent, daar een profile icoontje zetten
                  Icon(Icons.arrow_forward_ios,
                      size: 18, color: Colors.black) //}
              //else{},

              ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    refresh();

    return new ListView.separated(
      scrollDirection: Axis.vertical,
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.all(8.0),
      itemCount: Constants.groupData.length,
      itemBuilder: buildGroupItem,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }
}
