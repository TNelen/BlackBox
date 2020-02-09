import 'package:flutter/material.dart';
import '../DataContainers/GroupData.dart';
import '../Constants.dart';
import 'VoteScreen.dart';
import '../Interfaces/Database.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'GameScreen.dart';
import '../Database/FirebaseStream.dart';
import 'Popup.dart';


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

    //report question reset values
    Constants.enableGrammar = 0;
    Constants.enableDisturbing = 0;
    Constants.enableLove = 0;

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

    if (state == AppLifecycleState.paused) {
      
    }
  }

  @override
  Widget build(BuildContext context) {

    final SubmitButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(16.0),
      color: Constants.iDarkGrey,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          String question = questionController.text;
          //print('-' + question+ '-');
          if (question.length == 0) {
            Popup.makePopup(
                context, 'Whoops!', 'You cannot submit an empty question');
          } else if (question.length >= 20) {
            if (question.endsWith('?')) {
              print('----' + question + '---- Added to database');

              ///ADD HERE: Add question to database
              
            } else
              Popup.makePopup(context, 'Whoops',
                  'Please end your question with a question mark');
          } else
            Popup.makePopup(
                context, 'Whoops!', 'You cannot submit a question shorter than 20 characters');
        },
        child: Text("Submit",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20).copyWith(
                color: Constants.iWhite, fontWeight: FontWeight.bold)),
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
                  Icon(Icons.report, color: Constants.iWhite, size: 20),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Give Feedback on this question',
                    style: TextStyle(fontSize: 15, color: Constants.iWhite),
                  ),
                ],
              ));

          final voteButton = Hero(
            tag: 'button',
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
                          color: Constants.iBlack,
                          fontWeight: FontWeight.bold)),
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
                              fontSize: 20.0,
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
                  //submit own question button
                  Hero(
                    tag: 'own',
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(16.0),
                        color: Constants.iBlack,
                        child: MaterialButton(
                          minWidth: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.fromLTRB(2.0, 2.0, 2.0, 2.0),
                          onPressed: () {
                             Popup.submitQuestionIngamePopup(context,_database, groupData);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Submit Question",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 17).copyWith(
                                    color: Constants.iWhite,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.library_add,
                                color: Constants.iWhite,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 30),
                      padding: EdgeInsets.only(
                          top: height / 10, bottom: height / 10),
                      child: Hero(
                        tag: 'questionToVote',
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          color: Constants.iDarkGrey,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(height: 30),
                                    Text(
                                      'Question',
                                      style: new TextStyle(
                                          color: Constants
                                              .colors[Constants.colorindex],
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 30),
                                    Text(
                                      groupData.getNextQuestionString(),
                                      style: new TextStyle(
                                          color: Constants.iWhite,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 30),
                                    groupData.getQuestion().getCategory() ==
                                            'Community'
                                        ? reportButton
                                        : SizedBox(height: 0.0001),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  voteButton
                ],
              ),
            )),
          );
        });
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
  List enableReports = [0, 0, 0];

  _ReportPopupState(Database db, GroupData groupData, String code) {
    this.database = db;
    this.groupdata = groupData;
    this.code = code;
  }

  @override
  void initState() {}

  @override
  Widget build(BuildContext context2) {
    Widget disturbingButton = FlatButton(
        onPressed: () {
          Constants.enable[Constants.enableDisturbing]
              ? database.reportQuestion(
                  groupdata.getQuestion(), ReportType.DISTURBING)
              : null;

          Constants.enableDisturbing = 1;

          setState(() {});
        },
        child: Row(
          children: Constants.enable[Constants.enableDisturbing]
              ? <Widget>[
                  Icon(Icons.sentiment_dissatisfied,
                      color: Constants.iBlack, size: 20),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Disturbing',
                    style: TextStyle(fontSize: 15, color: Constants.iBlack),
                  ),
                ]
              : <Widget>[
                  Icon(Icons.sentiment_dissatisfied,
                      color: Colors.grey, size: 20),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Disturbing',
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                ],
        ));

    Widget grammarButton = FlatButton(
        onPressed: () {
          Constants.enable[Constants.enableGrammar]
              ? database.reportQuestion(
                  groupdata.getQuestion(), ReportType.GRAMMAR)
              : null;

          Constants.enableGrammar = 1;

          setState(() {});
        },
        child: Row(
          children: Constants.enable[Constants.enableGrammar]
              ? <Widget>[
                  Icon(Icons.spellcheck, color: Constants.iBlack, size: 20),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Grammar Mistake',
                    style: TextStyle(fontSize: 15, color: Constants.iBlack),
                  ),
                ]
              : <Widget>[
                  Icon(Icons.spellcheck, color: Colors.grey, size: 20),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Grammar Mistake',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),
                ],
        ));

    Widget loveButton = FlatButton(
        onPressed: () {
          Constants.enable[Constants.enableLove]
              ? database.voteOnQuestion(groupdata.getQuestion())
              : null;

          Constants.enableLove = 1;
          setState(() {});
        },
        child: Row(
          children: Constants.enable[Constants.enableLove]
              ? <Widget>[
                  Icon(Icons.favorite, color: Constants.iBlack, size: 20),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Love it!',
                    style: TextStyle(fontSize: 15, color: Constants.iBlack),
                  ),
                ]
              : <Widget>[
                  Icon(Icons.favorite, color: Colors.red, size: 20),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Love it!',
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                ],
        ));

    // flutter defined function

    // return object of type Dialog

    return AlertDialog(
      backgroundColor: Constants.iWhite,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0))),
      title: new Text(
        'What do you think about this question?',
        style: TextStyle(color: Constants.iBlack, fontSize: 25),
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
              'Thank you! Via your feedback we can improve the community questions.',
              style: TextStyle(
                  fontSize: 15,
                  color: Constants.iDarkGrey,
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
