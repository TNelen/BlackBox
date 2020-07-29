import 'package:blackbox/DataContainers/GroupData.dart';
import 'package:blackbox/Screens/Home/HomeScreen.dart';
import 'package:flutter/material.dart';
import '../Interfaces/Database.dart';
import '../Constants.dart';
import '../DataContainers/UserRankData.dart';

class OverviewScreen extends StatefulWidget {
  Database _database;
  GroupData groupData;

  OverviewScreen(Database db, GroupData gd) {
    this._database = db;
    this.groupData = gd;
  }

  @override
  _OverviewScreenState createState() =>
      new _OverviewScreenState(_database, groupData);
}

class _OverviewScreenState extends State<OverviewScreen> {
  Database _database;
  GroupData groupData;

  _OverviewScreenState(Database db, GroupData gd) {
    this._database = db;
    this.groupData = gd;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, Map<String, int>> history = groupData.getHistory();
    print(history);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BlackBox',
      theme: new ThemeData(scaffoldBackgroundColor: Constants.iBlack),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Constants.iBlack,
          title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            InkWell(
              onTap: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => HomeScreen(_database),
                    ))
              },
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: Icon(
                      Icons.home,
                      color: Constants.colors[Constants.colorindex],
                    ),
                  ),
                  Text(
                    'Home',
                    style: TextStyle(
                      fontSize: 20,
                      color: Constants.colors[Constants.colorindex],
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
        body: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 22),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: groupData.getHistory().length,
            itemBuilder: (context, index) {
              String key = groupData.getHistory().keys.elementAt(index);
              List<UserRankData> results = groupData.getUserRankingList(
                  'overview', groupData.getHistory()[key]);
              return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: Constants.iBlack,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        key,
                        textAlign: TextAlign.center,
                        style: new TextStyle(
                            color: Constants.iWhite,
                            fontSize: 23.0,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      ListView.separated(
                        physics: new NeverScrollableScrollPhysics(),
                        separatorBuilder: (context, index2) => Divider(
                          color: Colors.white,
                          height: 0.5,
                        ),
                        shrinkWrap: true,
                        itemCount: results.length,
                        itemBuilder: (context, index2) {
                          return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              color: Constants.iBlack,
                              child: Center(
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 1.0,
                                        bottom: 1,
                                        left: 15,
                                        right: 30),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              SizedBox(
                                                width: 15,
                                              ),
                                              Text(
                                                (index2 + 1).toString() +
                                                    (index2 == 0
                                                        ? 'st'
                                                        : index2 == 1
                                                            ? 'nd'
                                                            : index2 == 2
                                                                ? 'rd'
                                                                : 'th'),
                                                style: new TextStyle(
                                                    color: index2 == 0
                                                        ? Constants.colors[
                                                            Constants
                                                                .colorindex]
                                                        : Constants.iWhite,
                                                    fontSize: 20.0,
                                                    fontWeight:
                                                        FontWeight.w400),
                                                textAlign: TextAlign.start,
                                              ),
                                              SizedBox(
                                                width: 12,
                                              ),
                                              Text(
                                                results[index2]
                                                    .getUserName()
                                                    .split(' ')[0],
                                                style: new TextStyle(
                                                    color: index2 == 0
                                                        ? Constants.colors[
                                                            Constants
                                                                .colorindex]
                                                        : Constants.iWhite,
                                                    fontSize: 20.0,
                                                    fontWeight:
                                                        FontWeight.w300),
                                                textAlign: TextAlign.start,
                                              ),
                                            ]),
                                        Text(
                                          results[index2]
                                              .getNumVotes()
                                              .toString(),
                                          style: new TextStyle(
                                              color: index2 == 0
                                                  ? Constants.colors[
                                                      Constants.colorindex]
                                                  : Constants.iWhite,
                                              fontSize: 25.0,
                                              fontWeight: FontWeight.w600),
                                          textAlign: TextAlign.start,
                                        ),
                                      ],
                                    )),
                              ));
                        },
                      ),
                    ],
                  ));
            }),
      ),
    );
  }
}