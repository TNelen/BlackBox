import 'dart:math';

import 'package:blackbox/DataContainers/QuestionCategory.dart';
import 'package:blackbox/Database/QuestionListGetter.dart';
import 'package:blackbox/Screens/custom_widgets/toggle_button_card.dart';
import 'package:flutter/material.dart';
import '../Constants.dart';
import '../DataContainers/GroupData.dart';
import '../DataContainers/Question.dart';
import '../Interfaces/Database.dart';
import 'GameScreen.dart';
import 'Popup.dart';
import 'package:share/share.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../Database/FirebaseGetters.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class CreateGameScreen extends StatefulWidget {
  Database _database;

  CreateGameScreen(Database db) {
    this._database = db;
  }

  @override
  _CreateGameScreenState createState() => new _CreateGameScreenState(_database);
}

class _CreateGameScreenState extends State<CreateGameScreen> {
  Database _database;

  _CreateGameScreenState(Database db) {
    this._database = db;

    FirebaseAnalytics().logEvent(name: 'open_screen', parameters: {'screen_name': 'CreateGameScreen'});

  }

  final QuestionListGetter questionListGetter = QuestionListGetter.instance;
  List<String> selectedCategory = [];
  String _groupName;
  bool _canVoteBlank = false;
  bool _canVoteOnSelf = true;
  Color color = Constants.iDarkGrey;

  bool _isNumeric(String str) {
    if (str == null) {
      return false;
    }
    return double.tryParse(str) != null;
  }

