import 'package:audioplayers/audio_cache.dart';
import 'package:blackbox/DataContainers/UserRankData.dart';
import 'package:blackbox/Util/VibrationHandler.dart';
import 'package:flutter/material.dart';
import '../DataContainers/GroupData.dart';
import '../DataContainers/Question.dart';
import '../Constants.dart';
import 'QuestionScreen.dart';
import '../Interfaces/Database.dart';
import '../Database/FirebaseStream.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'GameScreen.dart';
import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'popups/Popup.dart';
import 'OverviewScreen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class ResultScreen extends StatefulWidget {
  Database _database;
  GroupData groupData;
  String code;
  String currentQuestion;
  String currentQuestionString;
  String clickedmember;

  ResultScreen(Database db, GroupData groupData, String code, String currentQuestion, String currentQuestionString, String clickedmember) {
    this._database = db;
    this.groupData = groupData;
    this.code = code;
    this.currentQuestion = currentQuestion;
    this.currentQuestionString = currentQuestionString;
    this.clickedmember = clickedmember;
  }

  @override
  ResultScreenState createState() => ResultScreenState(_database, groupData, code, currentQuestion, currentQuestionString, clickedmember);
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

  ResultScreenState(Database db, GroupData groupData, String code, String currentQuestion, String currentQuestionString, String clickedmember) {
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
    GroupData newgroupdata = await _database.getGroupByCode(groupData.getGroupCode());

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
    Question question = await _database.getNextQuestion(groupData);
    if (question.getQuestionID() == "END") {
      groupData.setNextQuestion(question, Constants.getUserData());
      groupData.setIsPlaying(false);
    } else {
      groupData.setNextQuestion(question, Constants.getUserData());
    }
  }

  @override
  Widget _buildBody(BuildContext context) {
    final submitquestionbutton = FlatButton(
      onPressed: () {
        Popup.submitQuestionIngamePopup(context, _database, groupData);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.library_add,
            color: Constants.iWhite,
            size: 25,
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

    return StreamBuilder(
        stream: stream.groupData,
        builder: (BuildContext context, AsyncSnapshot<GroupData> snapshot) {
          groupData = snapshot.data;
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          if (!snapshot.hasData) {
            return new Center(child: new CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            _performConcurrencyFix();

            if (currentQuestion == groupData.getQuestionID()) {
              if (groupData.getAdminID() == Constants.getUserID()) {
                if (groupData.getNumVotes() == groupData.getNumPlaying() || timeout == true || !groupData.getIsPlaying()) {
                  timeout = false;
                  getRandomNexQuestion();
                }
              }

              int remainingVotes = groupData.getNumPlaying() - groupData.getNumVotes();
              String remainingVotesText = ' person';
              if (remainingVotes != 1) {
                remainingVotesText += 's';
              }
              remainingVotesText += ' remaining';

              int remainingQuestions = groupData.getQuestionList().length;
              String remainingQuestionsText = ' question';
              if (remainingQuestions != 1) {
                remainingQuestionsText += 's';
              }
              remainingQuestionsText += ' remaining';

              return new WillPopScope(
                  onWillPop: () async => false,
                  child: MaterialApp(
                    debugShowCheckedModeBanner: false,
                    theme: new ThemeData(
                      fontFamily: "atarian",
                      scaffoldBackgroundColor: Constants.iBlack,
                    ),
                    home: Scaffold(
                      body: Center(
                          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: 'Collecting votes...',
                            style: TextStyle(fontFamily: "atarian", color: Constants.iWhite, fontSize: 40, fontWeight: FontWeight.w300),
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Text(
                          remainingVotes.toString() + remainingVotesText,
                          style: TextStyle(fontSize: 30, color: Constants.colors[Constants.colorindex]),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Text(
                          remainingQuestions.toString() + remainingQuestionsText,
                          style: TextStyle(fontSize: 20, color: Constants.iWhite),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        groupData.getAdminID() == Constants.getUserID()
                            ? Text(
                                'Time left for voting',
                                style: TextStyle(fontSize: 25, color: Constants.iWhite),
                              )
                            : SizedBox(
                                height: 0.1,
                              ),
                        SizedBox(
                          height: 12,
                        ),
                        groupData.getAdminID() == Constants.getUserID()
                            ? Text(
                                _timeleft > 69 ? '1:' + (_timeleft - 60).toString() : _timeleft > 60 ? '1:0' + (_timeleft - 60).toString() : _timeleft.toString() + 's',
                                style: TextStyle(fontSize: 25, color: Constants.colors[Constants.colorindex]),
                              )
                            : SizedBox(
                                height: 0.1,
                              ),
                        submitquestionbutton,
                      ])),
                    ),
                  ));
            }
          }
          List<UserRankData> currentWinners = groupData.getUserRankingList('previous', null);
          List<UserRankData> alltimeWinners = groupData.getUserRankingList('alltime', null);

          // Get alltime blank data and remove from users
          UserRankData alltimeBlankData;
          int deleteID;
          int i = 0;
          for (UserRankData userRankData in alltimeWinners) {
            if (userRankData.id == GroupData.blankUser.getUserID()) {
              alltimeBlankData = userRankData;
              deleteID = i;
            }
            i++;
          }

          if (deleteID != null) alltimeWinners.removeAt(deleteID);

          // currentWinners.removeWhere((element) => element.id == GroupData.blankUser.getUserID());
          // alltimeWinners.removeWhere((element) => element.id == GroupData.blankUser.getUserID());

          void toggleAlltime() {
            showMoreAll = !showMoreAll;
          }

          void toggleCurrent() {
            showMoreCurrent = !showMoreCurrent;
          }

          final alltime = Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              child: Column(children: <Widget>[
                Text(
                  'Alltime leaderboard',
                  style: new TextStyle(color: Constants.iWhite, fontSize: 30.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
                ListView.separated(
                  physics: new NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) => Divider(
                    color: Colors.white,
                  ),
                  shrinkWrap: true,
                  itemCount: !showMoreAll ? (alltimeWinners.length >= 3 ? 3 : alltimeWinners.length) : alltimeWinners.length,
                  itemBuilder: (context, index) {
                    return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        color: Constants.iBlack,
                        child: Center(
                          child: Padding(
                              padding: const EdgeInsets.only(top: 1.0, bottom: 1, left: 15, right: 30),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      (index + 1).toString() + (index == 0 ? 'st' : index == 1 ? 'nd' : index == 2 ? 'rd' : 'th'),
                                      style: new TextStyle(color: index == 0 ? Constants.colors[Constants.colorindex] : Constants.iWhite, fontSize: 20.0, fontWeight: FontWeight.w400),
                                      textAlign: TextAlign.start,
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    Text(
                                      alltimeWinners[index].getUserName().split(' ')[0],
                                      style: new TextStyle(color: index == 0 ? Constants.colors[Constants.colorindex] : Constants.iWhite, fontSize: 20.0, fontWeight: FontWeight.w300),
                                      textAlign: TextAlign.start,
                                    ),
                                  ]),
                                  Text(
                                    alltimeWinners[index].getNumVotes().toString(),
                                    style: new TextStyle(color: index == 0 ? Constants.colors[Constants.colorindex] : Constants.iWhite, fontSize: 25.0, fontWeight: FontWeight.w600),
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              )),
                        ));
                  },
                ),
                alltimeWinners.length > 3
                    ? FlatButton(
                        color: Constants.iBlack,
                        onPressed: () {
                          toggleAlltime();
                          setState(() {});
                        },
                        splashColor: Constants.colors[Constants.colorindex],
                        child: showMoreAll
                            ? Text(
                                "Show less",
                                style: TextStyle(color: Constants.colors[Constants.colorindex], fontSize: 17),
                              )
                            : Text(
                                "Show More",
                                style: TextStyle(color: Constants.colors[Constants.colorindex], fontSize: 17),
                              ),
                      )
                    : SizedBox(
                        height: 25,
                      )
              ]));

          final results = Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              child: Column(children: <Widget>[
                Text(
                  'Results',
                  style: new TextStyle(color: Constants.iWhite, fontSize: 30.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    currentWinners.length >= 2
                        ? Stack(alignment: Alignment.bottomCenter, children: <Widget>[
                            Padding(
                                padding: EdgeInsets.only(bottom: 10),
                                child: SizedBox(
                                    width: MediaQuery.of(context).size.width / 4.5,
                                    height: MediaQuery.of(context).size.width / 4.5,
                                    child: Container(
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10.0),
                                          border: Border.all(
                                            color: Constants.iWhite,
                                            width: 1,
                                          ),
                                        ),
                                        child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10.0),
                                            ),
                                            color: Constants.iBlack,
                                            child: Column(
                                              children: <Widget>[
                                                AutoSizeText(
                                                  currentWinners[1].getUserName().split(' ')[0],
                                                  style: new TextStyle(color: Constants.colors[Constants.colorindex], fontSize: 30.0, fontWeight: FontWeight.w600),
                                                  textAlign: TextAlign.center,
                                                  maxLines: 1,
                                                ),
                                                Text(
                                                  currentWinners[1].getNumVotes().toString() + (currentWinners[1].getNumVotes().toString() == '1' ? ' vote' : ' votes'),
                                                  style: new TextStyle(color: Constants.iWhite, fontSize: 20.0, fontWeight: FontWeight.w400),
                                                  textAlign: TextAlign.center,
                                                ),
                                                SizedBox(
                                                  height: 12,
                                                )
                                              ],
                                            ))))),
                            Card(
                                color: Constants.iWhite,
                                child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                                    child: Text(
                                      '2',
                                      style: TextStyle(fontSize: 17, color: Constants.iBlack),
                                    )))
                          ])
                        : SizedBox(
                            width: MediaQuery.of(context).size.width / 4.5,
                          ),
                    SizedBox(
                      width: 5,
                    ),
                    Stack(alignment: Alignment.bottomCenter, children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width / 3.8,
                              height: MediaQuery.of(context).size.width / 3.8,
                              child: Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                      color: Constants.iWhite,
                                      width: 1,
                                    ),
                                  ),
                                  child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      color: Constants.iBlack,
                                      child: Column(
                                        children: <Widget>[
                                          AutoSizeText(
                                            currentWinners.length == 0 ? "" : currentWinners[0].getUserName().split(' ')[0],
                                            style: new TextStyle(color: Constants.colors[Constants.colorindex], fontSize: 20.0, fontWeight: FontWeight.w600),
                                            textAlign: TextAlign.center,
                                            maxLines: 1,
                                          ),
                                          Text(
                                            currentWinners.length == 0 ? "" : currentWinners[0].getNumVotes().toString() + (currentWinners[0].getNumVotes().toString() == '1' ? ' vote' : ' votes'),
                                            style: new TextStyle(color: Constants.iWhite, fontSize: 17.0, fontWeight: FontWeight.w400),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(
                                            height: 14,
                                          )
                                        ],
                                      ))))),
                      Card(
                          color: Constants.colors[Constants.colorindex],
                          child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 11),
                              child: Text(
                                '1',
                                style: TextStyle(fontSize: 17, color: Constants.iBlack),
                              )))
                    ]),
                    SizedBox(
                      width: 5,
                    ),
                    currentWinners.length >= 3
                        ? Stack(alignment: Alignment.bottomCenter, children: <Widget>[
                            Padding(
                                padding: EdgeInsets.only(bottom: 10),
                                child: SizedBox(
                                    height: MediaQuery.of(context).size.width / 4.5,
                                    width: MediaQuery.of(context).size.width / 4.5,
                                    child: Container(
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10.0),
                                          border: Border.all(
                                            color: Constants.iWhite,
                                            width: 1,
                                          ),
                                        ),
                                        child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10.0),
                                            ),
                                            color: Constants.iBlack,
                                            child: Column(
                                              children: <Widget>[
                                                AutoSizeText(
                                                  currentWinners[2].getUserName().split(' ')[0],
                                                  style: new TextStyle(color: Constants.colors[Constants.colorindex], fontSize: 20.0, fontWeight: FontWeight.w600),
                                                  textAlign: TextAlign.center,
                                                  maxLines: 1,
                                                ),
                                                Text(
                                                  currentWinners[2].getNumVotes().toString() + (currentWinners[2].getNumVotes().toString() == '1' ? ' vote' : ' votes'),
                                                  style: new TextStyle(color: Constants.iWhite, fontSize: 17.0, fontWeight: FontWeight.w400),
                                                  textAlign: TextAlign.center,
                                                ),
                                                SizedBox(
                                                  height: 12,
                                                )
                                              ],
                                            ))))),
                            Card(
                                color: Constants.iWhite,
                                child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                                    child: Text(
                                      '3',
                                      style: TextStyle(fontSize: 17, color: Constants.iBlack),
                                    )))
                          ])
                        : SizedBox(
                            width: MediaQuery.of(context).size.width / 4.5,
                          ),
                  ],
                ),
                currentWinners.length > 3
                    ? ListView.separated(
                        physics: new NeverScrollableScrollPhysics(),
                        separatorBuilder: (context, index) => Divider(
                          color: Colors.white,
                        ),
                        shrinkWrap: true,
                        itemCount: !showMoreCurrent ? (currentWinners.length >= 3 ? 0 : currentWinners.length - 3) : currentWinners.length - 3,
                        itemBuilder: (context, index) {
                          return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              color: Constants.iBlack,
                              child: Center(
                                child: Padding(
                                    padding: const EdgeInsets.only(top: 1.0, bottom: 1, left: 15, right: 30),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Text(
                                            (index + 4).toString() + 'th',
                                            style: new TextStyle(color: Constants.iWhite, fontSize: 20.0, fontWeight: FontWeight.w400),
                                            textAlign: TextAlign.start,
                                          ),
                                          SizedBox(
                                            width: 12,
                                          ),
                                          Text(
                                            currentWinners[index + 3].getUserName().split(' ')[0],
                                            style: new TextStyle(color: Constants.iWhite, fontSize: 20.0, fontWeight: FontWeight.w300),
                                            textAlign: TextAlign.start,
                                          ),
                                        ]),
                                        Text(
                                          currentWinners[index + 3].getNumVotes().toString(),
                                          style: new TextStyle(color: Constants.iWhite, fontSize: 25.0, fontWeight: FontWeight.w600),
                                          textAlign: TextAlign.start,
                                        ),
                                      ],
                                    )),
                              ));
                        },
                      )
                    : SizedBox(
                        height: 25,
                      ),
                currentWinners.length >= 3
                    ? FlatButton(
                        color: Constants.iBlack,
                        onPressed: () {
                          toggleCurrent();
                          setState(() {});
                        },
                        splashColor: Constants.colors[Constants.colorindex],
                        child: showMoreCurrent
                            ? Text(
                                "Show less",
                                style: TextStyle(color: Constants.colors[Constants.colorindex], fontSize: 17),
                              )
                            : Text(
                                "Show More",
                                style: TextStyle(color: Constants.colors[Constants.colorindex], fontSize: 17),
                              ),
                      )
                    : SizedBox(
                        height: 50,
                      )
              ]));

          final nextButton = Hero(
            tag: 'button',
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
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
                              builder: (BuildContext context) => QuestionScreen(_database, groupData, code),
                            ));
                      } else {
                        //go to overview
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => OverviewScreen(_database, groupData),
                            ));
                      }
                    },
                    //change isplaying field in database for this group to TRUE
                    child: groupData.getIsPlaying()
                        ? Text("Next Question", textAlign: TextAlign.center, style: TextStyle(fontSize: 30).copyWith(color: Constants.iBlack, fontWeight: FontWeight.bold))
                        : Text("The games has ended. \n Show overview", textAlign: TextAlign.center, style: TextStyle(fontSize: 20).copyWith(color: Constants.iBlack, fontWeight: FontWeight.bold))),
              ),
            ),
          );

          timer.cancel();

          /// Play audio indicating whether or not the player is in the previous top three
          if (_firstTimeLoaded) {
            handleWinnerFeedback(groupData);
            _firstTimeLoaded = false;
          }

          return MaterialApp(
            theme: new ThemeData(
              fontFamily: "atarian",
              scaffoldBackgroundColor: Constants.iBlack,
            ),
            home: Scaffold(
              appBar: AppBar(
                backgroundColor: Constants.iBlack,
                title: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  FlatButton(
                    onPressed: () {
                      FirebaseAnalytics().logEvent(name: 'game_action', parameters: {
                        'type': 'GameLeft',
                      });
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
                      style: TextStyle(fontSize: 25.0, color: Constants.colors[Constants.colorindex]),
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
                      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                    Text(
                      'Leaderboard',
                      style: TextStyle(fontSize: 40, color: Constants.colors[Constants.colorindex], fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Icons.timeline,
                      size: 50,
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
                      style: new TextStyle(color: Constants.iWhite, fontSize: 30.0, fontWeight: FontWeight.bold),
                    ),
                  ),

                  SizedBox(height: 30),

                  //results
                  Padding(padding: EdgeInsets.only(left: 35, right: 35), child: results),

                  //AllTime
                  Padding(padding: EdgeInsets.only(left: 35, right: 35), child: alltime),

                  //Nextbutton
                  Padding(padding: EdgeInsets.only(left: 35, right: 35), child: nextButton),
                ],
              )),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: new ThemeData(
          scaffoldBackgroundColor: Constants.iBlack,
        ),
        home: Scaffold(
          body: _buildBody(context),
        ));
  }

  /// Plays audio and vibrates the phone indicating whether or not the player is in the previous top three
  /// See https://pub.dev/packages/audioplayers for more information
  ///

  void handleWinnerFeedback(GroupData groupData) async {
    if (groupData.getTopThreeIDs('previous').containsKey(Constants.getUserID())) {
      if (Constants.getSoundEnabled()) playSound("winner.wav");
      if (Constants.getVibrationEnabled()) VibrationHandler.vibrate(vibratePattern: [10, 50, 46, 48, 49, 70, 64, 66, 41, 70]);
    } else {
      if (Constants.getSoundEnabled()) playSound("loser.wav");
      if (Constants.getVibrationEnabled()) VibrationHandler.vibrate(vibratePattern: [50, 50, 50, 129]);
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
