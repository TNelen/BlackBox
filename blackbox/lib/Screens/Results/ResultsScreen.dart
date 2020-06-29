import 'package:audioplayers/audio_cache.dart';
import 'package:blackbox/Util/VibrationHandler.dart';
import 'package:flutter/material.dart';
import '../../DataContainers/GroupData.dart';
import '../../Constants.dart';
import '../QuestionScreen.dart';
import '../../Interfaces/Database.dart';
import '../../Database/FirebaseStream.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import '../GameScreen.dart';
import 'dart:async';
import '../Popup.dart';
import '../OverviewScreen.dart';
import 'prevRoundTop.dart';
import 'AllTimeTop.dart';
import 'WaitScreen.dart';

class ResultScreen extends StatefulWidget {
  Database _database;
  GroupData groupData;
  String code;
  String currentQuestion;
  String currentQuestionString;
  String clickedmember;

  ResultScreen(
      Database db,
      GroupData groupData,
      String code,
      String currentQuestion,
      String currentQuestionString,
      String clickedmember) {
    this._database = db;
    this.groupData = groupData;
    this.code = code;
    this.currentQuestion = currentQuestion;
    this.currentQuestionString = currentQuestionString;
    this.clickedmember = clickedmember;
  }

  @override
  ResultScreenState createState() => ResultScreenState(_database, groupData,
      code, currentQuestion, currentQuestionString, clickedmember);
}

class ResultScreenState extends State<ResultScreen> {
  Database _database;
  GroupData groupData;
  String code;
  String currentQuestion;
  String currentQuestionString;
  FirebaseStream stream;
  bool joined = false;
  bool _loadingInProgress;
  Timer timer;
  bool timeout;
  String clickedmember;

  bool _firstTimeLoaded = true;

  ResultScreenState(
      Database db,
      GroupData groupData,
      String code,
      String currentQuestion,
      String currentQuestionString,
      String clickedmember) {
    this._database = db;
    this.groupData = groupData;
    this.code = code;
    this.currentQuestion = currentQuestion;
    this.currentQuestionString = currentQuestionString;
    this.stream = new FirebaseStream(code);
    this.clickedmember = clickedmember;
  }

  int _timeleft = 119;
  int pageIndex = 0;
  bool showMoreCurrent;
  bool showMoreAll;

  final controller = PageController(
    initialPage: 0,
    keepPage: false,
    viewportFraction: 0.85,
  );

  /// Perform an async fix when voting failed
  void _performConcurrencyFix() async {
    GroupData newgroupdata =
        await _database.getGroupByCode(groupData.getGroupCode());

    if (newgroupdata.getNewVotes().containsKey(Constants.getUserID())) {
      return;
    }

    if (currentQuestion == newgroupdata.getQuestionID()) {
      _database.voteOnUser(groupData, clickedmember);
    }
  }

  @override
  void initState() {
    groupData = null;

    //bools used at showmore at results display
    showMoreCurrent = false;
    showMoreAll = false;

    super.initState();
    _loadingInProgress = true;
    FirebaseStream(code).groupData.listen((_onGroupDataUpdate) {}, onDone: () {
      _loadingInProgress = false;
    }, onError: (error) {});

    BackButtonInterceptor.add(myInterceptor);

    timer = new Timer.periodic(
      Duration(seconds: 1),
      (Timer timer) => setState(
        () {
          _timeleft = _timeleft - 1;
          if (_timeleft <= 0) {
            timer.cancel();
            timeout = true;
          }
        },
      ),
    );
  }

  @override
  dispose() {
    controller.dispose();
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
    timer.cancel();
  }

  bool myInterceptor(bool stopDefaultButtonEvent) {
    return true;
  }

  void getRandomNexQuestion() async {
    groupData.setNextQuestion(
        await _database.getNextQuestion(groupData), Constants.getUserData());
  }

