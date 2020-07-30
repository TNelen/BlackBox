import 'package:blackbox/DataContainers/UserData.dart';
import 'package:flutter/material.dart';
import '../DataContainers/GroupData.dart';
import '../Constants.dart';
import '../Interfaces/Database.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'GameScreen.dart';
import '../Database/FirebaseStream.dart';
import 'Popup.dart';
import 'ResultsScreen.dart';

Map<ReportType, bool> reportMap = new Map<ReportType, bool>();

class QuestionScreen extends StatefulWidget {
  Database _database;
  GroupData groupData;
  String code;

  @override
  QuestionScreen(Database db, GroupData gd, String code) {
    this._database = db;
    this.groupData = gd;
    this.code = code;

    reportMap[ReportType.DISTURBING] = false;
    reportMap[ReportType.GRAMMAR] = false;
    reportMap[ReportType.CATEGORY] = false;
    reportMap[ReportType.LOVE] = false;
  }

  _QuestionScreenState createState() =>
      _QuestionScreenState(_database, groupData, code);
}

class _QuestionScreenState extends State<QuestionScreen>
    with WidgetsBindingObserver {
  Database _database;
  GroupData groupData;
  String code;

  Color color;
  String clickedmember;

  String currentQuestion;
  String currentQuestionString;

  FirebaseStream stream;
  TextEditingController questionController = new TextEditingController();

  _QuestionScreenState(Database db, GroupData groupData, String code) {
    this._database = db;
    this.groupData = groupData;
    this.code = code;
    this.stream = new FirebaseStream(code);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    BackButtonInterceptor.add(myInterceptor);
    //reset reports
    reportMap = new Map<ReportType, bool>();
    reportMap[ReportType.DISTURBING] = false;
    reportMap[ReportType.GRAMMAR] = false;
    reportMap[ReportType.CATEGORY] = false;
    reportMap[ReportType.LOVE] = false;
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent) {
    return true;
  }

  AppLifecycleState appState;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {}
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: Constants.iBlack,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0))),
          title: new Text(
            "No members selected",
            style: TextStyle(
                fontFamily: "atarian",
                color: Constants.colors[Constants.colorindex],
                fontSize: 30),
          ),
          content: new Text(
            "Please make a valid choice",
            style: TextStyle(
                fontFamily: "atarian", color: Constants.iWhite, fontSize: 22),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Close",
                style: TextStyle(
                    fontFamily: "atarian",
                    color: Constants.colors[Constants.colorindex],
                    fontSize: 25,
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

    final reportButton = FlatButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (_) {
                return ReportPopup(_database, groupData, code);
              });
        },
        child: Row(
          children: <Widget>[
            Icon(Icons.report, color: Constants.iWhite, size: 22),
            SizedBox(
              width: 10,
            ),
            Text(
              'Give Feedback on this question',
              style: TextStyle(fontSize: 20, color: Constants.iWhite),
            ),
          ],
        ));

    final submitquestionbutton = FlatButton(
      onPressed: () {
        Popup.submitQuestionIngamePopup(context, _database, groupData);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            Icons.library_add,
            color: Constants.iWhite,
            size: 22,
          ),
          SizedBox(
            width: 10,
          ),
          Text("Submit Question",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20).copyWith(
                color: Constants.iWhite,
              )),
        ],
      ),
    );

    final List<UserData> userData = groupData.getPlayingUserdata();
    if (groupData.canVoteBlank) userData.add(GroupData.blankUser);
    if (!groupData.canVoteOnSelf) {
      int deleteIndex;
      for (int i = 0; i < userData.length; i++)
        if (Constants.getUserID() == userData[i].getUserID()) deleteIndex = i;

      if (deleteIndex != null) userData.removeAt(deleteIndex);
    }

    final membersList = Flexible(
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: (3 / 1),
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        children: userData.map((data) => buildUserVoteCard(data)).toList(),
      ),
    );

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
                _database.multiReportQuestion(
                    groupData.getQuestion(), reportMap);
                //_database.voteOnUser(groupData, clickedmember);
                groupData.addVote(
                    clickedmember); // GroupData#addVote automatically updates the database. This is preferred because random retries are built in
                currentQuestion = groupData.getQuestionID();
                currentQuestionString = groupData.getNextQuestionString();

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
            child: Text("Confirm choice",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25).copyWith(
                    color: Constants.iBlack, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );

    return StreamBuilder(
        stream: stream.groupData,
        builder: (BuildContext context, AsyncSnapshot<GroupData> snapshot) {
          groupData = snapshot.data;
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          if (!snapshot.hasData) {
            return new Center(child: new CircularProgressIndicator());
          }

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: new ThemeData(
              fontFamily: "atarian",
              scaffoldBackgroundColor: Constants.iBlack,
            ),
            home: Scaffold(
                appBar: AppBar(
                  backgroundColor: Constants.iBlack,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        InkWell(
                          onTap: () => Navigator.of(context).pop(true),
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
                            "Results",
                            style: TextStyle(
                                fontSize: 25.0,
                                color: Constants.colors[Constants.colorindex]),
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
                          style: TextStyle(
                              fontSize: 25.0,
                              color: Constants.colors[Constants.colorindex]),
                        ),
                      )
                    ],
                  ),
                ),
                body: Padding(
                  padding: EdgeInsets.only(left: 30, right: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      //submit own question button

                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10),
                        child: Hero(
                          tag: 'questionToVote',
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            color: Constants.iBlack,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(height: 10),
                                      Text(
                                        'Question',
                                        style: new TextStyle(
                                            color: Constants.iWhite,
                                            fontSize: 40.0,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      SizedBox(height: 30),
                                      Text(
                                        groupData.getNextQuestionString(),
                                        style: new TextStyle(
                                            color: Constants
                                                .colors[Constants.colorindex],
                                            fontSize: 30.0,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        '- ' +
                                            groupData
                                                .getQuestion()
                                                .getCategory() +
                                            ' -',
                                        style: new TextStyle(
                                            color: Constants.iWhite,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      Text(
                        'Select a friend',
                        style: new TextStyle(
                            color: Constants.iWhite,
                            fontSize: 40.0,
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      membersList,
                      reportButton,
                      submitquestionbutton,

                      SizedBox(
                        height: 20,
                      ),

                      voteButton
                    ],
                  ),
                )),
          );
        });
  }

  Widget buildUserVoteCard(UserData data) {
    return Card(
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
            padding:
                const EdgeInsets.only(top: 1.0, bottom: 1, left: 7, right: 7),
            child: Text(
              data.getUsername().split(' ')[0],
              style: new TextStyle(
                  color: data.getUserID() == clickedmember
                      ? Constants.iDarkGrey
                      : Constants.iWhite,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold),
            ),
          )),
        ),
      ),
    );
  }
}

