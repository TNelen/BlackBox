
import 'package:flutter/material.dart';

import 'Interfaces/Database.dart';
import 'Database/Firebase.dart';

import './ProfileScreen.dart';
import './groupList.dart';
import './JoinGroupScreen.dart';
import './CreateGroupScreen.dart';




class HomeScreen extends StatelessWidget {

    Database database;

    HomeScreen(Database db)
    {
      database = db;
      db.openConnection();
    }

    @override
    Widget build(BuildContext context) {
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

            body: ListView(
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
                        builder: (BuildContext context) => ProfilePage(),
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


                //GroupList( database ),
                GroupList(),
              ],
            ),
            bottomNavigationBar:
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
            )
        ),
      );
    }
    }



