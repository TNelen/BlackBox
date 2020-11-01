import 'package:blackbox/DataContainers/UserData.dart';
import 'package:blackbox/Screens/popups/noMembersScelectedPopup.dart';
import 'package:blackbox/Screens/popups/report_question_popup.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import '../DataContainers/GroupData.dart';
import '../Constants.dart';
import '../Interfaces/Database.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'GameScreen.dart';
import '../Database/FirebaseStream.dart';
import 'popups/Popup.dart';
import 'ResultsScreen.dart';

Map<ReportType, bool> reportMap = new Map<ReportType, bool>();

class QuestionScreen extends StatefulWidget {
  final Database _database;
  final GroupData groupData;
  final String code;

  @override
  QuestionScreen(this._database, this.groupData, this.code) {
    reportMap[ReportType.DISTURBING] = false;
    reportMap[ReportType.GRAMMAR] = false;
    reportMap[ReportType.CATEGORY] = false;
    reportMap[ReportType.LOVE] = false;
  }

  _QuestionScreenState createState() => _QuestionScreenState(_database, groupData, code);
}

class _QuestionScreenState extends State<QuestionScreen> with WidgetsBindingObserver {
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
              style: TextStyle(fontSize: Constants.smallFontSize, color: Constants.iWhite),
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
              style: TextStyle(fontSize: Constants.smallFontSize).copyWith(
                color: Constants.iWhite,
              )),
        ],
      ),
    );

    final List<UserData> userData = groupData.getPlayingUserdata();
    if (groupData.canVoteBlank) userData.add(GroupData.blankUser);
    if (!groupData.canVoteOnSelf) {
      int deleteIndex;
      for (int i = 0; i < userData.length; i++) if (Constants.getUserID() == userData[i].getUserID()) deleteIndex = i;

      if (deleteIndex != null) userData.removeAt(deleteIndex);
    }

    final membersList = GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      childAspectRatio: (3 / 1),
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      children: userData.map((data) => buildUserVoteCard(data)).toList(),
    );

    final voteButton = Hero(
      tag: 'submit',
      child: Padding(
        padding: const EdgeInsets.only(left: 35, right: 35),
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(28.0),
          color: Constants.colors[Constants.colorindex],
          child: MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28.0),
            ),
            minWidth: MediaQuery.of(context).size.width,
            onPressed: () {
              if (clickedmember != null) {
                if (reportMap.containsValue(true))
                  FirebaseAnalytics().logEvent(name: 'action_performed', parameters: {
                    'action_name': 'RateQuestion',
                    'disturbing': reportMap[ReportType.DISTURBING],
                    'grammar': reportMap[ReportType.GRAMMAR],
                    'category': reportMap[ReportType.CATEGORY],
                    'love': reportMap[ReportType.LOVE]
                  });

                FirebaseAnalytics().logEvent(name: 'game_action', parameters: {
                  'type': 'VoteCast',
                  'code': groupData.getGroupCode(),
                });

                FirebaseAnalytics().logEvent(name: 'VoteOnUser', parameters: null);

                _database.multiReportQuestion(groupData.getQuestion(), reportMap);
                //_database.voteOnUser(groupData, clickedmember);
                groupData.addVote(clickedmember); // GroupData#addVote automatically updates the database. This is preferred because random retries are built in
                currentQuestion = groupData.getQuestionID();
                currentQuestionString = groupData.getNextQuestionString();

                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => ResultScreen(_database, groupData, code, currentQuestion, currentQuestionString, clickedmember),
                    ));
              } else {
                NoMemberSelectedPopup.noMemberSelectedPopup(context);
              }
            },
            child: Text("Vote", textAlign: TextAlign.center, style: TextStyle(fontSize: Constants.actionbuttonFontSize).copyWith(color: Constants.iBlack, fontWeight: FontWeight.bold)),
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
                elevation: 0,

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
                          style: TextStyle(fontSize: Constants.actionbuttonFontSize, color: Constants.colors[Constants.colorindex]),
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
                              builder: (BuildContext context) => GameScreen(_database, code),
                            ));
                      },
                      child: Text(
                        "Leave",
                        style: TextStyle(fontSize: Constants.actionbuttonFontSize, color: Constants.colors[Constants.colorindex]),
                      ),
                    )
                  ],
                ),
              ),
              body: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      stops: [0.1, 0.9],
                      colors: [
                        Constants.gradient1,
                        Constants.gradient2,


                      ],
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 3.0),
                  child: ListView(
                    children: [
                      //submit own question button
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                        child: Card(
                          elevation: 0.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          color: Colors.transparent,
                          child: Center(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(height: 10),
                                  Text(
                                    'Question',
                                    style: new TextStyle(color: Constants.iWhite, fontSize: Constants.subtitleFontSize, fontWeight: FontWeight.w700),
                                  ),
                                  SizedBox(height: 30),
                                  Text(
                                    groupData.getNextQuestionString(),
                                    style: new TextStyle(color: Constants.colors[Constants.colorindex], fontSize: Constants.normalFontSize, fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    '- ' + groupData.getQuestion().getCategory() + ' -',
                                    style: new TextStyle(color: Constants.iWhite, fontSize: Constants.smallFontSize, fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Select a friend',
                        textAlign: TextAlign.center,
                        style: new TextStyle(color: Constants.iWhite, fontSize: Constants.normalFontSize, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      membersList,
                      reportButton,
                      submitquestionbutton,

                      SizedBox(
                        height: 75,
                      ),
                    ],
                  )),
              floatingActionButton: voteButton,
              floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            ),
          );
        });
  }

  Widget buildUserVoteCard(UserData data) {
    return Container(
        child: Card(
          elevation: 5.0,
      color: data.getUserID() == clickedmember ? Constants.iLight : Constants.iDarkGrey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.0),
        splashColor: Constants.colors[Constants.colorindex],
        onTap: () {
          setState(() {
            color = Constants.colors[Constants.colorindex];
            clickedmember = data.getUserID();
          });
        },
        child: Center(
            child: Padding(
          padding: const EdgeInsets.only(top: 1.0, bottom: 1, left: 7, right: 7),
          child: Text(
            data.getUsername().split(' ')[0],
            style: new TextStyle(color: data.getUserID() == clickedmember ? Constants.iDarkGrey : Constants.iWhite, fontSize: Constants.smallFontSize, fontWeight: FontWeight.bold),
          ),
        )),
      ),
    ));
  }
}
