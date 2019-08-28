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
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Card(
                          color: Constants.iDarkGrey,
                          shape: RoundedRectangleBorder(
                            side: new BorderSide(
                                color: Constants.iWhite, width: 3),
                            borderRadius: BorderRadius.circular(88.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(12),
                              child: Icon(
                            Icons.perm_identity,
                            size: 125,
                            color: Constants.iAccent,
                          ))),
                      SizedBox(height: 20.0),
                      Text(
                        'Your profile',
                        style: new TextStyle(
                            color: Constants.iAccent,
                            fontSize: 40.0,
                            fontWeight: FontWeight.w300),
                      ),
                      SizedBox(height: 20.0),
                      new Container(
                        height: 1.5,
                        width: 300,
                        color: Constants.iWhite,
                      ),
                      SizedBox(height: 40.0),
                      Text(
                        'Nothing to see here... Yet!',
                        style: new TextStyle(
                            color: Constants.iWhite,
                            fontSize: 25.0,
                            fontWeight: FontWeight.w300),
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        'Stay tuned for future updates!',
                        style: new TextStyle(
                            color: Constants.iAccent,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w300),
                      ),
                    ]),
              ),
            )));
  }
}
