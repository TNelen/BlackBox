 import 'dart:math';

import 'package:blackbox/DataContainers/GroupData.dart';
import 'package:blackbox/Screens/popups/GroupCodePopup.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import '../GameScreen.dart';
import '../../Interfaces/Database.dart';
import '../popups/Popup.dart';
import '../../Constants.dart';
import 'package:blackbox/Database/QuestionListGetter.dart';


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
  _SetPlayersScreenState createState() => new _SetPlayersScreenState(_database, selectedCategory, canVoteBlank);
}

class _SetPlayersScreenState extends State<SetPlayersScreen> {
  Database _database;
  List<String> selectedCategory;
  List<String> players = ["timo", "jarne", "kaat", "Dieter"];
  bool canVoteBlank;
  TextEditingController codeController = new TextEditingController();

  _SetPlayersScreenState(Database db, List<String> selectedCategory, bool canVoteBlank) {
    this._database = db;
    this.selectedCategory = selectedCategory;
    this.canVoteBlank = canVoteBlank;

    FirebaseAnalytics().logEvent(name: 'open_screen', parameters: {'screen_name': 'setPlayersScreen'});
  }

    final QuestionListGetter questionListGetter = QuestionListGetter.instance;




  @override
  Widget build(BuildContext context) {

   final playerlist = ListView.separated(
     shrinkWrap: true,
  separatorBuilder: (context, index) => Divider(
        color: Constants.iWhite,
      ),
  itemCount: players.length  ,
  itemBuilder: (context, index) =>  Dismissible(
    background: Container(),
      secondaryBackground: Container(
            alignment: AlignmentDirectional.centerEnd,
            child: Padding(
              padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
              child: Icon(Icons.delete,
                  color: Colors.red,
                  
              ),),),
      key: Key(players[index]),
      child:Center(child: Text(
                      players[index],
                      style: new TextStyle(
                        color: Constants.iWhite,
                        fontSize: Constants.normalFontSize,
                        fontWeight: FontWeight.w300,
                        fontFamily: "atarian",
                      ),
                    ),
    ),
    onDismissed: (direction) {
      // Show a snackbar. This snackbar could also contain "Undo" actions.
    Scaffold
        .of(context)
        .showSnackBar(SnackBar(content: Text("removed player")));
    // Remove the item from the data source.
    setState(() {
      players.removeAt(index);
    });
    }
  )
    
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
                Map<String, String> members = new Map<String, String>();
                members[Constants.getUserID()] = Constants.getUsername();
                String _groupName = "default";
                if (_groupName.length != 0 && selectedCategory.length != 0) {
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

                    GroupData groupdata = new GroupData(_groupName, description, canVoteBlank, false, code, Constants.getUserID(), members, questionIDs);
                    await groupdata.setNextQuestion(await _database.getNextQuestion(groupdata), Constants.getUserData(), doDatabaseUpdate: false);
                    await _database.updateGroup(groupdata);

// GOTO THE NEXT SCREEN HERE

                  });
                } else {
                  Popup.makePopup(context, "Woops!","There should be at least one player!");
                }
              },
              child: Text("Start", textAlign: TextAlign.center, style: TextStyle(fontSize: Constants.actionbuttonFontSize).copyWith(color: Constants.iDarkGrey, fontWeight: FontWeight.bold)),
            ),
          ),
        ));

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BlackBox',
        theme: new ThemeData(scaffoldBackgroundColor: Constants.iBlack),
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
              child: Padding(
                padding: const EdgeInsets.only(top: 36.0, bottom: 36, left: 63, right: 63),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'who\'s playing?',
                      style: new TextStyle(
                        color: Constants.iWhite,
                        fontSize: Constants.titleFontSize,
                        fontWeight: FontWeight.w300,
                        fontFamily: "atarian",
                      ),
                    ),
                    SizedBox(height: 15,),
                    
                    Text(
                      'Players',
                      style: new TextStyle(
                        color: Constants.colors[Constants.colorindex],
                        fontSize: Constants.normalFontSize,
                        fontFamily: "atarian",
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    playerlist,
                    Expanded(
                      child: SizedBox(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}


 