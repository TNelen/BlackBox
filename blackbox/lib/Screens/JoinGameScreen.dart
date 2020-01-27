import 'package:flutter/material.dart';
import 'GameScreen.dart';
import '../Interfaces/Database.dart';
import 'Popup.dart';
import '../Constants.dart';

class JoinGameScreen extends StatefulWidget {
  Database _database;

  JoinGameScreen(Database db) {
    this._database = db;
  }

  @override
  _JoinGameScreenState createState() => new _JoinGameScreenState(_database);
}

class _JoinGameScreenState extends State<JoinGameScreen> {
  Database _database;
  TextEditingController codeController = new TextEditingController();

  _JoinGameScreenState(Database db) {
    this._database = db;
  }

  @override
  Widget build(BuildContext context) {
    final joinButton = Hero(
      tag: 'tobutton',
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(28.0),
        color: Constants.colors[Constants.colorindex],
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: () {
            String groupCode = codeController.text.toUpperCase();
            if (groupCode.length == Constants.groupCodeLength) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => GameScreen(
                        _database, codeController.text.toUpperCase()),
                  ));
            } else {
              Popup.makePopup(
                  context,
                  "Please check your code",
                  "A code should contain " +
                      Constants.groupCodeLength.toString() +
                      " symbols!");
            }
          },
          child: Text("Join",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20)
                  .copyWith(color: Constants.iDarkGrey, fontWeight: FontWeight.bold)),
        ),
      ),
    );

    final codeField = TextField(
      maxLength: 5,
      obscureText: false,
      controller: codeController,
      style: TextStyle(fontSize: 20, color: Colors.black),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          fillColor: Constants.iWhite,
          filled: true,
          hintText: "Game code",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(16.0))),
    );

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BlackBox',
        theme: new ThemeData(scaffoldBackgroundColor: Colors.black),
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: Constants.iBlack,
            title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Row(children: [Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Icon(
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
                ]),),
          body: Padding(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: Center(
            child: Container(
              color: Constants.iBlack,
              child: Padding(
                padding: const EdgeInsets.all(36.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Join Group',
                      style: new TextStyle(color: Constants.iWhite, fontSize: 40.0, fontWeight: FontWeight.w300),
                    ),
                    SizedBox(height: 80.0),
                    Text(
                      'Enter group code below',
                      style: new TextStyle(color: Constants.colors[Constants.colorindex], fontSize: 20.0, ),
                    ),
                    SizedBox(height: 25.0),
                    codeField,
                    joinButton,
                  ],
                ),
              ),
            ),
          ),
        )));
  }
}
