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


Map<UserData, int> convertUserListToUserDataMap(List<String> users, bool canVoteBlank){
      Map<UserData, int> userMap = new  Map<UserData, int>();
      int index = 0;
      while(index < users.length) {
        UserData tempUser = new UserData((index+1).toString(), users[index]);
        userMap.addAll({tempUser : 0});
        index++;
      }

      if(canVoteBlank){
        UserData tempUser = new UserData("0", "Blank");
        userMap.addAll({tempUser : 0});
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
  _SetPlayersScreenState createState() => new _SetPlayersScreenState(_database, selectedCategory, canVoteBlank);
}

class _SetPlayersScreenState extends State<SetPlayersScreen> {
  Database _database;
  List<String> selectedCategory;
  List<String> players = [Constants.getUsername().split(" ")[0]];
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

   String removedPlayer = "";
   int removedIndex = null;

   final playerlist = ListView.separated(
     shrinkWrap: true,
  separatorBuilder: (context, index) => Divider(
    indent: 40,
    endIndent: 40,
        color: Constants.iLight,
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
     Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(
        'Player deleted.',
        style: new TextStyle(color: Constants.iWhite, fontSize: Constants.miniFontSize, fontWeight: FontWeight.bold),
        textAlign: TextAlign.left,
      ),
      duration: Duration(seconds: 3),
      backgroundColor: Constants.iDarkGrey,
      action: SnackBarAction(
        label: 'Undo', textColor: Constants.colors[Constants.colorindex], // or some operation you would like
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
    }
  )
    
);

    TextEditingController playerNameController = new TextEditingController();

    final namefield = new Theme(
          data: new ThemeData(
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
    ),);

    final addButton = IconButton(

        onPressed: () {
           showDialog(
              context: context,
              builder: (BuildContext context) {
          // return object of type Dialog
              return AlertDialog(
                backgroundColor: Constants.iBlack,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                title: new Text(
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
                  new FlatButton(
                    child: new Text(
                      "Cancel",
                      style: TextStyle(fontFamily: "atarian", color: Constants.colors[Constants.colorindex], fontSize: Constants.actionbuttonFontSize, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),

                  new FlatButton(
                    child: new Text(
                      "Add",
                      style: TextStyle(fontFamily: "atarian", color: Constants.colors[Constants.colorindex], fontSize: Constants.actionbuttonFontSize, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      String name = playerNameController.text;
                      //print('-' + question+ '-');
                      if (name.length <= 2) {
                        Popup.makePopup(context, 'Whoops!', 'Player nqme is too short');
                      } else{
                          FirebaseAnalytics().logEvent(name: 'action_performed', parameters: {'action_name': 'addPlayer'});
                                                Navigator.pop(context);

                        setState(() => players.add(name));

                      }
                    },
                  ),
                ],
                );
                },
              );
            },
        icon: Icon(Icons.add, color: Constants.colors[Constants.colorindex]),
        tooltip: "Add player",
      );

    



   final createButton = Hero(
        tag: 'tobutton',
        child:  Padding(
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

                    GroupData groupdata = new GroupData(_groupName, description, canVoteBlank, false, code, Constants.getUserID(), members, questionIDs);
                    await groupdata.setNextQuestion(await _database.getNextQuestion(groupdata), Constants.getUserData(), doDatabaseUpdate: false);
                    await _database.updateGroup(groupdata);

                    print(groupdata.getGroupCode());
                    
                    
                    
                    Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => PartyQuestionScreen(_database, groupdata, code, userMap ),
                          ));
                    

// GOTO THE NEXT SCREEN HERE

                  });
                } else {
                  Popup.makePopup(context, "Woops!","There should be at least one player!");
                }
              },
              child: Text("Start", textAlign: TextAlign.center, style: TextStyle(fontSize: Constants.actionbuttonFontSize).copyWith(color: Constants.iDarkGrey, fontWeight: FontWeight.bold)),
            ),
          ),),
        );

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
                child: ListView(
              
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
                    Row(
                                    mainAxisAlignment: MainAxisAlignment.center,

                      children: [
          Icon(Icons.people_outline, color: Constants.colors[Constants.colorindex], size: 30,),
                    SizedBox(width: 15,),   
                    Text(
                      'Players',
                      style: new TextStyle(
                        color: Constants.colors[Constants.colorindex],
                        fontSize: Constants.normalFontSize,
                        fontFamily: "atarian",
                      ),
                    ),
                    SizedBox(width:5 ,),
                    Text(
                      '('+  players.length.toString()+')',
                      style: new TextStyle(
                        color: Constants.colors[Constants.colorindex],
                        fontSize: Constants.smallFontSize,
                        fontFamily: "atarian",
                      ),
                    ),
                    SizedBox(width: 25,),
                    addButton
                    ],),
                    SizedBox(
                      height: 20.0,
                    ),
                     playerlist,
                    //),
                    SizedBox(height: 20,),
                    Text(
                      'swipe to remove player',
                      style: new TextStyle(
                        color: Constants.colors[Constants.colorindex],
                        fontSize: Constants.miniFontSize,
                        fontFamily: "atarian",
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                  
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: createButton,
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat ,
        ));
  }
}


 