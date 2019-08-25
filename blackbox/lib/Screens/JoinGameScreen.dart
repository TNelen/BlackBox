import 'package:flutter/material.dart';
import 'GameScreen.dart';
import '../Interfaces/Database.dart';
import 'HomeScreen.dart';
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
          borderRadius: BorderRadius.circular(32.0),
          color: Colors.amber,
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
                Popup.makePopup(context, "Please check your code", "A code should contain " + Constants.groupCodeLength.toString() + " symbols!");
              }
            },
            child: Text("Join",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20).copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold)),
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
          fillColor: Colors.white,
          filled: true,
          hintText: "Game code",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BlackBox',
        theme: new ThemeData(scaffoldBackgroundColor: Colors.black),
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                HomeScreen(_database),
                          ));
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.amber,
                      ),
                    )),
                Text(
                  'Back',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.amber,
                  ),
                ),
              ],
            ),
          ),
          body: Center(
            child: Container(
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.all(36.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Join Group',
                      style: new TextStyle(color: Colors.white, fontSize: 40.0),
                    ),
                    SizedBox(height: 80.0),
                    Text(
                      'Enter group code below',
                      style: new TextStyle(color: Colors.amber, fontSize: 25.0),
                    ),
                    SizedBox(height: 25.0),
                    codeField,
                    joinButton,
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
