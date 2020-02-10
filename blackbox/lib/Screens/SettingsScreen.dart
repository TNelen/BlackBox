import 'package:auto_size_text/auto_size_text.dart';
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
                  style: TextStyle(fontSize: 17.0, color: Constants.iWhite),
                ),
                Icon(
                  Icons.lens,
                  color: Constants.iAccent1,
                  size: 20,
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
                  style: TextStyle(fontSize: 17.0, color: Constants.iWhite),
                ),
                Icon(
                  Icons.lens,
                  color: Constants.iAccent2,
                  size: 20,
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
                  style: TextStyle(fontSize: 17.0, color: Constants.iWhite),
                ),
                Icon(
                  Icons.lens,
                  color: Constants.iAccent3,
                  size: 20,
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
                  style: TextStyle(fontSize: 17.0, color: Constants.iWhite),
                ),
                Icon(
                  Icons.lens,
                  color: Constants.iAccent4,
                  size: 20,
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
            body: Padding(
              padding: EdgeInsets.only(left:22, right: 22),
              child: Center(
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
                        fontSize: 30.0,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 40.0),
                  Text(
                    'Sounds and vibration',
                    style: new TextStyle(
                        color: Constants.colors[Constants.colorindex],
                        fontSize: 22.0,
                        fontWeight: FontWeight.w300),
                  ),
                  SizedBox(height: 5),
                  _buildMediaSetting(Icons.audiotrack, 'Sounds', Constants.getSoundEnabled(), _soundAction),
                  SizedBox(height: 5),
                  _buildMediaSetting(Icons.vibration, 'Vibration', Constants.getVibrationEnabled(), _vibrationAction),
                     
                  SizedBox(height: 40.0),
                  Text(
                    'Personalization',
                    style: new TextStyle(
                        color: Constants.colors[Constants.colorindex],
                        fontSize: 22.0,
                        fontWeight: FontWeight.w300),
                  ),
                  SizedBox(height: 20.0),
                  Row(children: <Widget>[
                    Icon(
                      Icons.palette,
                      size: 20,
                      color: Constants.iWhite,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Choose your accent color...',
                      style: new TextStyle(
                          color: Constants.iWhite,
                          fontSize: 17.0,
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
            )))));
  }

  void plusOne() => 1;

  void _vibrationAction() => Constants.setVibrationEnabled( ! Constants.getVibrationEnabled() );

  void _soundAction() => Constants.setSoundEnabled( ! Constants.getSoundEnabled() );

  Container _buildMediaSetting(IconData icon, String label, bool isEnabled, Function() action) {
    
    Color foregroundColor;
    Color textColor;
    Color backgroundColor;
    if (isEnabled)
    {
      foregroundColor = Constants.colors[Constants.colorindex];
      textColor = Constants.iWhite;
      backgroundColor = Constants.iDarkGrey;
    } else {
      foregroundColor = Constants.iGrey;
      textColor = Constants.iGrey;
      backgroundColor = Constants.iDarkGrey;
    }

    return Container(
        constraints: BoxConstraints(minWidth: 100, maxWidth: 120),
        child: Card(
            color: backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
                child: Container(
                    padding: EdgeInsets.fromLTRB(15, 6, 15, 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(children: [Hero(
                            tag: 'topicon' + label,
                            child: Icon(
                              icon,
                              color: foregroundColor,
                              size: 17,
                            )),
                        SizedBox(
                          width: 10,
                        ),
                        AutoSizeText(
                          label,
                          style:
                              TextStyle(fontSize: 17, color: textColor),
                          maxLines: 1,
                        ),]),
                        Switch(
                        value: isEnabled,
                        onChanged: (value) {
                        action();
                        _database.updateUser( Constants.getUserData() );
                        setState(() {
                      });
                       },
                        activeTrackColor: foregroundColor,
                        activeColor: Constants.iWhite,
          ),
                        
                      ],
                    ))));
  }
}
