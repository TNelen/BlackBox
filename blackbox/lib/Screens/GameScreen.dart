import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../Interfaces/Database.dart';
import '../Database/FirebaseStream.dart';
import '../DataContainers/GroupData.dart';
import '../Constants.dart';
import 'QuestionScreen.dart';
import '../DataContainers/Question.dart';
import 'HomeScreen.dart';
import 'package:share/share.dart';
import 'package:auto_size_text/auto_size_text.dart';

class GameScreen extends StatefulWidget {
  Database _database;
  GroupData groupInfo = null;
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

  bool _loadingInProgress;
  GroupData groupdata;

  _GameScreenState(Database db, String code) {
    this._database = db;
    this.code = code;
    this.stream = new FirebaseStream(code);
  }

  @override
  void initState() {
    groupdata = null;
    super.initState();
    _loadingInProgress = true;
    FirebaseStream(code).groupData.listen((_onGroupDataUpdate) {}, onDone: () {
      print("Task Done");
      _loadingInProgress = false;
    }, onError: (error) {
      _errorPopup(error);
    });
  }

  /* @override
  void dispose() {
    super.dispose();
    FirebaseStream.closeController();

    ///Something to close the stream goes here
  }*/

  void getRandomNexQuestion() async {
    groupdata.setNextQuestion(
        await _database.getNextQuestion(groupdata),
        Constants.getUserData());
  }

