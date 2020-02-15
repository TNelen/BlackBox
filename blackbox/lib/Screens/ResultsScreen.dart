import 'package:audioplayers/audio_cache.dart';
import 'package:blackbox/Util/VibrationHandler.dart';
import 'package:flutter/material.dart';
import '../DataContainers/GroupData.dart';
import '../Constants.dart';
import 'QuestionScreen.dart';
import '../Interfaces/Database.dart';
import '../Database/FirebaseStream.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'GameScreen.dart';
import 'dart:async';
import 'package:dots_indicator/dots_indicator.dart';

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
    }, onError: (error) {
    });

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
        await _database.getNextQuestion(groupData),
        Constants.getUserData());
  }

  void pageChanged(int index) {
    setState(() {
      //pageIndex = index;
    });
  }

  @override
  Widget _buildBody(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final endGameButton = FlatButton(
                  color: Constants.iBlack,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28.0),
                  ),
                  onPressed: () {
                    //nothing yet
                  },
                  splashColor: Constants.colors[Constants.colorindex],
                  child: Container(child:
                  Row(
                    children:[
                      Text(
                        "End Game",
                        style: TextStyle(color: Constants.colors[Constants.colorindex], fontSize: 20, fontWeight: FontWeight.w400),
                      ),
                      SizedBox(width: 5,),
                      Icon(Icons.exit_to_app, size: 20, color: Constants.colors[Constants.colorindex])
                  ])
                ));

                
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
                if (groupData.getNumVotes() == groupData.getNumPlaying() ||
                    timeout == true) {
                  timeout = false;
                  getRandomNexQuestion();
                }
              }

              int remainingVotes = groupData.getNumPlaying() - groupData.getNumVotes();
              String remainingVotesText = ' person';
              if (remainingVotes != 1)
              {
                remainingVotesText+= 's';
              }
              remainingVotesText += ' remaining';

              int remainingQuestions = groupData.getQuestionList().length+1;
              String remainingQuestionsText = ' question';
              if (remainingQuestions != 1)
              {
                remainingQuestionsText += 's';
              }
              remainingQuestionsText += ' remaining';

              return new WillPopScope(
                  onWillPop: () async => false,
                  child: MaterialApp(
                    debugShowCheckedModeBanner: false,
                    theme: new ThemeData(
                        scaffoldBackgroundColor: Constants.iBlack),
                    home: Scaffold(
                      appBar: AppBar(
                backgroundColor: Constants.iBlack,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                      groupData.getAdminID() == Constants.getUserID() ?
                                endGameButton:
                                SizedBox(
                                    height: 0.1,
                                  ),                  ])
                    
              ),
                      body: Center(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text: 'Collecting votes...',
                                style: TextStyle(
                                    color: Constants.iWhite,
                                    fontSize: 35,
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Text(
                              remainingVotes.toString() +
                                  remainingVotesText,
                              style: TextStyle(
                                  fontSize: 25,
                                  color:
                                      Constants.colors[Constants.colorindex]),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Text(
                              remainingQuestions.toString() +
                                  remainingQuestionsText,
                              style: TextStyle(
                                  fontSize: 20,
                                  color:
                                      Constants.iWhite),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            groupData.getAdminID() == Constants.getUserID()
                                ? Text(
                                    'Time left for voting',
                                    style: TextStyle(
                                        fontSize: 25, color: Constants.iWhite),
                                  )
                                : SizedBox(
                                    height: 0.1,
                                  ),
                            SizedBox(
                              height: 12,
                            ),
                            groupData.getAdminID() == Constants.getUserID()
                                ? Text(
                                    _timeleft > 69
                                        ? '1:' + (_timeleft - 60).toString()
                                        : _timeleft > 60
                                            ? '1:0' +
                                                (_timeleft - 60).toString()
                                            : _timeleft.toString() + 's',
                                    style: TextStyle(
                                        fontSize: 25,
                                        color: Constants
                                            .colors[Constants.colorindex]),
                                  )
                                : SizedBox(
                                    height: 0.1,
                                  ),                          
  
                              
                          ])),
                    ),
                  ));
            }
          }
          List currentWinners = groupData.getUserRankingList('previous');
          List alltimeWinners = groupData.getUserRankingList('alltime');

          void toggleAlltime(){
            showMoreAll = ! showMoreAll;
          }

          void toggleCurrent(){
            showMoreCurrent = ! showMoreCurrent;
          }
          
          final alltime = Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            child: Column(children: <Widget>[
              Text(
                            'alltime Leaderboard',
                            style: new TextStyle(
                                color: Constants.iWhite,
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold),
                          ),
              ListView.builder(
                    shrinkWrap: true,
                    itemCount: !showMoreAll ? (alltimeWinners.length>=3? 3 : alltimeWinners.length) : alltimeWinners.length ,
                    itemBuilder: (context, index) {
                      return Card(
                            shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(10.0),
                            ),
                            color: Constants.iDarkGrey,
                            child: Center(
                              child: Padding(
                                  padding:
                                      const EdgeInsets.only(
                                          top: 1.0,
                                          bottom: 1,
                                          left: 7,
                                          right: 7),
                                  child: 
                                              Text(
                                                (index+1).toString() + ': ' + alltimeWinners[index].getUserName() + '  ' + alltimeWinners[index].getNumVotes().toString(),
                                                style: new TextStyle(
                                                    color: Constants
                                                        .iWhite,
                                                    fontSize:
                                                        20.0,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              
                                            
                                          ),
                                        )
                                      
                        );                     
                    },
                      
                        
              ),
              FlatButton(
                  color: Constants.iBlack,
                  onPressed: () {
                    toggleAlltime();
                    setState(() {
                      
                    });
                  },
                  splashColor: Constants.colors[Constants.colorindex],
                  child: showMoreAll? 
                   Text(
                    "Show less",
                    style: TextStyle(color: Constants.colors[Constants.colorindex], fontSize: 17),
                  )
                  :Text(
                    "Show More",
                    style: TextStyle(color: Constants.colors[Constants.colorindex], fontSize: 17),
                  ),
                )
            ])

                
            );

          final top3 = Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            child: Column(children: <Widget>[
              Text(
                            'Results',
                            style: new TextStyle(
                                color: Constants.iWhite,
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold),
                          ),
              ListView.separated(
                separatorBuilder: (context, index) => Divider(
        color: Colors.white,
      ),
                    shrinkWrap: true,
                    itemCount: !showMoreCurrent ? (currentWinners.length>=3? 3 : currentWinners.length) : currentWinners.length ,
                    itemBuilder: (context, index) {
                      return Card(
                            shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(10.0),
                            ),
                            color: Constants.iDarkGrey,
                            child: Center(
                              child: Padding(
                                  padding:
                                      const EdgeInsets.only(
                                          top: 1.0,
                                          bottom: 1,
                                          left: 7,
                                          right: 7),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                    Row(children: <Widget>[
                                    SizedBox(width: 15,),
                                    Text(
                                                (index+1).toString()
                                                +  (index==0? 'st' : index==1? 'nd' : index==2? 'rd' : 'th'),
                                                 style: new TextStyle(
                                                    color: index == 0 ? Constants.colors[Constants.colorindex]:Constants
                                                        .iWhite,
                                                    fontSize:
                                                        20.0,
                                                    fontWeight:
                                                        FontWeight.w400),
                                                          textAlign: TextAlign.start,
                                              ),
                                              SizedBox(width: 8,),
                                    Text(
                                                currentWinners[index].getUserName(),
                                                 style: new TextStyle(
                                                    color: index == 0 ? Constants.colors[Constants.colorindex]:Constants
                                                        .iWhite,
                                                    fontSize:
                                                        20.0,
                                                    fontWeight:
                                                        FontWeight.w300),
                                                          textAlign: TextAlign.start,
                                              ),]),
                                    Text(
                                               currentWinners[index].getNumVotes().toString(),
                                                style: new TextStyle(
                                                    color: index == 0 ? Constants.colors[Constants.colorindex]:Constants
                                                        .iWhite,
                                                    fontSize:
                                                        25.0,
                                                    fontWeight:
                                                        FontWeight.w600),
                                                          textAlign: TextAlign.start,
                                              ),


                                  ],)
                                              
                                              
                                              
                                              
                                            
                                          ),
                                        )
                                      
                        );                     
                    },
                      
                        
              ),
              FlatButton(
                  color: Constants.iBlack,
                  onPressed: () {
                    toggleCurrent();
                    setState(() {
                      
                    });
                  },
                  splashColor: Constants.colors[Constants.colorindex],
                  child: showMoreCurrent? 
                   Text(
                    "Show less",
                    style: TextStyle(color: Constants.colors[Constants.colorindex], fontSize: 17),
                  )
                  :Text(
                    "Show More",
                    style: TextStyle(color: Constants.colors[Constants.colorindex], fontSize: 17),
                  ),
                )
            ])

                
            );

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
                    if (groupData.getNextQuestionString() != "The game has ended, please start a new game, or submit your own questions!"){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              QuestionScreen(_database, groupData, code),
                        ));}
                  },
                  //change isplaying field in database for this group to TRUE
                  child: groupData.getNextQuestionString() != "The game has ended, please start a new game, or submit your own questions!" ?
                  Text("Next Question",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 30).copyWith(
                          color: Constants.iBlack,
                          fontWeight: FontWeight.bold)) :
                  Text("The games has ended, you have played all questions.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20).copyWith(
                          color: Constants.iBlack,
                          fontWeight: FontWeight.bold))
                ),
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
          if (_firstTimeLoaded)
          {
              handleWinnerFeedback(groupData);
              _firstTimeLoaded = false;
          }

          return MaterialApp(
            theme: new ThemeData(scaffoldBackgroundColor: Constants.iBlack),
            home: Scaffold(
              appBar: AppBar(
                backgroundColor: Constants.iBlack,
                title: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
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
                ]),
              ),
              body: 
                 Center(
                  child: ListView(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        children: <Widget>[
                          //Title
                          Center(child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('Leaderboard', style: TextStyle(fontSize: 30, color: Constants.colors[Constants.colorindex], fontWeight: FontWeight.w600),),
                              SizedBox(width: 5,),
                              Icon(Icons.timeline, size: 30 ,color: Constants.colors[Constants.colorindex],),
                          ])),

                          //question
                          SizedBox(height: 30),
                          Padding(
                            padding: EdgeInsets.only(left: 35, right:35),
                            child:
                              Text(
                                currentQuestionString,
                                textAlign: TextAlign.center,
                                style: new TextStyle(
                                  color: Constants.iWhite,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold),
                              ),
                          ),
                          
                          SizedBox(height: 30),

                          
                          //top3
                          Padding(
                            padding: EdgeInsets.only(left: 35, right:35),
                            child:
                          top3),

                          //AllTime
                          Padding(
                            padding: EdgeInsets.only(left: 35, right:35),
                            child:
                          alltime),

                         //Nextbutton
                         Padding(
                            padding: EdgeInsets.only(left: 35, right:35),
                            child:
                          nextButton), 


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


  void handleWinnerFeedback(GroupData groupData) async
  {
    if (groupData.getTopThreeIDs('previous').containsKey(Constants.getUserID()))
    {
      if (Constants.getSoundEnabled())
        playSound("winner.wav");
      if (Constants.getVibrationEnabled())
        VibrationHandler.vibrate(vibratePattern: [10, 50, 46, 48, 49, 70, 64, 66, 41, 70]);
    } else {
      if (Constants.getSoundEnabled())
        playSound("loser.wav");
      if (Constants.getVibrationEnabled())
        VibrationHandler.vibrate(vibratePattern: [50, 50, 50, 129]);
    }
  }

  
  /// Plays and terminates a sound in the assets/sounds folder
  /// eg. assets/sounds/music.mp3 would be played by passing music.mp3 as parameter
  void playSound(String path) async
  {
    String full_path = 'sounds/' + path;

    final AudioCache player = AudioCache(); /// Create an instance that is able to play sounds
    await player.play(full_path);           /// Play the sound and wait for completion
    player.clear(full_path);                /// Delete the loaded sound from temp memory
  }
  
}
