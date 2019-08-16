import 'package:flutter/material.dart';
import '../main.dart';
import '../DataContainers/GroupData.dart';
import '../Constants.dart';
import 'ResultsScreen.dart';
import 'VoteScreen.dart';
import '../Interfaces/Database.dart';
import '../DataContainers/GroupData.dart';


class QuestionScreen extends StatefulWidget {
  Database _database;
  GroupData groupData;
  String code;

  @override
  QuestionScreen(Database db, GroupData gd, String code){
    this._database = db;
    this.groupData = gd;
    this.code = code;
  }
  _QuestionScreenState createState() => _QuestionScreenState(_database, groupData, code);
}

class _QuestionScreenState extends State<QuestionScreen> {
  Database _database;
  GroupData groupData;
  String code;

  _QuestionScreenState(Database db, GroupData groupData, String code){
    this._database = db;
    this.groupData = groupData;
    this.code = code;
  }

  @override
  Widget build(BuildContext context) {

    // Tijdelijk even uitgeschakeld
    // groupData.setNextQuestion(groupData.getQuestion(), Constants.getUserData() );
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final voteButton = Hero(
        tag: 'button',
        child:Padding(
      padding: const EdgeInsets.all(20),
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.amber,
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: () {

            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => VoteScreen(_database, groupData, code),
                ));

          },
          child: Text("Vote",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20)
                  .copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),),
    );

    return MaterialApp(
      theme: new ThemeData(scaffoldBackgroundColor: Colors.black),
      home: Scaffold(
        appBar: AppBar(
          title: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.amber,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          backgroundColor: Colors.black,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 30),
                padding: EdgeInsets.only(top: height / 10, bottom: height / 10),
                child: Hero(
                  tag: 'questionToVote',
                  child:Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                  color: Colors.white,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Question',
                              style: new TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 30),
                            Text(
                              groupData.getNextQuestionString(),
                              style: new TextStyle(
                                  color: Colors.amber,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),),
              ),
            ),
            voteButton,
          ],
        ),
      ),
    );
  }
}
