import 'package:blackbox/Models/GroupData.dart';
import 'package:blackbox/Screens/HomeScreen.dart';
import 'package:flutter/material.dart';
import '../../Interfaces/Database.dart';
import '../../Constants.dart';
import '../../Models/UserRankData.dart';

import 'package:blackbox/translations/gameScreens.i18n.dart';


import 'package:i18n_extension/i18n_widget.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


class OverviewScreen extends StatefulWidget {
  Database _database;
  GroupData groupData;

  OverviewScreen(Database db, GroupData gd) {
    this._database = db;
    this.groupData = gd;
  }

  @override
  _OverviewScreenState createState() =>
      _OverviewScreenState(_database, groupData);
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

    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''), // English, no country code
        const Locale('nl', ''), // nl, no country code
      ],
      debugShowCheckedModeBanner: false,
      title: 'BlackBox',
      theme: ThemeData(
        fontFamily: "atarian",
        scaffoldBackgroundColor: Colors.transparent,
      ),
      home: I18n(child: Scaffold(
        appBar: AppBar(
        elevation: 0,
        backgroundColor: Constants.iBlack,
        title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => HomeScreen(),
                  ));
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
                  'Home'.i18n,
                  style: TextStyle(
                    fontSize: Constants.actionbuttonFontSize,
                    color: Constants.colors[Constants.colorindex],
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomLeft,
            stops: [0.1, 1.0],
            colors: [
              Constants.gradient1,
              Constants.gradient2,
            ],
          ),
        ),
        child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 22),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: groupData
                .getHistory()
                .length,
            itemBuilder: (context, index) {
              String key = groupData
                  .getHistory()
                  .keys
                  .elementAt(index);
              List<UserRankData> results = groupData.getUserRankingList(
                  'overview'.i18n, groupData.getHistory()[key]);
              return results.length != 0
                  ? Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: Colors.transparent,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        key,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Constants.iWhite,
                            fontSize: Constants.actionbuttonFontSize,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        separatorBuilder: (context, index2) =>
                            Divider(
                              color: Constants.iBlack,
                              height: 0.5,
                            ),
                        shrinkWrap: true,
                        itemCount: results.length,
                        itemBuilder: (context, index2) {
                          return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              color: Colors.transparent,
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
                                                        ? 'st'.i18n
                                                        : index2 == 1
                                                        ? 'nd'.i18n
                                                        : index2 == 2
                                                        ? 'rd'.i18n
                                                        : 'th'.i18n),
                                                style: TextStyle(
                                                    color: index2 == 0
                                                        ? Constants
                                                        .colors[
                                                    Constants
                                                        .colorindex]
                                                        : Constants
                                                        .iWhite,
                                                    fontSize: Constants
                                                        .smallFontSize,
                                                    fontWeight:
                                                    FontWeight.w400),
                                                textAlign:
                                                TextAlign.start,
                                              ),
                                              SizedBox(
                                                width: 12,
                                              ),
                                              Text(
                                                results[index2]
                                                    .getId()
                                                    .split(' ')[0],
                                                style: TextStyle(
                                                    color: index2 == 0
                                                        ? Constants
                                                        .colors[
                                                    Constants
                                                        .colorindex]
                                                        : Constants
                                                        .iWhite,
                                                    fontSize: Constants
                                                        .smallFontSize,
                                                    fontWeight:
                                                    FontWeight.w300),
                                                textAlign:
                                                TextAlign.start,
                                              ),
                                            ]),
                                        Text(
                                          results[index2]
                                              .getNumVotes()
                                              .toString(),
                                          style: TextStyle(
                                              color: index2 == 0
                                                  ? Constants.colors[
                                              Constants
                                                  .colorindex]
                                                  : Constants.iWhite,
                                              fontSize:
                                              Constants.smallFontSize,
                                              fontWeight:
                                              FontWeight.w600),
                                          textAlign: TextAlign.start,
                                        ),
                                      ],
                                    )),
                              ));
                        },
                      ),
                    ],
                  ))
                  : SizedBox(
                height: 0,
              );
            }),
      ),),)
    ,
    );
  }
}