  Widget _buildBody() {
    return StreamBuilder(
        stream: stream.groupData,
        builder: (BuildContext context, AsyncSnapshot<GroupData> snapshot) {
          groupdata = snapshot.data;
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          if (!snapshot.hasData) {
            return new Center(child: new CircularProgressIndicator());
          }
          if (!joined) {
            groupdata.addMember(Constants.getUserData());
            Constants.database.updateGroup(groupdata);
            joined = true;
            print("joined Group");

            //_database.updateGroup(groupdata);

          }

          return new Scaffold(
            body: DefaultTabController(
              length: 2,
              child: Scaffold(
                appBar: AppBar(
                  title: Container(
                    padding: EdgeInsets.only(bottom: 10),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  HomeScreen(_database),
                            ));
                        groupdata.removeMember(Constants.getUserData());
                        _database.updateGroup(groupdata);

                        dispose();
                      },
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: Icon(
                              Icons.arrow_back,
                              color: Constants.colors[Constants.colorindex],
                            ),
                          ),
                          Text(
                            'Back',
                            style: TextStyle(
                              fontSize: 20,
                              color: Constants.colors[Constants.colorindex],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  backgroundColor: Constants.iBlack,
                  bottom: TabBar(
                    indicatorColor: Constants.colors[Constants.colorindex],
                    indicatorSize: TabBarIndicatorSize.label,
                    tabs: [
                      new Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          new Icon(
                            Icons.people,
                            color: Constants.iWhite,
                            //size: 25,
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            child: Text(
                              'Game Lobby',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                color: Constants.iWhite,
                              ),
                            ),
                          ),
                        ],
                      ),
                      new Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          new Icon(
                            Icons.help_outline,
                            color: Constants.iWhite,
                            //size: 25,
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            child: Text(
                              'Rules',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                color: Constants.iWhite,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                body: Stack(children: <Widget>[
                  TabBarView(
                    children: [
                      //tab 1
                      Center(
                        child: Container(
                            alignment: Alignment.center,
                            child: Column(
                              children: <Widget>[
                                SizedBox(height: 40),
                                Container(
                                  padding: EdgeInsets.fromLTRB(15, 10, 15, 5),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Text(
                                              'The admin can start the game if all players are ready!',
                                              style: new TextStyle(
                                                  color: Constants.colors[
                                                      Constants.colorindex],
                                                  fontSize: 25.0,
                                                  fontWeight: FontWeight.w400),
                                              textAlign: TextAlign.center),
                                        ),
                                      ]),
                                ),
                                SizedBox(height: 30),
                                Container(
                                  padding: EdgeInsets.fromLTRB(15, 5, 15, 3),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Players ready:  ",
                                        style: TextStyle(
                                            fontSize: 20.0,
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
                                            fontSize: 20.0,
                                            color: Constants.iWhite),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(15, 1, 15, 1),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "   Invite players  ",
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            color: Constants
                                                .colors[Constants.colorindex]),
                                      ),
                                      Row(
                                        children: <Widget>[
                                          IconButton(
                                              icon: Icon(
                                                Icons.group_add,
                                                color: Constants.colors[
                                                    Constants.colorindex],
                                              ),
                                              onPressed: () {
                                                final RenderBox box =
                                                    context.findRenderObject();
                                                Share.share(code,
                                                    sharePositionOrigin:
                                                        box.localToGlobal(
                                                                Offset.zero) &
                                                            box.size);
                                              }),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(15, 10, 15, 5),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Players",
                                          style: TextStyle(
                                              fontSize: 25.0,
                                              color: Constants.iWhite,
                                              fontWeight: FontWeight.w500),
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
                                                    BorderRadius.circular(10.0),
                                              ),
                                              color:
                                                  groupdata.isUserPlaying(data)
                                                      ? Constants.iDarkGrey
                                                      : Constants.iDarkGrey,
                                              child: Center(
                                                  child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 1.0,
                                                              bottom: 1,
                                                              left: 7,
                                                              right: 7),
                                                      child: groupdata
                                                              .isUserPlaying(
                                                                  data)
                                                          ? Center(
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
                                                                    style: new TextStyle(
                                                                        color: Constants
                                                                            .iWhite,
                                                                        fontSize:
                                                                            20.0,
                                                                        fontWeight:
                                                                            FontWeight.w400),
                                                                  ),
                                                                  Icon(
                                                                    Icons
                                                                        .check_box,
                                                                    size: 25,
                                                                    color: Constants
                                                                            .colors[
                                                                        Constants
                                                                            .colorindex],
                                                                  )
                                                                ],
                                                              ),
                                                            )
                                                          : Center(
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
                                                                    style: new TextStyle(
                                                                        color: Constants
                                                                            .iWhite,
                                                                        fontSize:
                                                                            20.0,
                                                                        fontWeight:
                                                                            FontWeight.w400),
                                                                  ),
                                                                  Icon(
                                                                    Icons
                                                                        .check_box_outline_blank,
                                                                    size: 25,
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
                                SizedBox(height: 100),
                              ],
                            )),
                      ),

                      //tab2
                      Center(
                          child: ListView(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(20.0),
                        children: [
                          SizedBox(height: 20),
                          Text(
                            'Start Game',
                            style: new TextStyle(
                              color: Constants.colors[Constants.colorindex],
                              fontSize: 25.0,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Press the ready button to ready up.' +
                                '\n' +
                                'When all players are ready, the button on the bottom becomes the start button, press start to begin the game.',
                            style: new TextStyle(
                              color: Constants.iWhite,
                              fontSize: 18.0,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Voting',
                            style: new TextStyle(
                              color: Constants.colors[Constants.colorindex],
                              fontSize: 25.0,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Vote on a group member.' +
                                '\n' +
                                'Once a vote is submitted, it can not be changed.' +
                                '\n' +
                                'You have 2 minutes to vote for a question.' +
                                '\n' +
                                '\n' +
                                'Due to database issues, 2 members voting at exact the same time can cause a vote to be lost.',
                            style: new TextStyle(
                              color: Constants.iWhite,
                              fontSize: 18.0,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Collecting results',
                            style: new TextStyle(
                              color: Constants.colors[Constants.colorindex],
                              fontSize: 25.0,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'After you have voted you will enter a collecting results waiting screen.' +
                                '\n' +
                                'It shows the number of people that still have to vote.' +
                                '\n' +
                                'The admin wil see a countdown timer. It shows the time there is left for the members to vote.' +
                                '\n' +
                                'When this time is elapsed the players go to the results screen, no matter how many people still have to vote.' +
                                '\n' +
                                '',
                            style: new TextStyle(
                              color: Constants.iWhite,
                              fontSize: 18.0,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Questions',
                            style: new TextStyle(
                              color: Constants.colors[Constants.colorindex],
                              fontSize: 25.0,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Questions are generated in a random order.' +
                                '\n' +
                                'The category of the questions is chosen on group creation.',
                            style: new TextStyle(
                              color: Constants.iWhite,
                              fontSize: 18.0,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Leave',
                            style: new TextStyle(
                              color: Constants.colors[Constants.colorindex],
                              fontSize: 25.0,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Leave a running game by clicking on the leave in the top right corner.' +
                                '\n' +
                                'Please do not close the app before leaving an active game.',
                            style: new TextStyle(
                              color: Constants.iWhite,
                              fontSize: 18.0,
                            ),
                          ),
                          Text(
                            'If there are no more players in a group, the group is deleted',
                            style: new TextStyle(
                              color: Constants.iWhite,
                              fontSize: 18.0,
                            ),
                          ),
                          SizedBox(height: 80),
                        ],
                      ))
                    ],
                  ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: _buildBottomCard(context))
                ]),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          scaffoldBackgroundColor: Constants.iBlack,
        ),
        home: Scaffold(
          body: _buildBody(),
        ));
  }

  Widget _onGroupDataUpdate(GroupData groupData) {
    GroupData groupInfo = groupData;
    bool loaded;

    if (groupInfo == null) {
      // Laadscherm
      loaded = false;
      print("NULL LOADED");
    } else {
      // Refresh content
      loaded = true;
      print("DATA LOADED");
      groupInfo.printData();
    }
  }

  Widget _buildBottomCardChildren(BuildContext context) {
    ///Check if all members are ready to go to questionscreen
    return groupdata.getPlaying().length != groupdata.getMembers().length ||
            groupdata.getNextQuestionString() == ""
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
                FlatButton(
                  color: Constants.colors[Constants.colorindex],
                  onPressed: () {
                    if (groupdata.isUserPlaying(Constants.getUserData())) {
                      groupdata.removePlayingUser(Constants.getUserData());
                      _database.updateGroup(groupdata);
                    } else {
                      groupdata.setPlayingUser(Constants.getUserData());
                      _database.updateGroup(groupdata);
                    }
                    getRandomNexQuestion();
                  },
                  splashColor: Constants.iWhite,
                  child: Text(
                    "Ready",
                    style: TextStyle(
                        color: Constants.iBlack,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                )
                /*Text('Home',
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                    ),
                  ),*/
              ])
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
                FlatButton(
                  color: Constants.colors[Constants.colorindex],
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              QuestionScreen(_database, groupdata, code),
                        ));
                  },
                  splashColor: Constants.colors[Constants.colorindex],
                  child: Text(
                    "Start Game",
                    style: TextStyle(color: Constants.iBlack, fontSize: 22),
                  ),
                )
                /*Text('Home',
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                    ),
                  ),*/
              ]);
  }

  Widget _buildBottomCard(BuildContext context) {
    return Card(
      color: Constants.colors[Constants.colorindex],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: InkWell(
          splashColor: Constants.colors[Constants.colorindex],
          onTap: () {
            //nothing yet
          },
          child: Container(
              padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
              child: _buildBottomCardChildren(context))),
    );
  }

  void _errorPopup(String error) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: Constants.iWhite,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0))),
          title: new Text(
            "Oops!",
            style: TextStyle(color: Constants.iBlack, fontSize: 25),
          ),
          content: new Text(
            error,
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => HomeScreen(_database),
                    ));
              },
            ),
          ],
        );
      },
    );
  }
}
