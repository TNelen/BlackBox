import 'dart:math';

import 'package:blackbox/DataContainers/GroupData.dart';
import 'package:blackbox/DataContainers/UserData.dart';
import 'package:blackbox/Screens/PartyScreens/PartyQuestionScreen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import '../../Interfaces/Database.dart';
import '../popups/Popup.dart';
import '../../Constants.dart';
import 'package:blackbox/Database/QuestionListGetter.dart';

Map<UserData, int> convertUserListToUserDataMap(List<String> users, bool canVoteBlank) {
  Map<UserData, int> userMap = Map<UserData, int>();
  int index = 0;
  while (index < users.length) {
    UserData tempUser = UserData((index + 1).toString(), users[index]);
    userMap.addAll({tempUser: 0});
    index++;
  }

  if (canVoteBlank) {
    UserData tempUser = UserData("0", "Blank");
    userMap.addAll({tempUser: 0});
  }
  return userMap;
}

class SetPlayersScreen extends StatefulWidget {
  Database _database;
  List<String> selectedCategory = [];
  bool canVoteBlank;

  SetPlayersScreen(Database db, List<String> selectedCategory, bool canVoteBlank) {
    this._database = db;
    this.selectedCategory = selectedCategory;
    this.canVoteBlank = canVoteBlank;
  }

  @override
  _SetPlayersScreenState createState() => _SetPlayersScreenState(_database, selectedCategory, canVoteBlank);
}

class _SetPlayersScreenState extends State<SetPlayersScreen> {
  Database _database;
  List<String> selectedCategory;
  List<String> players = [Constants.getUsername().split(" ")[0]];
  bool canVoteBlank;
  TextEditingController codeController = TextEditingController();

  _SetPlayersScreenState(Database db, List<String> selectedCategory, bool canVoteBlank) {
    this._database = db;
    this.selectedCategory = selectedCategory;
    this.canVoteBlank = canVoteBlank;

    FirebaseAnalytics().logEvent(name: 'open_screen', parameters: {'screen_name': 'setPlayersScreen'});
  }

  final QuestionListGetter questionListGetter = QuestionListGetter.instance;

