import 'package:flutter/material.dart';
import '../main.dart';
import '../DataContainers/GroupData.dart';
import '../Constants.dart';
import 'ResultsScreen.dart';
import '../Interfaces/Database.dart';
import '../DataContainers/GroupData.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'HomeScreen.dart';

class VoteScreen extends StatefulWidget {
  Database _database;
  GroupData groupData;
  String code;

  VoteScreen(Database db, GroupData groupData, String code) {
    this._database = db;
    this.groupData = groupData;
    this.code = code;
  }

  @override
  _VoteScreenState createState() =>
      _VoteScreenState(_database, groupData, code);
}

class _VoteScreenState extends State<VoteScreen> {
  Database _database;
  GroupData groupData;
  Color color;
  String code;
  String clickedmember;
  String currentQuestion;
  String currentQuestionString;

  _VoteScreenState(Database db, GroupData groupData, String code) {
    this._database = db;
    this.groupData = groupData;
    this.code = code;
  }

  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor);

    color = Colors.white;
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent) {
    print("BACK BUTTON!"); // Do some stuff.
    return true;
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0))),
          title: new Text(
            "No members selected",
            style: TextStyle(color: Colors.black, fontSize: 25),
          ),
          content: new Text(
            "Please make a valid choice",
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Close",
                style: TextStyle(
                    color: Colors.amber,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    ///used to choose between different groups to get the members
    final int index = groupData.getNumPlaying() - 1;

    final voteButton = Hero(
      tag: 'submit',
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(30.0),
          color: Colors.amber,
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(1.0, 15.0, 20.0, 15.0),
            onPressed: () {
              if (clickedmember != null) {
                _database.voteOnUser(groupData, clickedmember);
                currentQuestion = groupData.getQuestionID();
                currentQuestionString = groupData.getNextQuestionString();
                print(currentQuestionString);

                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => ResultScreen(
                          _database,
                          groupData,
                          code,
                          currentQuestion,
                          currentQuestionString),
                    ));
              } else {
                _showDialog();
              }
            },
            child: Text("Submit choice",
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
              Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.amber,
                      ),
                    ),
                  ),
                  Text(
                    'Question',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.amber,
                    ),
                  ),
                ],
              ),
              FlatButton(
                onPressed: () {
                  groupData.removeMember(Constants.getUserData());
                  _database.updateGroup(groupData);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            HomeScreen(_database),
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
              child: GridView.count(
                crossAxisCount: 2,
                padding: EdgeInsets.all(8.0),
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
                children: groupData
                    .getMembers()
                    .map((data) => Card(
                          color: data.getUserID() == clickedmember
                              ? Colors.amber
                              : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0),
                          ),
                          child: InkWell(
                            splashColor: Colors.amber.withAlpha(60),
                            onTap: () {
                              setState(() {
                                color = Colors.amber;
                                clickedmember = data.getUserID();
                              });
                            },
                            child: Container(
                              child: Center(
                                  child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  data.getUsername(),
                                  style: new TextStyle(
                                      color: Colors.black,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
            voteButton,
          ],
        ),
      ),
    );
  }
}
