
import 'package:flutter/material.dart';

import '../Interfaces/Database.dart';
import '../Database/Firebase.dart';

import './ProfileScreen.dart';
import './groupList.dart';
import 'package:blackbox/Screens/JoinGroupScreen.dart';
import 'package:blackbox/Screens/CreateGroupScreen.dart';




class YourGroups extends StatelessWidget {

    Database database;

    YourGroups(Database db)
    {
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
        home: Scaffold(appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('Black Box',
            style: TextStyle(
              fontSize: 28,
              color: Colors.white,
            ),
          ),
        ),

            body: Stack(
              children: <Widget>[ListView(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          /*1*/
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /*2*/
                              Container(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Text(
                                  'Your groups',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        /*3*/

                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(Icons.account_box),
                              color: Colors.amber,
                              //size: 25,
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (BuildContext context) => ProfileScreen(),
                                ));
                              },
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 8),
                              child: Text(
                                'Profile',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.amber,
                                ),
                              ),
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),


                  GroupList( database ),
                  //GroupList(),
                ],
              ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: _buildBottomCard(width, height, context)
                ),
                //_buildCardsList(),
              ],
            ),



            /*bottomNavigationBar:
            //BUTTON SELECTION
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                children: [
                  RaisedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (BuildContext context) => JoinGroupScreen(),
                      ));
                    },

                        color: Colors.amber,
                       child: Text('Join group', style: TextStyle(
                         fontSize: 25,
                         color: Colors.white,
                       )
                    ),

                  ),
                  RaisedButton(
                    onPressed: () {Navigator.push(context, MaterialPageRoute(
                      builder: (BuildContext context) => CreateGroupScreen(),
                    ));
                    },
                    color: Colors.amber,
                      child: Text('Create group', style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                    )
                    ),

                  )
                ],
              ),
            )*/
        ),
      );
    }

    Widget _buildBottomCard(double width, double , BuildContext context) {

      final width = MediaQuery.of(context).size.width;
      final height = MediaQuery.of(context).size.height;

      return Container(
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
    }
}




