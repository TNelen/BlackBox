import 'package:blackbox/Assets/questions.dart';
import 'package:blackbox/models/OfflineGroupData.dart';
import 'package:blackbox/Screens/PartyScreens/PartyQuestionScreen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import '../popups/Popup.dart';
import '../../Constants.dart';
import 'package:blackbox/Database/QuestionListGetter.dart';

class SetPlayersScreen extends StatefulWidget {
  List<Category> selectedCategory = [];
  bool canVoteBlank;

  SetPlayersScreen(List<Category> selectedCategory, bool canVoteBlank) {
    this.selectedCategory = selectedCategory;
    this.canVoteBlank = canVoteBlank;
  }

  @override
  _SetPlayersScreenState createState() =>
      _SetPlayersScreenState(selectedCategory, canVoteBlank);
}

class _SetPlayersScreenState extends State<SetPlayersScreen> {
  List<Category> selectedCategory;
  List<String> players = [Constants.getUsername().split(" ")[0]];
  bool canVoteBlank;
  QuestionList questionList;
  TextEditingController codeController = TextEditingController();

  _SetPlayersScreenState(List<Category> selectedCategory, bool canVoteBlank) {
    this.selectedCategory = selectedCategory;
    this.canVoteBlank = canVoteBlank;

    FirebaseAnalytics().logEvent(
        name: 'open_screen', parameters: {'screen_name': 'setPlayersScreen'});
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
                      style: TextStyle(
                          color: Constants.iWhite,
                          fontSize: Constants.miniFontSize,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                    duration: Duration(seconds: 3),
                    backgroundColor: Constants.iDarkGrey,
                    action: SnackBarAction(
                      label: 'Undo',
                      textColor: Constants.colors[Constants
                          .colorindex], // or some operation you would like
                      onPressed: () {
                        setState(
                            () => players.insert(removedIndex, removedPlayer));
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
        style: TextStyle(
            fontFamily: "atarian",
            fontSize: Constants.smallFontSize,
            color: Constants.iWhite),
        decoration: InputDecoration(
            focusColor: Constants.colors[Constants.colorindex],
            hoverColor: Constants.colors[Constants.colorindex],
            contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
            fillColor: Constants.iBlack,
            filled: true,
            hintText: "Start typing here...",
            hintStyle: TextStyle(
                fontFamily: "atarian",
                fontSize: Constants.smallFontSize,
                color: Constants.iGrey),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(16.0))),
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
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16.0))),
                title: Text(
                  'Player Name',
                  style: TextStyle(
                      fontFamily: "atarian",
                      color: Constants.colors[Constants.colorindex],
                      fontSize: Constants.subtitleFontSize),
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
                      style: TextStyle(
                          fontFamily: "atarian",
                          color: Constants.colors[Constants.colorindex],
                          fontSize: Constants.actionbuttonFontSize,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),

                  FlatButton(
                    child: Text(
                      "Add",
                      style: TextStyle(
                          fontFamily: "atarian",
                          color: Constants.colors[Constants.colorindex],
                          fontSize: Constants.actionbuttonFontSize,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      String name = playerNameController.text;
                      //print('-' + question+ '-');
                      if (name.length < 2) {
                        Popup.makePopup(
                            context, 'Whoops!', 'Player name is too short');
                      } else if (players.contains(
                          name[0].toUpperCase() + name.substring(1))) {
                        Popup.makePopup(
                            context, 'Whoops!', 'This player already exists');
                      } else {
                        FirebaseAnalytics().logEvent(
                            name: 'action_performed',
                            parameters: {'action_name': 'addPlayer'});
                        Navigator.pop(context);

                        setState(() => players
                            .add(name[0].toUpperCase() + name.substring(1)));
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
              if (players.length != 0 && selectedCategory.length != 0) {
                canVoteBlank ? players.add("Blank") : null;
                questionList = QuestionList(selectedCategory);

                Map<String, dynamic> map = {
                  'code': 'New group',
                  'type': 'PartyCreated',
                  'can_vote_blank': canVoteBlank,
                };

                // General game action log
                FirebaseAnalytics()
                    .logEvent(name: 'game_action', parameters: map);

                // Only logged here
                FirebaseAnalytics()
                    .logEvent(name: 'party_created', parameters: map);

                OfflineGroupData offlineGroupData =
                    OfflineGroupData(players, questionList, canVoteBlank);

                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          PartyQuestionScreen(offlineGroupData),
                    ));
              } else {
                Popup.makePopup(
                    context, "Woops!", "There should be at least one player!");
              }
            },
            child: Text("Start",
                textAlign: TextAlign.center,
                style: TextStyle(
                        fontFamily: "atarian",
                        fontSize: Constants.actionbuttonFontSize)
                    .copyWith(
                        color: Constants.iDarkGrey,
                        fontWeight: FontWeight.bold)),
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
                padding: const EdgeInsets.only(
                    top: 36.0, bottom: 36, left: 63, right: 63),
                children: <Widget>[
                  Text(
                    'who\'s playing?',
                    style: TextStyle(
                      color: Constants.iWhite,
                      fontSize: Constants.titleFontSize,
                      fontWeight: FontWeight.w300,
                      fontFamily: "atarian",
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
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        ));
  }
}
