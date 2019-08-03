import 'package:flutter/material.dart';
import '../Interfaces/Database.dart';

import '../Database/FirebaseStream.dart';
import '../DataContainers/GroupData.dart';
import 'WaitingScreen.dart';

class GameScreen extends StatelessWidget {
  Database _database;
  GroupData groupInfo; 

  GameScreen(Database db) {
    this._database = db;

    new FirebaseStream( "-LkoEjPkbJU3KMIJPf1I" ).groupData.listen( _onGroupDataUpdate );
  }

  void _onGroupDataUpdate (GroupData groupData)
  {
      groupInfo = groupData;

      if ( groupInfo == null )
      {
        // Laadscherm
        print("NULL LOADED");
      } else {
        // Refresh content
        print("DATA LOADED");
        
      }
  }

    @override
    Widget build(BuildContext context) {
      final width = MediaQuery
          .of(context)
          .size
          .width;
      final height = MediaQuery
          .of(context)
          .size
          .height;

      return MaterialApp(
        theme: new ThemeData(
          scaffoldBackgroundColor: Colors.black,
        ),
        home: Scaffold(
          body: DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                title: Container(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Row(
                    children: [
                      InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: const Icon(
                              Icons.arrow_back_ios,
                              color: Colors.amber,
                            ),
                          )),
                      Center(
                        child: Text(
                          groupInfo.groupName,
                          style: TextStyle(
                            fontSize: 28,
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
                          Icons.group_add,
                          color: Colors.white,
                          //size: 25,
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          child: Text(
                            'Invite',
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
                    new Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.settings,
                          color: Colors.white,
                          //size: 25,
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          child: Text(
                            'Settings',
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
              body: Stack(
                children: <Widget>[
                  TabBarView(
                    children: [
                      //tab 1
                      Center(
                        child: Container(
                          alignment: Alignment(0, 0),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: 'Display group code here + copy icon',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 50),
                            ),
                          ),
                        ),
                      ),

                      //tab 2
                      GridView.count(
                        crossAxisCount: 2,
                        padding: EdgeInsets.all(8.0),
                        crossAxisSpacing: 12.0,
                        mainAxisSpacing: 12.0,
                        children: groupInfo.getMembers()
                            .map((data) =>
                            Card(
                              color: data == groupInfo.adminID
                                  ? Colors.amber
                                  : Colors.white,
                              child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: data == groupInfo.adminID
                                        ? Center(
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            data,
                                            style: new TextStyle(
                                                color: Colors.black,
                                                fontSize: 20.0,
                                                fontWeight:
                                                FontWeight.bold),
                                          ),
                                          Text(
                                            'Admin',
                                            style: new TextStyle(
                                                color: Colors.black,
                                                fontSize: 15.0,
                                                fontWeight:
                                                FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    )
                                        : Text(
                                      data,
                                      style: new TextStyle(
                                          color: Colors.black,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                            ))
                            .toList(),
                      ),

                      //tab 3
                      new Text(
                        'settings',
                        style: new TextStyle(
                            color: Colors.white, fontSize: 20.0),
                      ),
                    ],
                  ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: _buildBottomCard(width, height, context)),
                ],
              ),
            ),
          ),
        ),
      );
    }

    Widget _buildBottomCard(double width, double, BuildContext context) {
      final width = MediaQuery
          .of(context)
          .size
          .width;
      final height = MediaQuery
          .of(context)
          .size
          .height;

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

    Widget _buildBottomCardChildren(BuildContext context) {
      return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          WaitingScreen(groupInfo),
                    ));
              },
              icon: Icon(
                Icons.play_arrow,
                size: 50,
              ),
              padding: EdgeInsets.all(2),
            ),
            /*Text('Home',
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                    ),
                  ),*/
          ]);
  }
}

