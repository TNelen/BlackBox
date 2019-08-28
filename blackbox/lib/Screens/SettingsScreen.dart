import 'package:flutter/material.dart';
import 'GameScreen.dart';
import '../Interfaces/Database.dart';
import 'HomeScreen.dart';
import 'Popup.dart';
import '../Constants.dart';

class SettingsScreen extends StatefulWidget {
  Database _database;

  SettingsScreen(Database db) {
    this._database = db;
  }

  @override
  _SettingsScreenState createState() => new _SettingsScreenState(_database);
}

class _SettingsScreenState extends State<SettingsScreen> {
  Database _database;
  TextEditingController codeController = new TextEditingController();

  _SettingsScreenState(Database db) {
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
                      tag: 'topicon2',
                      child: Icon(
                        Icons.settings,
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
                    'Settings',
                    style: new TextStyle(
                        color: Constants.iWhite,
                        fontSize: 40.0,
                        fontWeight: FontWeight.w300),
                  ),
                  SizedBox(height: 40.0),
                  Text(
                    'Nothing here yet! Stay tuned for future updates!',
                    style: new TextStyle(
                        color: Constants.iAccent,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ))));
  }
}
