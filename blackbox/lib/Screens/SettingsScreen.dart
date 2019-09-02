import 'package:flutter/material.dart';
import '../Interfaces/Database.dart';
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
    final blueAccent = Card(
      color: Constants.iDarkGrey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: InkWell(
          splashColor: Constants.iAccent1,
          onTap: () {
            Constants.setAccentColor(1);
            setState(() {

            });
          },
          child: Container(
            padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Mighty Blue",
                  style: TextStyle(fontSize: 20.0, color: Constants.iWhite),
                ),
                Icon(
                  Icons.lens,
                  color: Constants.iAccent1,
                  size: 30,
                ),
              ],
            ),
          )),
    );

    final yellowAccent = Card(
      color: Constants.iDarkGrey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: InkWell(
          splashColor: Constants.iAccent2,
          onTap: () {
            Constants.setAccentColor(2);
            setState(() {

            });
          },
          child: Container(
            padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Magnificent Yellow',
                  style: TextStyle(fontSize: 20.0, color: Constants.iWhite),
                ),
                Icon(
                  Icons.lens,
                  color: Constants.iAccent2,
                  size: 30,
                ),
              ],
            ),
          )),
    );

    final redAccent = Card(
      color: Constants.iDarkGrey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: InkWell(
          splashColor: Constants.iAccent3,
          onTap: () {
            Constants.setAccentColor(3);
            setState(() {

            });
          },
          child: Container(
            padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Marvelous Red',
                  style: TextStyle(fontSize: 20.0, color: Constants.iWhite),
                ),
                Icon(
                  Icons.lens,
                  color: Constants.iAccent3,
                  size: 30,
                ),
              ],
            ),
          )),
    );

    final greenAccent = Card(
      color: Constants.iDarkGrey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: InkWell(
          splashColor: Constants.iAccent4,
          onTap: () {
            Constants.setAccentColor(4);
            setState(() {

            });
          },
          child: Container(
            padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Majestic Green',
                  style: TextStyle(fontSize: 20.0, color: Constants.iWhite),
                ),
                Icon(
                  Icons.lens,
                  color: Constants.iAccent4,
                  size: 30,
                ),
              ],
            ),
          )),
    );

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
                        child:  Icon(
                          Icons.arrow_back,
                          color: Constants.colors[Constants.colorindex],
                        ),
                      ),
                      Text(
                        'Back',
                        style: TextStyle(
                          fontSize: 20,
                          color: Constants.colors[Constants.colorindex],
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
            body: Center(
                child: Container(
              alignment: Alignment.center,
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
                        color: Constants.colors[Constants.colorindex],
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
                        color: Constants.colors[Constants.colorindex],
                        fontSize: 40.0,
                        fontWeight: FontWeight.w300),
                  ),
                  SizedBox(height: 40.0),
                  Text(
                    'Personalization',
                    style: new TextStyle(
                        color: Constants.colors[Constants.colorindex],
                        fontSize: 30.0,
                        fontWeight: FontWeight.w300),
                  ),
                  SizedBox(height: 20.0),
                  Row(children: <Widget>[
                    Icon(
                      Icons.palette,
                      size: 35,
                      color: Constants.iWhite,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Choose your accent color...',
                      style: new TextStyle(
                          color: Constants.iWhite,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w300),
                    ),
                  ]),
                  SizedBox(
                    height: 15,
                  ),
                  blueAccent,
                  SizedBox(height: 5),
                  yellowAccent,
                  SizedBox(height: 5),
                  redAccent,
                  SizedBox(height: 5),
                  greenAccent,
                ],
              ),
            ))));
  }
}