  void _showDialog(String code) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: Constants.iDarkGrey,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0))),
          title: new Text(
            "Group Code",
            style: TextStyle(
                fontFamily: "atarian",
                color: Constants.iWhite,
                fontSize: 40,
                fontWeight: FontWeight.bold),
          ),
          content: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              RichText(
                text: TextSpan(
                    // set the default style for the children TextSpans
                    style: TextStyle(
                        fontFamily: "atarian",
                        color: Constants.iBlack,
                        fontSize: 25),
                    children: [
                      TextSpan(
                          text: code[0],
                          style: !_isNumeric(code[0])
                              ? TextStyle(color: Constants.iWhite)
                              : TextStyle(
                                  color:
                                      Constants.colors[Constants.colorindex])),
                      TextSpan(
                          text: code[1],
                          style: !_isNumeric(code[1])
                              ? TextStyle(color: Constants.iWhite)
                              : TextStyle(
                                  color:
                                      Constants.colors[Constants.colorindex])),
                      TextSpan(
                          text: code[2],
                          style: !_isNumeric(code[2])
                              ? TextStyle(color: Constants.iWhite)
                              : TextStyle(
                                  color:
                                      Constants.colors[Constants.colorindex])),
                      TextSpan(
                          text: code[3],
                          style: !_isNumeric(code[3])
                              ? TextStyle(color: Constants.iWhite)
                              : TextStyle(
                                  color:
                                      Constants.colors[Constants.colorindex])),
                      TextSpan(
                          text: code[4],
                          style: !_isNumeric(code[4])
                              ? TextStyle(color: Constants.iWhite)
                              : TextStyle(
                                  color:
                                      Constants.colors[Constants.colorindex])),
                    ]),
              ),
              IconButton(
                  icon: Icon(
                    Icons.share,
                    color: Constants.iWhite,
                  ),
                  onPressed: () {
                    final RenderBox box = context.findRenderObject();
                    Share.share(code,
                        sharePositionOrigin:
                            box.localToGlobal(Offset.zero) & box.size);
                  }),
            ],
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Start",
                style: TextStyle(
                    fontFamily: "atarian",
                    color: Constants.colors[Constants.colorindex],
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            GameScreen(_database, code)));
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                _groupName = "default";
                if (_groupName.length != 0 && selectedCategory.length != 0) {
                  // Generate a unique ID and save the group
                  _database.generateUniqueGroupCode().then((code) async {
                    List<String> questionIDs = List<String>();
                    String description = "";

                    for (String groupCategory in selectedCategory) {
                      questionIDs.addAll(
                          questionListGetter.mappings[groupCategory] ?? []);
                      description += groupCategory + " ";
                    }

                    questionIDs.shuffle(Random.secure());

                    Map<String, dynamic> map = {   
                      'type' : 'GameCreated',
                      'can_vote_blank' : _canVoteBlank,
                      'can_vote_on_self' : _canVoteOnSelf,
                    };

                    List<String> allCategories = await QuestionListGetter.instance.getCategoryNames();
                    for (String category in allCategories)
                      map[category.replaceAll(' ', '_').replaceAll("'", '').replaceAll('+', 'P')] = selectedCategory.contains( category );

                    FirebaseAnalytics().logEvent(name: 'game_action', parameters: map);


                    GroupData groupdata = new GroupData(
                        _groupName,
                        description,
                        _canVoteBlank,
                        _canVoteOnSelf,
                        code,
                        Constants.getUserID(),
                        members,
                        questionIDs);
                    _database.updateGroup(groupdata);
                    _showDialog(code);
                  });
                } else {
                  Popup.makePopup(
                      context, "Woops!", "Please fill in all fields!");
                }
              },
              child: Text("Create",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30).copyWith(
                      color: Constants.iDarkGrey, fontWeight: FontWeight.bold)),
            ),
          ),
        ));

    final categoryField = FutureBuilder<List<QuestionCategory>>(
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.none &&
                projectSnap.hasData == null ||
            projectSnap.data == null) {
          //print('project snapshot data is: ${projectSnap.data}');
          return Container();
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: projectSnap.data.length,
          itemBuilder: (context, index) {
            int amount = projectSnap.data[index].amount;
            String description = projectSnap.data[index].description;
            String categoryname = projectSnap.data[index].name;

            return Card(
              color: selectedCategory.contains(categoryname)
                  ? Constants.iLight
                  : Constants.iDarkGrey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: InkResponse(
                splashColor: Constants.colors[Constants.colorindex],
                radius: 50,
                onTap: () {
                  setState(() {
                    color = Constants.colors[Constants.colorindex];
                    if (!selectedCategory.contains(categoryname)) {
                      selectedCategory.add(categoryname);
                    } else if (selectedCategory.contains(categoryname)) {
                      selectedCategory.remove(categoryname);
                    }
                  });
                },
                child: Container(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 5, left: 10.0, right: 10, bottom: 5),
                      child: Column(
                        children: [
                          Text(
                            categoryname,
                            style: new TextStyle(
                                color: selectedCategory.contains(categoryname)
                                    ? Constants.iDarkGrey
                                    : Constants.iWhite,
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Text(
                            description,
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                                color: selectedCategory.contains(categoryname)
                                    ? Constants.iBlack
                                    : Constants.iLight,
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Text(
                            amount.toString() + '  questions',
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                                color: selectedCategory.contains(categoryname)
                                    ? Constants.iBlack
                                    : Constants.iLight,
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 3),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
      future: questionListGetter.getCategories(),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        fontFamily: "atarian",
        scaffoldBackgroundColor: Constants.iBlack,
      ),
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
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
                      fontSize: 30,
                      color: Constants.colors[Constants.colorindex],
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
        body: Padding(
            padding: EdgeInsets.only(left: 22, right: 22, bottom: 0),
            child: Center(
              child: Container(
                color: Constants.iBlack,
                child: Padding(
                  padding: const EdgeInsets.only(left: 22, right: 22),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return ListView(
                        shrinkWrap: true,
                        children: <Widget>[
                          ListView(
                            shrinkWrap: true,
                            children: <Widget>[
                              AutoSizeText(
                                "Create new Game",
                                style: new TextStyle(
                                    color: Constants.iWhite,
                                    fontSize: 50.0,
                                    fontWeight: FontWeight.w300),
                                maxLines: 1,
                              ),
                              SizedBox(height: 30.0),
                              Text(
                                'Game settings',
                                style: new TextStyle(
                                    color:
                                        Constants.colors[Constants.colorindex],
                                    fontSize: 30.0),
                              ),
                              SizedBox(height: 20.0),
                              
                              ToggleButtonCard(
                                'Blank vote',
                                _canVoteBlank,
                                onToggle: (bool newValue) => _canVoteBlank = newValue,
                              ),

                              ToggleButtonCard(
                                'Vote on yourself',
                                _canVoteOnSelf,
                                onToggle: (bool newValue) => _canVoteOnSelf = newValue,
                              ),

                              SizedBox(height: 20.0),
                              Text(
                                'Choose a category',
                                style: new TextStyle(
                                    color:
                                        Constants.colors[Constants.colorindex],
                                    fontSize: 30.0),
                              ),
                              SizedBox(height: 20.0),
                              LimitedBox(
                                  maxHeight: constraints.maxHeight / 3,
                                  child: categoryField),
                              SizedBox(height: 20.0),
                            ],
                          ),
                          SizedBox(height: 15.0),
                        ],
                      );
                    },
                  ),
                ),
              ),
            )
          ),
        floatingActionButton: createButton,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
