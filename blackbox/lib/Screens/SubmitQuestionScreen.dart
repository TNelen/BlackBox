import 'package:flutter/material.dart';
import 'GameScreen.dart';
import '../Interfaces/Database.dart';
import 'HomeScreen.dart';
import 'Popup.dart';
import '../Constants.dart';

class SubmitQuestionScreen extends StatefulWidget {
  Database _database;

  SubmitQuestionScreen(Database db) {
    this._database = db;
  }

  @override
  _SubmitQuestionScreenState createState() => new _SubmitQuestionScreenState(_database);
}

class _SubmitQuestionScreenState extends State<SubmitQuestionScreen> {
  Database _database;
  TextEditingController codeController = new TextEditingController();

  _SubmitQuestionScreenState(Database db) {
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
            body: Center(child: Container(
              color: Constants.iBlack,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Card(
                        color: Constants.iDarkGrey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Icon(Icons.add_to_photos, size: 200, color: Constants.iAccent,)),
                    SizedBox(height: 20.0),

                    Text(
                      'Submit Question',
                      style: new TextStyle(color: Constants.iWhite, fontSize: 40.0, fontWeight: FontWeight.w300),
                    ),
                    SizedBox(height: 80.0),
                  ]),
            ),
            )));
  }
}
