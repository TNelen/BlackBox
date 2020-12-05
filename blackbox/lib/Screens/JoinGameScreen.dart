import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'GameScreen.dart';
import '../Interfaces/Database.dart';
import 'popups/Popup.dart';
import '../Constants.dart';

class JoinGameScreen extends StatefulWidget {
  Database _database;

  JoinGameScreen(Database db) {
    this._database = db;
  }

  @override
  _JoinGameScreenState createState() => _JoinGameScreenState(_database);
}

class _JoinGameScreenState extends State<JoinGameScreen> {
  Database _database;
  TextEditingController codeController = TextEditingController();

  _JoinGameScreenState(Database db) {
    this._database = db;

    FirebaseAnalytics().logEvent(name: 'open_screen', parameters: {'screen_name': 'JoinGameScreen'});
  }

  void joinGame(String groupID) async {
    bool exists = false;
    exists = await _database.doesGroupExist(groupID);
    if (groupID.length == Constants.groupCodeLength) {
      if (exists) {
        FirebaseAnalytics().logEvent(name: 'game_action', parameters: {'type': 'GameJoined', 'code': codeController.text.toUpperCase()});

        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => GameScreen(_database, codeController.text.toUpperCase()),
            ));
      } else {
        Popup.makePopup(context, "Invalid code", "Please check you code and try again!");
      }
    } else {
      Popup.makePopup(context, "Please check your code", "A code should contain " + Constants.groupCodeLength.toString() + " symbols!");
    }
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28.0),
          ),
          minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: () {
            // Replace 1 by I and 0 by O to prevent confusion (group codes do not contain 1's and 0's for this reason)
            String groupCode = codeController.text.toUpperCase().replaceAll('0', 'O').replaceAll('1', 'I');
            joinGame(groupCode);
          },
          child: Text("Join",
              textAlign: TextAlign.center, style: TextStyle(fontFamily: "atarian", fontSize: Constants.actionbuttonFontSize).copyWith(color: Constants.iDarkGrey, fontWeight: FontWeight.bold)),
        ),
      ),
    );

    final codeField = TextField(
      maxLength: 5,
      obscureText: false,
      controller: codeController,
      style: TextStyle(fontFamily: "atarian", fontSize: Constants.smallFontSize, color: Colors.black),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          fillColor: Constants.iWhite,
          filled: true,
          hintText: "Game code",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0))),
    );

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BlackBox',
        theme: new ThemeData(scaffoldBackgroundColor: Constants.iBlack),
        home: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Constants.iBlack,
            title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              InkWell(
                onTap: () => Navigator.pop(context),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Icon(
                        Icons.arrow_back,
                        color: Constants.colors[Constants.colorindex],
                      ),
                    ),
                    Text(
                      'Back',
                      style: TextStyle(
                        fontFamily: "atarian",
                        fontSize: Constants.actionbuttonFontSize,
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
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomLeft,
                  stops: [0.1, 1.0],
                  colors: [
                    Constants.gradient1,
                    Constants.gradient2,
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 36.0, bottom: 36, left: 63, right: 63),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Join Group',
                      style: TextStyle(
                        color: Constants.iWhite,
                        fontSize: Constants.titleFontSize,
                        fontWeight: FontWeight.w300,
                        fontFamily: "atarian",
                      ),
                    ),
                    Expanded(
                      child: SizedBox(),
                    ),
                    Text(
                      'Enter group code below',
                      style: TextStyle(
                        color: Constants.colors[Constants.colorindex],
                        fontSize: Constants.normalFontSize,
                        fontFamily: "atarian",
                      ),
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    codeField,
                    joinButton,
                    Expanded(
                      child: SizedBox(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
