import 'package:flutter/material.dart';
import '../main.dart';
import '../DataContainers/GroupData.dart';
import '../Constants.dart';
import 'ResultsScreen.dart';
import 'VoteScreen.dart';
import '../Interfaces/Database.dart';
import '../DataContainers/GroupData.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'GameScreen.dart';

class QuestionScreen extends StatefulWidget {
  Database _database;
  GroupData groupData;
  String code;

  @override
  QuestionScreen(Database db, GroupData gd, String code) {
    this._database = db;
    this.groupData = gd;
    this.code = code;
  }

  _QuestionScreenState createState() =>
      _QuestionScreenState(_database, groupData, code);
}

class _QuestionScreenState extends State<QuestionScreen>
    with WidgetsBindingObserver {
  Database _database;
  GroupData groupData;
  String code;

  _QuestionScreenState(Database db, GroupData groupData, String code) {
    this._database = db;
    this.groupData = groupData;
    this.code = code;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent) {
    print("BACK BUTTON!"); // Do some stuff.
    return true;
  }

  AppLifecycleState appState;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);

    if (state == AppLifecycleState.paused) {
      print('game paused');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tijdelijk even uitgeschakeld
    // groupData.setNextQuestion(groupData.getQuestion(), Constants.getUserData() );
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final voteButton = Hero(
      tag: 'button',
      child: Padding(
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
                    builder: (BuildContext context) =>
                        VoteScreen(_database, groupData, code),
                  ));
            },
            child: Text("Vote",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20).copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(scaffoldBackgroundColor: Colors.black),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                InkWell(
                  onTap: () => Navigator.of(context).pop(true),
                  child: Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.amber,
                    ),
                  ),
                ),
                Text(
                  'Results',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.amber,
                  ),
                ),
              ]),
              FlatButton(
                onPressed: () {
                  groupData.removePlayingUser(Constants.getUserData());
                  _database.updateGroup(groupData);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            GameScreen(_database, code),
                      ));
                },
                child: Text(
                  "Leave",
                  style: TextStyle(fontSize: 20.0, color: Colors.amber),
                ),
              )
            ],
          ),
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
                  child: Card(
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
                  ),
                ),
              ),
            ),
            voteButton,
          ],
        ),
      ),
    );
  }
}
