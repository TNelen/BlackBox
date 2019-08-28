import 'package:flutter/material.dart';
import 'GameScreen.dart';
import '../Interfaces/Database.dart';
import 'HomeScreen.dart';
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
        theme: new ThemeData(scaffoldBackgroundColor: Constants.iBlack),
        home: Scaffold(
            appBar: AppBar(
              backgroundColor: Constants.iBlack,
              title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Constants.iAccent,
                        ),
                      ),
                      Text(
                        'Back',
                        style: TextStyle(
                          fontSize: 20,
                          color: Constants.iAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
            body: Center(
              child: Container(
                color: Constants.iBlack,
                child: ListView(

                  shrinkWrap: true,
                  padding: const EdgeInsets.all(20.0),
                  children: [
                    SizedBox(height: 20.0),
                    Hero(
                        tag: 'topicon1',
                        child: Icon(
                          Icons.perm_identity,
                          size: 75,
                          color: Constants.iAccent,
                        )),
                    SizedBox(height: 20.0),
                    Container(
                      height: 1.5,
                      color: Constants.iWhite,
                    ),
                    SizedBox(height: 40.0),
                    Text(
                      'Your Profile',
                      style: new TextStyle(
                          color: Constants.iWhite,
                          fontSize: 40.0,
                          fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
              ),
            )));
  }
}
