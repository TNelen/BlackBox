import 'dart:async';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:progress_indicators/progress_indicators.dart';
import '../../Interfaces/Database.dart';
import '../../Database/FirebaseStream.dart';
import '../../models/GroupData.dart';
import '../../Constants.dart';
import 'QuestionScreen.dart';
import '../HomeScreen.dart';
import 'package:share/share.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:auto_size_text/auto_size_text.dart';

class GameScreen extends StatefulWidget {
  Database _database;
  GroupData groupInfo;
  String code;

  GameScreen(Database db, String code) {
    this._database = db;
    this.code = code;
  }

  @override
  _GameScreenState createState() => _GameScreenState(_database, code);
}

class _GameScreenState extends State<GameScreen> {
  Database _database;
  FirebaseStream stream;
  String code;
  bool joined = false;

  GroupData groupdata;

  // Used to rebuild this screen each second
  Timer _rebuildTimer;

  _GameScreenState(Database db, String code) {
    this._database = db;
    this.code = code;
    this.stream = new FirebaseStream(code);
  }

  @override
  void initState() {
    groupdata = null;
    super.initState();
    FirebaseStream(code)
        .groupData
        .listen((_onGroupDataUpdate) {}, onDone: () {}, onError: (error) {
      //nothing;
    });
  }