  @override
  Widget build(BuildContext context) {
    String removedPlayer = "";
    int removedIndex = null;

    final playerlist = Scrollbar(
        child: ListView.separated(
            shrinkWrap: true,
            separatorBuilder: (context, index) => Divider(
                  indent: 40,
                  endIndent: 40,
                  color: Constants.iLight,
                ),
            itemCount: players.length,
            itemBuilder: (context, index) => Dismissible(
                background: Container(),
                secondaryBackground: Container(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                    child: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
                ),
                key: Key(players[index]),
                child: Center(
                  child: Text(
                    players[index],
                    style: TextStyle(
                      color: Constants.iWhite,
                      fontSize: Constants.normalFontSize,
                      fontWeight: FontWeight.w300,
                      fontFamily: "atarian",
                    ),
                  ),
                ),
                onDismissed: (direction) {
                  // Show a snackbar. This snackbar could also contain "Undo" actions.
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text(
                      'Player deleted.',
                      style: TextStyle(color: Constants.iWhite, fontSize: Constants.miniFontSize, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                    duration: Duration(seconds: 3),
                    backgroundColor: Constants.iDarkGrey,
                    action: SnackBarAction(
                      label: 'Undo',
                      textColor: Constants.colors[Constants.colorindex], // or some operation you would like
                      onPressed: () {
                        setState(() => players.insert(removedIndex, removedPlayer));
                      },
                    ),
                  ));
                  // Remove the item from the data source.
                  setState(() {
                    removedPlayer = players[index];
                    removedIndex = index;
                    players.removeAt(index);
                  });
                })));

    TextEditingController playerNameController = TextEditingController();

    final namefield = Theme(
      data: ThemeData(
        primaryColor: Constants.colors[Constants.colorindex],
        primaryColorDark: Constants.colors[Constants.colorindex],
      ),
      child: TextField(
        obscureText: false,
        keyboardType: TextInputType.text,
        autocorrect: false,
        maxLength: 15,
        maxLines: 1,
        controller: playerNameController,
        style: TextStyle(fontFamily: "atarian", fontSize: Constants.smallFontSize, color: Constants.iWhite),
        decoration: InputDecoration(
            focusColor: Constants.colors[Constants.colorindex],
            hoverColor: Constants.colors[Constants.colorindex],
            contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
            fillColor: Constants.iBlack,
            filled: true,
            hintText: "Start typing here...",
            hintStyle: TextStyle(fontFamily: "atarian", fontSize: Constants.smallFontSize, color: Constants.iGrey),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0))),
      ),
    );

    final addPlayerButton = FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(26.0),
      ),
      padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              // return object of type Dialog
              return AlertDialog(
                backgroundColor: Constants.iBlack,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                title: Text(
                  'Player Name',
                  style: TextStyle(fontFamily: "atarian", color: Constants.colors[Constants.colorindex], fontSize: Constants.subtitleFontSize),
                ),
                content: Container(
                    height: 150,
                    child: Column(children: [
                      SizedBox(height: 25),
                      namefield,
                    ])),
                actions: <Widget>[
                  // usually buttons at the bottom of the dialog
                  FlatButton(
                    child: Text(
                      "Cancel",
                      style: TextStyle(fontFamily: "atarian", color: Constants.colors[Constants.colorindex], fontSize: Constants.actionbuttonFontSize, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),

                  FlatButton(
                    child: Text(
                      "Add",
                      style: TextStyle(fontFamily: "atarian", color: Constants.colors[Constants.colorindex], fontSize: Constants.actionbuttonFontSize, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      String name = playerNameController.text;
                      //print('-' + question+ '-');
                      if (name.length < 2) {
                        Popup.makePopup(context, 'Whoops!', 'Player name is too short');
                      }
                      if (players.contains(name[0].toUpperCase() + name.substring(1))) {
                        Popup.makePopup(context, 'Whoops!', 'This player already exists');
                      } else {
                        FirebaseAnalytics().logEvent(name: 'action_performed', parameters: {'action_name': 'addPlayer'});
                        Navigator.pop(context);

                        setState(() => players.add(name[0].toUpperCase() + name.substring(1)));
                      }
                    },
                  ),
                ],
              );
            });
      },
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          "Add player",
          style: TextStyle(
            color: Constants.colors[Constants.colorindex],
            fontSize: Constants.smallFontSize,
            fontWeight: FontWeight.w300,
            fontFamily: "atarian",
          ),
        ),
        Icon(Icons.add, color: Constants.colors[Constants.colorindex]),
      ]),
    );

    final createButton = Hero(
      tag: 'tobutton',
      child: Padding(
        padding: EdgeInsets.only(left: 45, right: 45),
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(26.0),
          color: Constants.colors[Constants.colorindex],
          child: MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(26.0),
            ),
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
            onPressed: () {
              // Create map of members
              Map<String, String> members = Map<String, String>();
              members[Constants.getUserID()] = Constants.getUsername();

              Map<UserData, int> userMap = convertUserListToUserDataMap(players, canVoteBlank);
              print(userMap);

              //add all players to the group
              userMap.forEach((user, value) {
                members.putIfAbsent(user.getUserID(), () => user.getUsername());
              });

              String _groupName = "default";
              if (players.length != 0 && selectedCategory.length != 0) {
                // Generate a unique ID and save the group
                _database.generateUniqueGroupCode().then((code) async {
                  List<String> questionIDs = List<String>();
                  String description = "PartyGame";

                  for (String groupCategory in selectedCategory) {
                    questionIDs.addAll(questionListGetter.mappings[groupCategory] ?? []);
                    description += groupCategory + " ";
                  }

                  questionIDs.shuffle(Random.secure());

                  Map<String, dynamic> map = {
                    'code': 'New group',
                    'type': 'PartyCreated',
                    'can_vote_blank': canVoteBlank,
                  };

                  List<String> allCategories = await QuestionListGetter.instance.getCategoryNames();
                  for (String category in allCategories) map[category.replaceAll(' ', '_').replaceAll("'", '').replaceAll('+', 'P')] = selectedCategory.contains(category);

                  // General game action log
                  FirebaseAnalytics().logEvent(name: 'game_action', parameters: map);

                  // Only logged here
                  FirebaseAnalytics().logEvent(name: 'party_created', parameters: map);

                  GroupData groupdata = GroupData(_groupName, description, canVoteBlank, false, code, Constants.getUserID(), members, questionIDs);
                  await groupdata.setNextQuestion(await _database.getNextQuestion(groupdata), Constants.getUserData(), doDatabaseUpdate: false);
                  await _database.updateGroup(groupdata);

                  print("Party group code: " + groupdata.getGroupCode());

                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => PartyQuestionScreen(_database, groupdata, code, userMap, 0),
                      ));
                });
              } else {
                Popup.makePopup(context, "Woops!", "There should be at least one player!");
              }
            },
            child: Text("Start",
                textAlign: TextAlign.center, style: TextStyle(fontFamily: "atarian", fontSize: Constants.actionbuttonFontSize).copyWith(color: Constants.iDarkGrey, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BlackBox',
        theme: ThemeData(scaffoldBackgroundColor: Constants.iBlack),
        home: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Constants.iBlack,
            title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              InkWell(
                onTap: () => Navigator.pop(context),
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
                        fontFamily: "atarian",
                        fontSize: Constants.actionbuttonFontSize,
                        color: Constants.colors[Constants.colorindex],
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
          body: Center(
            child: Container(
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
              child: ListView(
                padding: const EdgeInsets.only(top: 36.0, bottom: 36, left: 63, right: 63),
                children: <Widget>[
                  Hero(
                    tag: "PartHeader",
                    child: Text(
                      'who\'s playing?',
                      style: TextStyle(
                        color: Constants.iWhite,
                        fontSize: Constants.titleFontSize,
                        fontWeight: FontWeight.w300,
                        fontFamily: "atarian",
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.people_outline,
                        color: Constants.colors[Constants.colorindex],
                        size: 30,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        'Players',
                        style: TextStyle(
                          color: Constants.colors[Constants.colorindex],
                          fontSize: Constants.normalFontSize,
                          fontFamily: "atarian",
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        '(' + players.length.toString() + ')',
                        style: TextStyle(
                          color: Constants.colors[Constants.colorindex],
                          fontSize: Constants.smallFontSize,
                          fontFamily: "atarian",
                        ),
                      ),
                      SizedBox(
                        width: 25,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  LimitedBox(
                    maxHeight: 250,
                    child: playerlist,
                  ),
                  addPlayerButton,

                  //),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'swipe to remove player',
                    style: TextStyle(
                      color: Constants.colors[Constants.colorindex],
                      fontSize: Constants.miniFontSize,
                      fontFamily: "atarian",
                    ),
                  ),
                  SizedBox(
                    height: 60.0,
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: createButton,
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        ));
  }
}
