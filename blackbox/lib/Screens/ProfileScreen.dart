import 'package:flutter/material.dart';
import '../Interfaces/Database.dart';
import 'Popup.dart';
import '../Constants.dart';

class ProfileScreen extends StatefulWidget {
  Database _database;

  ProfileScreen(Database db) {
    this._database = db;
  }

  @override
  _ProfileScreenState createState() => new _ProfileScreenState(_database);
}

class _ProfileScreenState extends State<ProfileScreen> {
  Database _database;
  TextEditingController codeController = new TextEditingController();

  _ProfileScreenState(Database db) {
    this._database = db;
  }

  @override
  Widget build(BuildContext context) {


    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BlackBox',
        home: Scaffold(
            body: Container(
              decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.blueGrey[800],Colors.cyan[800]]),
        ),
              child:Padding(
              padding: EdgeInsets.only(left: 22, right: 22),
              child: Center(
              child: Container(
                child: ListView(
                  padding: const EdgeInsets.all(20.0),
                  children: [
                   SizedBox(height: 15,),
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Icon(
                          Icons.arrow_back,
                          color: Constants.iWhite,
                        ),
                      ),
                      Text(
                        'Back',
                        style: TextStyle(
                          fontSize: 20,
                          color: Constants.iWhite,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
                    SizedBox(height: 40.0),
                    Text(
                      'Your Profile',
                      textAlign: TextAlign.center,
                      style: new TextStyle(
                          color: Constants.iWhite,
                          fontSize: 50.0,
                          fontWeight: FontWeight.w300),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      height: 1.5,
                      color: Constants.iWhite,
                    ),
                    SizedBox(height: 40.0),
                    Hero(
                        tag: 'topicon1',
                        child: Icon(
                          Icons.perm_identity,
                          size: 75,
                          color: Constants.colors[Constants.colorindex],
                        )),
                    SizedBox(height: 20.0),

                    SizedBox(height: 20.0),

                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            Constants.getUsername(),
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                                color: Constants.iWhite,
                                fontSize: 22.0,
                                fontWeight: FontWeight.w300),
                          ),
                          InkWell(
                            splashColor: Constants.colors[Constants.colorindex],
                            onTap: () {
                              Popup.makeChangeUsernamePopup(context, _database);
                            },
                            child: Icon(Icons.create,
                                color: Constants.colors[Constants.colorindex],
                                size: 30),
                          )
                        ]),
                    SizedBox(height: 15.0),

                  ],
                ),
              ),
            )))));
  }
}