  void getRandomNexQuestion() async {
    await groupdata.setNextQuestion(
        await _database.getNextQuestion(groupdata), Constants.getUserData());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          fontFamily: "atarian",
          scaffoldBackgroundColor: Constants.iBlack,
        ),
        home: Scaffold(
          body: StreamBuilder(
              stream: stream.groupData,
              builder:
                  (BuildContext context, AsyncSnapshot<GroupData> snapshot) {
                groupdata = snapshot.data;
                if (snapshot.hasError) return Text('Error: ${snapshot.error}');
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!joined) {
                  groupdata.addMember(Constants.getUserData());
                  Constants.database.updateGroup(groupdata);
                  joined = true;
                }

                return Scaffold(
                  body: DefaultTabController(
                    length: 2,
                    child: Scaffold(
                      appBar: AppBar(
                        elevation: 0,
                        title: Container(
                          padding: EdgeInsets.only(bottom: 10),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        HomeScreen(),
                                  ));
                              groupdata.removeMember(Constants.getUserData());
                              _database.updateGroup(groupdata);

                              dispose();
                            },
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 20),
                                  child: Icon(Icons.arrow_back,
                                      color: Constants
                                          .colors[Constants.colorindex]),
                                ),
                                Text(
                                  'Back',
                                  style: TextStyle(
                                    fontSize: Constants.actionbuttonFontSize,
                                    color:
                                        Constants.colors[Constants.colorindex],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        backgroundColor: Constants.iBlack,
                      ),
                      body: Stack(
                        children: <Widget>[
                          Center(
                            child: Container(
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
                                padding: EdgeInsets.only(left: 22, right: 22),
                                alignment: Alignment.center,
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(height: 40),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        AutoSizeText(
                                          "Game Lobby",
                                          style: TextStyle(
                                              color: Constants.iWhite,
                                              fontSize: Constants.titleFontSize,
                                              fontWeight: FontWeight.w300),
                                          maxLines: 1,
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Icon(
                                          Icons.people,
                                          size: 55,
                                          color: Constants.iWhite,
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 40),
                                    Container(
                                      padding:
                                          EdgeInsets.fromLTRB(15, 10, 15, 5),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                  'Press the check mark to get ready!',
                                                  style: TextStyle(
                                                      color: Constants.colors[
                                                          Constants.colorindex],
                                                      fontSize: Constants
                                                          .smallFontSize,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                  textAlign: TextAlign.center),
                                            ),
                                          ]),
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.fromLTRB(15, 10, 15, 5),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                  'You can start the game if all players are ready!',
                                                  style: TextStyle(
                                                      color: Constants.colors[
                                                          Constants.colorindex],
                                                      fontSize: Constants
                                                          .smallFontSize,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                  textAlign: TextAlign.center),
                                            ),
                                          ]),
                                    ),
                                    SizedBox(height: 15),
                                    Container(
                                      padding:
                                          EdgeInsets.fromLTRB(15, 5, 15, 3),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Players ready:  ",
                                            style: TextStyle(
                                                fontSize:
                                                    Constants.smallFontSize,
                                                color: Constants.iWhite),
                                          ),
                                          Text(
                                            snapshot.data
                                                    .getNumPlaying()
                                                    .toString() +
                                                ' / ' +
                                                snapshot.data
                                                    .getNumMembers()
                                                    .toString(),
                                            style: TextStyle(
                                                fontSize:
                                                    Constants.smallFontSize,
                                                color: Constants.iWhite),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 15),
                                    Container(
                                      padding:
                                          EdgeInsets.fromLTRB(15, 20, 15, 5),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Players",
                                              style: TextStyle(
                                                  fontSize:
                                                      Constants.normalFontSize,
                                                  color: Constants.iWhite,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            JumpingDotsProgressIndicator(
                                              numberOfDots: 3,
                                              fontSize:
                                                  Constants.normalFontSize,
                                              color: Constants.iWhite,
                                            ),
                                          ]),
                                    ),
                                    Flexible(
                                      child: GridView.count(
                                        crossAxisCount: 2,
                                        childAspectRatio: (4 / 1),
                                        shrinkWrap: true,
                                        padding: EdgeInsets.all(2.0),
                                        children: snapshot.data
                                            .getMembers()
                                            .map((data) => Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  color: groupdata
                                                          .isUserPlaying(data)
                                                      ? Constants.iDarkGrey
                                                      : Constants.iDarkGrey,
                                                  child: Center(
                                                      child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 1.0,
                                                                  bottom: 1,
                                                                  left: 7,
                                                                  right: 7),
                                                          child: Center(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  data
                                                                      .getUsername()
                                                                      .split(
                                                                          ' ')[0],
                                                                  style: TextStyle(
                                                                      color: Constants
                                                                          .iWhite,
                                                                      fontSize:
                                                                          Constants
                                                                              .smallFontSize,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400),
                                                                ),
                                                                groupdata.isUserPlaying(
                                                                        data)
                                                                    ? Icon(
                                                                        Icons
                                                                            .check_box,
                                                                        size:
                                                                            25,
                                                                        color: Constants
                                                                            .colors[Constants.colorindex],
                                                                      )
                                                                    : Icon(
                                                                        Icons
                                                                            .check_box_outline_blank,
                                                                        size:
                                                                            25,
                                                                        color: Constants
                                                                            .iWhite,
                                                                      )
                                                              ],
                                                            ),
                                                          ))),
                                                ))
                                            .toList(),
                                      ),
                                    ),
                                    SizedBox(height: 120),
                                  ],
                                )),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 25.0),
                              child: Container(
                                padding: EdgeInsets.fromLTRB(3, 3, 3, 3),
                                child: groupdata.getPlaying().length !=
                                            groupdata.getMembers().length ||
                                        groupdata.getNextQuestionString() == ""
                                    ? GridView.count(
                                        crossAxisCount: 7,
                                        shrinkWrap: true,
                                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                            SizedBox(),
                                            SizedBox(),
                                            Tooltip(
                                              message: "Invite players",
                                              child: FloatingActionButton(
                                                  heroTag: 'invite',
                                                  elevation: 5.0,
                                                  child: Icon(
                                                    Icons.group_add,
                                                    color: Constants.iBlack,
                                                  ),
                                                  backgroundColor:
                                                      Constants.colors[
                                                          Constants.colorindex],
                                                  onPressed: () {
                                                    final RenderBox box = context
                                                            .findRenderObject()
                                                        as RenderBox;
                                                    String shareText =
                                                        "Join a game with this code:\n\n" +
                                                            code +
                                                            "\n\n\nDownload BlackBox on Google Play \nhttps://play.google.com/store/apps/details?id=be.dezijwegel.blackbox ";
                                                    Share.share(shareText,
                                                        sharePositionOrigin:
                                                            box.localToGlobal(
                                                                    Offset
                                                                        .zero) &
                                                                box.size);
                                                  }),
                                            ),
                                            SizedBox(),
                                            Tooltip(
                                                message: "Ready",
                                                child: FloatingActionButton(
                                                  heroTag: 'ready',
                                                  elevation: 0.0,
                                                  child: AvatarGlow(
                                                      startDelay: Duration(
                                                          milliseconds: 1),
                                                      glowColor:
                                                          Constants.iGrey,
                                                      endRadius: 40.0,
                                                      duration: Duration(
                                                          milliseconds: 1250),
                                                      shape: BoxShape.circle,
                                                      animate: true,
                                                      curve: Curves.easeOut,
                                                      repeat: true,
                                                      showTwoGlows: true,
                                                      //repeatPauseDuration: Duration(milliseconds: 1),
                                                      child: new Icon(
                                                          Icons.check,
                                                          color: Constants
                                                              .iBlack)),
                                                  backgroundColor:
                                                      Constants.colors[
                                                          Constants.colorindex],
                                                  onPressed: () {
                                                    if (groupdata.isUserPlaying(
                                                        Constants
                                                            .getUserData())) {
                                                      groupdata.removePlayingUser(
                                                          Constants
                                                              .getUserData());
                                                      _database.updateGroup(
                                                          groupdata);
                                                    } else {
                                                      groupdata.setPlayingUser(
                                                          Constants
                                                              .getUserData());
                                                      if (groupdata
                                                              .getNextQuestionString() ==
                                                          "")
                                                        getRandomNexQuestion();

                                                      _database.updateGroup(
                                                          groupdata);
                                                    }
                                                  },
                                                )),
                                          ])
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                            FlatButton(
                                              padding: EdgeInsets.fromLTRB(
                                                  50.0, 15.0, 50.0, 15.0),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(28.0),
                                              ),
                                              color: Constants
                                                  .colors[Constants.colorindex],
                                              onPressed: () {
                                                FirebaseAnalytics().logEvent(
                                                    name: 'game_action',
                                                    parameters: {
                                                      'code': groupdata
                                                          .getGroupCode(),
                                                      'type': 'GameStarted',
                                                    });

                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          QuestionScreen(
                                                              _database,
                                                              groupdata,
                                                              code),
                                                    ));
                                              },
                                              splashColor: Constants
                                                  .colors[Constants.colorindex],
                                              child: Text(
                                                "Start Game",
                                                style: TextStyle(
                                                    color: Constants.iBlack,
                                                    fontSize: Constants
                                                        .actionbuttonFontSize),
                                              ),
                                            )
                                          ]),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ));
  }
}