class ReportPopup extends StatefulWidget {
  Database _database;
  GroupData groupData;
  String code;

  @override
  ReportPopup(Database db, GroupData gd, String code) {
    this._database = db;
    this.groupData = gd;
    this.code = code;
  }

  _ReportPopupState createState() =>
      _ReportPopupState(_database, groupData, code);
}

class _ReportPopupState extends State<ReportPopup> {
  Database database;
  GroupData groupdata;
  String code;

  _ReportPopupState(Database db, GroupData groupData, String code) {
    this.database = db;
    this.groupdata = groupData;
    this.code = code;
  }

  @override
  void initState() {}

  void toggle(ReportType type) {
    reportMap[type] = !reportMap[type];
  }

  @override
  Widget build(BuildContext context2) {
    Widget disturbingButton = FlatButton(
        onPressed: () {
          toggle(ReportType.DISTURBING);

          setState(() {});
        },
        child: Row(
          children: !reportMap[ReportType.DISTURBING]
              ? <Widget>[
                  Icon(Icons.sentiment_dissatisfied,
                      color: Constants.iWhite, size: 20),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Disturbing',
                    style: TextStyle(
                        fontFamily: "atarian",
                        fontSize: 20,
                        color: Constants.iWhite),
                  ),
                ]
              : <Widget>[
                  Icon(Icons.sentiment_dissatisfied,
                      color: Constants.iGrey, size: 25),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Disturbing',
                    style: TextStyle(
                        fontFamily: "atarian",
                        fontSize: 20,
                        color: Constants.iGrey),
                  ),
                ],
        ));

    Widget grammarButton = FlatButton(
        onPressed: () {
          toggle(ReportType.GRAMMAR);

          setState(() {});
        },
        child: Row(
          children: !reportMap[ReportType.GRAMMAR]
              ? <Widget>[
                  Icon(Icons.spellcheck, color: Constants.iWhite, size: 20),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Grammar Mistake',
                    style: TextStyle(
                        fontFamily: "atarian",
                        fontSize: 20,
                        color: Constants.iWhite),
                  ),
                ]
              : <Widget>[
                  Icon(Icons.spellcheck, color: Constants.iGrey, size: 25),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Grammar Mistake',
                    style: TextStyle(
                      fontFamily: "atarian",
                      fontSize: 20,
                      color: Constants.iGrey,
                    ),
                  ),
                ],
        ));

    Widget loveButton = FlatButton(
        onPressed: () {
          toggle(ReportType.LOVE);
          setState(() {});
        },
        child: Row(
          children: !reportMap[ReportType.LOVE]
              ? <Widget>[
                  Icon(Icons.favorite, color: Constants.iWhite, size: 20),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Love it!',
                    style: TextStyle(
                        fontFamily: "atarian",
                        fontSize: 20,
                        color: Constants.iWhite),
                  ),
                ]
              : <Widget>[
                  Icon(Icons.favorite, color: Colors.red, size: 25),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Love it!',
                    style: TextStyle(
                        fontFamily: "atarian",
                        fontSize: 20,
                        color: Constants.iGrey),
                  ),
                ],
        ));

    // flutter defined function

    // return object of type Dialog

    return AlertDialog(
      backgroundColor: Constants.iBlack,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0))),
      title: new Text(
        'What do you think about this question?',
        style: TextStyle(
            fontFamily: "atarian",
            color: Constants.colors[Constants.colorindex],
            fontSize: 30),
      ),
      content: new Container(
        height: 200,
        child: Column(
          children: <Widget>[
            disturbingButton,
            grammarButton,
            loveButton,
            SizedBox(
              height: 10,
            ),
            Text(
              'Thank you! Via your feedback we can improve the questions.',
              style: TextStyle(
                  fontFamily: "atarian",
                  fontSize: 20,
                  color: Constants.iGrey,
                  fontWeight: FontWeight.w400),
            )
          ],
        ),
      ),
      actions: <Widget>[
        // usually buttons at the bottom of the dialog
        new FlatButton(
          child: new Text(
            "Close",
            style: TextStyle(
                fontFamily: "atarian",
                color: Constants.colors[Constants.colorindex],
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
