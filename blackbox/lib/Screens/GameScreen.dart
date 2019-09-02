import 'package:flutter/material.dart';
import '../Interfaces/Database.dart';
import '../Database/FirebaseStream.dart';
import '../DataContainers/GroupData.dart';
import '../Constants.dart';
import 'QuestionScreen.dart';
import '../DataContainers/Question.dart';
import 'HomeScreen.dart';

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
        await _database.getRandomQuestion(groupdata,
            Question.getCategoryFromString(groupdata.getDescription())),
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
              length: 3,
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
                            Icons.info_outline,
                            color: Constants.iWhite,
                            //size: 25,
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            child: Text(
                              'Info',
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
                          Icon(
                            Icons.people_outline,
                            color: Constants.iWhite,
                            //size: 25,
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            child: Text(
                              'Members',
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
                              'Help',
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
                                SizedBox(height: 35),
                                Card(
                                  color: Constants.iDarkGrey,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  child: Container(
                                    padding:
                                        EdgeInsets.fromLTRB(15, 25, 15, 25),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Group Name",
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              color: Constants.colors[
                                                  Constants.colorindex]),
                                        ),
                                        Text(
                                          snapshot.data.getName(),
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              color: Constants.iWhite),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 7),
                                Card(
                                  color: Constants.iDarkGrey,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  child: Container(
                                    padding:
                                        EdgeInsets.fromLTRB(15, 25, 15, 25),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Category",
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              color: Constants.colors[
                                                  Constants.colorindex]),
                                        ),
                                        Text(
                                          snapshot.data.getDescription(),
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              color: Constants.iWhite),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 7),
                                Card(
                                  color: Constants.iDarkGrey,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  child: Container(
                                    padding:
                                        EdgeInsets.fromLTRB(15, 25, 15, 25),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Group Code",
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              color: Constants.colors[
                                                  Constants.colorindex]),
                                        ),
                                        Text(
                                          snapshot.data.getGroupCode(),
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              color: Constants.iWhite),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 7),
                                Card(
                                  color: Constants.iDarkGrey,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  child: Container(
                                    padding:
                                        EdgeInsets.fromLTRB(15, 25, 15, 25),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Players ready",
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              color: Constants.colors[
                                                  Constants.colorindex]),
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
                                ),
                              ],
                            )),
                      ),

                      //tab 2
                      ListView(
                        padding: EdgeInsets.all(8.0),
                        children: snapshot.data
                            .getMembers()
                            .map((data) => Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  color: groupdata.isUserPlaying(data)
                                      ? Constants.iWhite
                                      : Constants.iWhite,
                                  child: Center(
                                      child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 15.0,
                                              bottom: 15,
                                              left: 20,
                                              right: 25),
                                          child: groupdata.isUserPlaying(data)
                                              ? Center(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Text(
                                                        data.getUsername(),
                                                        style: new TextStyle(
                                                            color: Constants
                                                                .iBlack,
                                                            fontSize: 20.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      Icon(
                                                        Icons.check_box,
                                                        size: 25,
                                                        color: Constants.colors[
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
                                                    children: <Widget>[
                                                      Text(
                                                        data.getUsername(),
                                                        style: new TextStyle(
                                                            color: Constants
                                                                .iBlack,
                                                            fontSize: 20.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      Icon(
                                                        Icons
                                                            .check_box_outline_blank,
                                                        size: 25,
                                                        color:
                                                            Constants.iDarkGrey,
                                                      )
                                                    ],
                                                  ),
                                                ))),
                                ))
                            .toList(),
                      ),

                      //tab3
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
                            'Press ready to set yourself in ready state' +
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
                            'Vote on a group member' +
                                '\n' +
                                'Once a vote is submitted, it can not be changed.' +
                                '\n' +
                                'You have 2 minutes to vote for a question.' +
                                '\n' +
                                '\n' +
                                'Due to database ussues (Looking at you Google) , 2 members voting at exact the same time can cause a vote to be lost',
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
                            'After you have votes you will enter a collecting results waiting screen.' +
                                '\n' +
                                'It shows the number of people that still have to vote.' +
                                '\n' +
                                'The admin wil see a countdown timer. It shows the time there is left for the members to vote' +
                                '\n' +
                                'When this time is elapsed the players go to the results screen, no matter how many peaple still have to vote.' +
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
                                'The category of the questions is chosen on group creation',
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
                            'Leave a running game by clicking on the leave button ingame.' +
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
                          SizedBox(height: 20),
                          Text(
                            'Miscellaneous',
                            style: new TextStyle(
                              color: Constants.colors[Constants.colorindex],
                              fontSize: 25.0,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'For the best performance please update the app to the newest version.',
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
