import 'package:flutter/material.dart';

import '../Interfaces/Database.dart';
import '../Database/Firebase.dart';

import './ProfileScreen.dart';
import './groupList.dart';
import 'package:blackbox/Screens/JoinGroupScreen.dart';
import 'package:blackbox/Screens/CreateGroupScreen.dart';

class YourGroups extends StatelessWidget {
  Database database;

  YourGroups(Database db) {
    database = db;
    db.openConnection();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return MaterialApp(
      title: 'BlackBox',
      theme: new ThemeData(scaffoldBackgroundColor: Colors.black),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: const Icon(Icons.arrow_back_ios,color: Colors.amber,),)),
              Text(
                'Your Groups',
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        body: Stack(
          children: <Widget>[
            Container(
              //padding: EdgeInsets.only(top: height/14),
              child: ListView(
                shrinkWrap: true,
                children: [
                  GroupList(database),
                  //GroupList(),
                ],
              ),
            ),
            /* Align(
                    alignment: Alignment.bottomCenter,

                    child: _buildBottomCard(width, height, context)
                ),*/
            //_buildCardsList(),
          ],
        ),
      ),
    );
  }

/*  Widget _buildBottomCard(double width, double , BuildContext context) {

      final width = MediaQuery.of(context).size.width;
      final height = MediaQuery.of(context).size.height;

      return
        Container(
        width: width,
        height: height / 11,
        padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
        decoration: BoxDecoration(
            color: Colors.amber ,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(32),
                topLeft: Radius.circular(32)
            )
        ),
        child: _buildBottomCardChildren(context),
      );
    }

    Widget _buildBottomCardChildren(BuildContext context) {
      return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(onPressed: () {
                    Navigator.pop(context);
                  }
                    ,icon:Icon(Icons.home, size: 30,),padding: EdgeInsets.all(2),),
                  /*Text('Home',
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                    ),
                  ),*/
                ]
            ),


          ]
      );
    }*/
}
