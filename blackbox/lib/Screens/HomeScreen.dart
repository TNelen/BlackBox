import 'package:blackbox/Database/GoogleUserHandler.dart';
import 'package:flutter/material.dart';
import '../Constants.dart';
import 'CreateGroupScreen.dart';
import 'JoinGroupScreen.dart';
import 'YourGroupsScreen.dart';
import 'ProfileScreen.dart';
import '../Interfaces/Database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget{

  Database database;

  HomeScreen(Database db)
  {
    database = db;
    db.openConnection();
  }

  @override
  _HomeScreenState createState() => _HomeScreenState(database);

  HomePage(Database db)
  {
    this.database = db;
  }


}

enum PopupNew {create, join}


class _HomeScreenState extends State<HomeScreen> {


  Database database;

  _HomeScreenState(Database db)
  {
    this.database = db;

    try {
      GoogleUserHandler guh = new GoogleUserHandler();
      guh.handleSignIn().then( (user) => print(user.getIdToken()) );
    } catch(e) {
      print(e.toString());
    }
  }



  Widget _buildBottomCard(double width, double height) {
    return Container(
      width: width,
      height: height / 4,
      padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
          color: Colors.amber ,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(32),
              topLeft: Radius.circular(32)
          )
      ),
      child: _buildBottomCardChildren(),
    );
  }


  Widget _buildBottomCardChildren() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
               Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context) => YourGroups(database),
                     ));
                   }
                   ,icon:Icon(Icons.list, size: 40,),padding: EdgeInsets.all(2),),
                Text('Groups',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ]
          ),

      Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            PopupMenuButton(
              child: Column(
                children: <Widget>[Container(child:Icon(Icons.add_circle, size: 40,),padding: EdgeInsets.only(left: 2, right:2, top:3, bottom: 5),),
          Text('New',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.bold),),],),
              onSelected: choiceAction,
              itemBuilder: (BuildContext context){
                return Constants.choices.map((String choice){
                  return PopupMenuItem<String>(
                      value: choice,
                    child:
                        Row(children: <Widget>[Text(choice), choice == Constants.choices[0]  ? Icon(Icons.add_circle_outline) : Icon(Icons.search)
                        ],
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        )
                  );
                }).toList();
              },

            )
          ]
      ),
      Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) => ProfileScreen(),
              ));
            }
                ,icon:Icon(Icons.account_box, size: 40,),padding: EdgeInsets.all(2),),
            Text('Profile',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold
              ),
            ),
          ]
      )

    ]
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return MaterialApp(
      theme: new ThemeData(scaffoldBackgroundColor: Colors.black,
      ),
      home: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.grey[300],
          title: Text('Black Box'),
          actions: <Widget>[
            IconButton(
              onPressed: (){},
              icon: Icon(Icons.notifications,
                color: Colors.blueGrey,
              ),
            )
          ],
        ),
        body: Container(
          margin: EdgeInsets.only(top: 16),
          child: Stack(
            children: <Widget>[
              Align(
                  alignment: Alignment.bottomCenter,
                  child: _buildBottomCard(width, height)
              ),
              //_buildCardsList(),
            ],
          ),
        ),
      ),);
  }

  void choiceAction(String choice){
    if(choice == Constants.choices[0]){
      print('create');
      Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context) => CreateGroupScreen()));
    }
    if(choice == Constants.choices[1]){
      print('join');
      Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context) => JoinGroupScreen()));
    }
  }
}


