import 'package:flutter/material.dart';
import '../DataContainers/GroupData.dart';
import '../Constants.dart';
import 'ResultsScreen.dart';
import '../Interfaces/Database.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'GameScreen.dart';

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
              borderRadius: BorderRadius.all(Radius.circular(16.0))),
          title: new Text(
            "No members selected",
            style: TextStyle(color: Constants.iBlack, fontSize: 25),
          ),
          content: new Text(
            "Please make a valid choice",
            style: TextStyle(color: Constants.iBlack, fontSize: 20),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Close",
                style: TextStyle(
                    color: Constants.colors[Constants.colorindex],
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
        padding: const EdgeInsets.only(bottom: 60, left: 35, right: 35),
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(28.0),
          color: Constants.colors[Constants.colorindex],
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(3.0, 3.0, 3.0, 3.0),
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
                          currentQuestionString,
                          clickedmember),
                    ));
              } else {
                _showDialog();
              }
            },
            child: Text("Submit choice",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20).copyWith(
                    color: Constants.iBlack, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(scaffoldBackgroundColor: Constants.iBlack),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Constants.iBlack,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Padding(
                      padding: EdgeInsets.only(right: 1),
                      child: Icon(
                        Icons.arrow_back,
                        color: Constants.colors[Constants.colorindex],
                      ),
                    ),
                  ),
                  FlatButton(
                    padding: EdgeInsets.all(10),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Question",
                      style: TextStyle(
                          fontSize: 20.0,
                          color: Constants.colors[Constants.colorindex]),
                    ),
                  ),
                ],
              ),
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
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Constants.colors[Constants.colorindex]),
                ),
              )
            ],
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(left: 30, right: 30),
          child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: GridView.count(
                crossAxisCount: 2,
                padding: EdgeInsets.all(8.0),
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
                children: groupData
                    .getPlayingUserdata()
                    .map((data) => Card(
                          color: data.getUserID() == clickedmember
                              ? Constants.iLight
                              : Constants.iDarkGrey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: InkWell(
                            splashColor: Constants.colors[Constants.colorindex],
                            onTap: () {
                              setState(() {
                                color = Constants.colors[Constants.colorindex];
                                clickedmember = data.getUserID();
                              });
                            },
                            child: Container(
                              child: Center(
                                  child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  data.getUsername().split(' ')[0],
                                  style: new TextStyle(
                                      color: data.getUserID() == clickedmember
                                          ? Constants.iDarkGrey
                                          : Constants.iWhite,
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
        )),
      ),
    );
  }
}
