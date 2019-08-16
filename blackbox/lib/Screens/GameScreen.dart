import 'package:flutter/material.dart';
import '../Interfaces/Database.dart';

import '../Database/FirebaseStream.dart';
import '../DataContainers/GroupData.dart';
import 'JoinGameScreen.dart';
import '../Constants.dart';
import 'QuestionScreen.dart';
import '../DataContainers/Question.dart';

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
    FirebaseStream(code).groupData.listen((_onGroupDataUpdate) {
    }, onDone: () {
      print("Task Done");
      _loadingInProgress = false;
    }, onError: (error) {
      print("Some Error");
    });
  }

 /* @override
  void dispose() {
    super.dispose();
    FirebaseStream.closeController();

    ///Something to close the stream goes here
  }*/

   void getRandomNexQuestion()async{
    groupdata.setNextQuestion(await _database.getRandomQuestion(Category.Any), Constants.getUserData());  }

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
            joined = true;
            print("joined Group");
            //_database.updateGroup(groupdata);

          }

          getRandomNexQuestion();


          return new Scaffold(
            body: DefaultTabController(
              length: 2,
              child: Scaffold(
                appBar: AppBar(
                  title: Container(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Row(
                      children: [
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        JoinGameScreen(_database),
                                  ));
                              groupdata.removeMember(Constants.getUserData());
                              _database.updateGroup(groupdata);

                              dispose();
                            },
                            child: Padding(
                              padding: EdgeInsets.only(right: 20),
                              child: const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.amber,
                              ),
                            )),
                        Center(
                          child: Text(
                            snapshot.data.getName(),
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  backgroundColor: Colors.black,
                  bottom: TabBar(
                    indicatorColor: Colors.amber,
                    indicatorSize: TabBarIndicatorSize.label,
                    tabs: [
                      new Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          new Icon(
                            Icons.info_outline,
                            color: Colors.white,
                            //size: 25,
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            child: Text(
                              'Info',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
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
                            color: Colors.white,
                            //size: 25,
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            child: Text(
                              'Members',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
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
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(padding: EdgeInsets.only(top: 40.0)),
                                Text(
                                  snapshot.data.getName(),
                                  style: TextStyle(
                                      color: Colors.amber,
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold),
                                ),
                                Padding(padding: EdgeInsets.only(top: 40.0)),
                                Text(
                                  snapshot.data.getDescription(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w400),
                                ),
                                Padding(padding: EdgeInsets.only(top: 80.0)),
                                Text(
                                  snapshot.data.getGroupCode(),
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            )),
                      ),

                      //tab 2
                      ListView(
                        padding: EdgeInsets.all(8.0),
                        children: snapshot.data
                            .getMembers()
                            .map((data) => Card(
                                  color: groupdata.isUserPlaying(data)
                                      ? Colors.amber
                                      : Colors.white,
                                  child: Center(
                                      child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: groupdata.isUserPlaying(data)
                                              ? Center(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Text(
                                                        data.getUsername(),
                                                        style: new TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 20.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        'ready',
                                                        style: new TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 15.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : Center(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Text(
                                                        data.getUsername(),
                                                        style: new TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 20.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        'Not ready',
                                                        style: new TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 15.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ],
                                                  ),
                                                ))),
                                ))
                            .toList(),
                      ),
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
        theme: new ThemeData(
          scaffoldBackgroundColor: Colors.black,
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
    return groupdata.getPlaying().length != groupdata.getMembers().length
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
                FlatButton(
                  color: Colors.amber,
                  onPressed: () {
                    if (groupdata.isUserPlaying(Constants.getUserData())) {
                      groupdata.removePlayingUser(Constants.getUserData());
                      _database.updateGroup(groupdata);
                    } else {
                      groupdata.setPlayingUser(Constants.getUserData());
                      _database.updateGroup(groupdata);
                    }
                  },
                  splashColor: Colors.white,
                  child: Text(
                    "Ready",
                    style: TextStyle(color: Colors.black),
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
                  color: Colors.amber,
                  onPressed: () {



                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              QuestionScreen(_database, groupdata, code),
                        ));
                  },
                  splashColor: Colors.white,
                  child: Text(
                    "Start Game",
                    style: TextStyle(color: Colors.black),
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
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Container(
      width: width,
      height: height / 11,
      padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(32), topLeft: Radius.circular(32))),
      child: _buildBottomCardChildren(context),
    );
  }
}