  void pageChanged(int index) {
    setState(() {
      //pageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: new ThemeData(
          scaffoldBackgroundColor: Constants.iBlack,
        ),
        home: Scaffold(
            body: StreamBuilder(
                stream: stream.groupData,
                builder:
                    (BuildContext context, AsyncSnapshot<GroupData> snapshot) {
                  groupData = snapshot.data;
                  if (snapshot.hasError)
                    return Text('Error: ${snapshot.error}');
                  if (!snapshot.hasData) {
                    return new Center(child: new CircularProgressIndicator());
                  }
                  if (snapshot.hasData) {
                    _performConcurrencyFix();

                    if (currentQuestion == groupData.getQuestionID()) {
                      if (groupData.getAdminID() == Constants.getUserID()) {
                        if (groupData.getNumVotes() ==
                                groupData.getNumPlaying() ||
                            timeout == true) {
                          timeout = false;
                          getRandomNexQuestion();
                        }
                      }
                      return WaitScreen.waitScreen(
                          context, _database, groupData, _timeleft);
                    }
                  }
                  List currentWinners =
                      groupData.getUserRankingList('previous', null);
                  List alltimeWinners =
                      groupData.getUserRankingList('alltime', null);

                  void toggleAlltime() {
                    showMoreAll = !showMoreAll;
                  }

                  void toggleCurrent() {
                    showMoreCurrent = !showMoreCurrent;
                  }

                  final alltime = Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                      child: Column(children: <Widget>[
                        Text(
                          'Alltime leaderboard',
                          style: new TextStyle(
                              color: Constants.iWhite,
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        AllTimeTop.alltimetopThree(
                            context, _database, alltimeWinners, showMoreAll),
                        alltimeWinners.length > 3
                            ? FlatButton(
                                color: Constants.iBlack,
                                onPressed: () {
                                  toggleAlltime();
                                  setState(() {});
                                },
                                splashColor:
                                    Constants.colors[Constants.colorindex],
                                child: showMoreAll
                                    ? Text(
                                        "Show less",
                                        style: TextStyle(
                                            color: Constants
                                                .colors[Constants.colorindex],
                                            fontSize: 17),
                                      )
                                    : Text(
                                        "Show More",
                                        style: TextStyle(
                                            color: Constants
                                                .colors[Constants.colorindex],
                                            fontSize: 17),
                                      ),
                              )
                            : SizedBox(
                                height: 25,
                              )
                      ]));

                  final results = Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                      child: Column(children: <Widget>[
                        Text(
                          'Results',
                          style: new TextStyle(
                              color: Constants.iWhite,
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        PrevRoundTop.prevRoundTopThree(
                            context, _database, currentWinners),
                        PrevRoundTop.prevRoundTopAfterThree(context, _database,
                            currentWinners, showMoreCurrent),
                        currentWinners.length >= 3
                            ? FlatButton(
                                color: Constants.iBlack,
                                onPressed: () {
                                  toggleCurrent();
                                  setState(() {});
                                },
                                splashColor:
                                    Constants.colors[Constants.colorindex],
                                child: showMoreCurrent
                                    ? Text(
                                        "Show less",
                                        style: TextStyle(
                                            color: Constants
                                                .colors[Constants.colorindex],
                                            fontSize: 17),
                                      )
                                    : Text(
                                        "Show More",
                                        style: TextStyle(
                                            color: Constants
                                                .colors[Constants.colorindex],
                                            fontSize: 17),
                                      ),
                              )
                            : SizedBox(
                                height: 50,
                              )
                      ]));

                  final nextButton = Hero(
                    tag: 'button',
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                      child: Material(
                        elevation: 0.0,
                        borderRadius: BorderRadius.circular(16.0),
                        color: Constants.colors[Constants.colorindex],
                        child: MaterialButton(
                            minWidth: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.all(20),
                            onPressed: () {
                              if (groupData.getIsPlaying()) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          QuestionScreen(
                                              _database, groupData, code),
                                    ));
                              } else {
                                //go to overview
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          OverviewScreen(_database, groupData),
                                    ));
                              }
                            },
                            //change isplaying field in database for this group to TRUE
                            child: groupData.getIsPlaying()
                                ? Text("Next Question",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 30).copyWith(
                                        color: Constants.iBlack,
                                        fontWeight: FontWeight.bold))
                                : Text("The games has ended. \n Show overview",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 20).copyWith(
                                        color: Constants.iBlack,
                                        fontWeight: FontWeight.bold))),
                      ),
                    ),
                  );

                  timer.cancel();

                  void pageChanged(int index) {
                    setState(() {
                      pageIndex = index;
                    });
                  }

                  /// Play audio indicating whether or not the player is in the previous top three
                  if (_firstTimeLoaded) {
                    handleWinnerFeedback(groupData);
                    _firstTimeLoaded = false;
                  }

                  return MaterialApp(
                    theme: new ThemeData(
                        scaffoldBackgroundColor: Constants.iBlack),
                    home: Scaffold(
                      appBar: AppBar(
                        backgroundColor: Constants.iBlack,
                        title: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              FlatButton(
                                onPressed: () {
                                  groupData.removePlayingUser(
                                      Constants.getUserData());
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
                                      color: Constants
                                          .colors[Constants.colorindex]),
                                ),
                              )
                            ]),
                      ),
                      body: Center(
                          child: ListView(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        children: <Widget>[
                          //Title
                          Center(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                Text(
                                  'Leaderboard',
                                  style: TextStyle(
                                      fontSize: 30,
                                      color: Constants
                                          .colors[Constants.colorindex],
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.timeline,
                                  size: 30,
                                  color: Constants.colors[Constants.colorindex],
                                ),
                              ])),

                          //question
                          SizedBox(height: 30),
                          Padding(
                            padding: EdgeInsets.only(left: 35, right: 35),
                            child: Text(
                              currentQuestionString,
                              textAlign: TextAlign.center,
                              style: new TextStyle(
                                  color: Constants.iWhite,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),

                          SizedBox(height: 30),

                          //results
                          Padding(
                              padding: EdgeInsets.only(left: 35, right: 35),
                              child: results),

                          //AllTime
                          Padding(
                              padding: EdgeInsets.only(left: 35, right: 35),
                              child: alltime),

                          //Nextbutton
                          Padding(
                              padding: EdgeInsets.only(left: 35, right: 35),
                              child: nextButton),
                        ],
                      )),
                    ),
                  );
                })));
  }

  /// Plays audio and vibrates the phone indicating whether or not the player is in the previous top three
  /// See https://pub.dev/packages/audioplayers for more information
  ///

  void handleWinnerFeedback(GroupData groupData) async {
    if (groupData
        .getTopThreeIDs('previous')
        .containsKey(Constants.getUserID())) {
      if (Constants.getSoundEnabled()) playSound("winner.wav");
      if (Constants.getVibrationEnabled())
        VibrationHandler.vibrate(
            vibratePattern: [10, 50, 46, 48, 49, 70, 64, 66, 41, 70]);
    } else {
      if (Constants.getSoundEnabled()) playSound("loser.wav");
      if (Constants.getVibrationEnabled())
        VibrationHandler.vibrate(vibratePattern: [50, 50, 50, 129]);
    }
  }

  /// Plays and terminates a sound in the assets/sounds folder
  /// eg. assets/sounds/music.mp3 would be played by passing music.mp3 as parameter
  void playSound(String path) async {
    String full_path = 'sounds/' + path;

    final AudioCache player = AudioCache();

    /// Create an instance that is able to play sounds
    await player.play(full_path);

    /// Play the sound and wait for completion
    player.clear(full_path);

    /// Delete the loaded sound from temp memory
  }
}
