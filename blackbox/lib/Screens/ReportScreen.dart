import 'package:flutter/material.dart';
import 'GameScreen.dart';
import '../Interfaces/Database.dart';
import 'HomeScreen.dart';
import 'Popup.dart';
import '../Constants.dart';

class ReportScreen extends StatefulWidget {
  Database _database;

  ReportScreen(Database db) {
    this._database = db;
  }

  @override
  _ReportScreenState createState() => new _ReportScreenState(_database);
}

class _ReportScreenState extends State<ReportScreen> {
  Database _database;
  TextEditingController problemController = new TextEditingController();

  _ReportScreenState(Database db) {
    this._database = db;
  }

  @override
  Widget build(BuildContext context) {
    final QuestionFieled = TextField(
      obscureText: false,
      keyboardType: TextInputType.multiline,
      maxLength: 200,
      maxLines: 5,
      controller: problemController,
      style: TextStyle(fontSize: 20, color: Colors.black),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 40.0),
          fillColor: Constants.iWhite,
          filled: true,
          hintText: "Max 5 lines, 200 charachters",
          counterText: problemController.text.length.toString(),
          counterStyle: TextStyle(color: Constants.iBlack),
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(16.0))),
    );

    final SubmitButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(16.0),
      color: Constants.iDarkGrey,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          ///Take action here
          ///if text.length !=null....
        },
        child: Text("Submit",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20)
                .copyWith(color: Constants.iWhite, fontWeight: FontWeight.bold)),
      ),
    );

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BlackBox',
        theme: new ThemeData(scaffoldBackgroundColor: Constants.iBlack),
        home: Scaffold(
            appBar: AppBar(
              backgroundColor: Constants.iBlack,
              title: Row(

                  mainAxisAlignment: MainAxisAlignment.start, children: [
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
                padding: EdgeInsets.all(10),
                color: Constants.iBlack,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 40.0),
                      Text(
                        'Ran into an issue?',
                        style: new TextStyle(
                            color: Constants.iWhite,
                            fontSize: 40.0,
                            fontWeight: FontWeight.w300),
                      ),
                      SizedBox(height: 40.0),
                      Text(
                        'Sorry to hear that...  ',
                        textAlign: TextAlign.center,
                        style: new TextStyle(
                            color: Constants.iAccent,
                            fontSize: 25.0,
                            fontWeight: FontWeight.normal),
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        'Please fill in this form so we can locate and solve this problem as fast as possible',
                        textAlign: TextAlign.center,
                        style: new TextStyle(
                            color: Constants.iWhite,
                            fontSize: 20.0,
                            fontWeight: FontWeight.normal),
                      ),
                      SizedBox(height: 20.0),
                      QuestionFieled,
                      SizedBox(height: 20.0),
                      SubmitButton,

                    ]),
              ),
            )));
  }
}

