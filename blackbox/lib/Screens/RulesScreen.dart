import 'package:flutter/material.dart';
import '../Interfaces/Database.dart';
import 'Popup.dart';
import '../Constants.dart';

class RuleScreen extends StatefulWidget {
  Database _database;

  RuleScreen(Database db) {
    this._database = db;
  }

  @override
  _RuleScreenState createState() => new _RuleScreenState(_database);
}

class _RuleScreenState extends State<RuleScreen> {
  Database _database;

  _RuleScreenState(Database db) {
    this._database = db;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BlackBox',
        theme: new ThemeData(
            accentColor: Constants.colors[Constants.colorindex],
            disabledColor: Constants.colors[Constants.colorindex],
            fontFamily: "atarian",
            scaffoldBackgroundColor: Constants.iBlack),
        home: Scaffold(
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
                padding: EdgeInsets.only(left: 22, right: 22),
                child: Center(
                  child: Container(
                    color: Constants.iBlack,
                    child: ListView(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(20.0),
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Hero(
                                tag: 'topicon1',
                                child: Icon(
                                  Icons.help,
                                  size: 50,
                                  color: Constants.colors[Constants.colorindex],
                                )),
                            SizedBox(width: 20.0),
                            Text(
                              'Game rules',
                              textAlign: TextAlign.center,
                              style: new TextStyle(
                                  color: Constants.iWhite,
                                  fontSize: 50.0,
                                  fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          height: 1.5,
                          color: Constants.iWhite,
                        ),
                        SizedBox(height: 20.0),
                        Center(
                            child: Column(
                          children: [
                            SizedBox(height: 20),
                            ExpansionTile(
                              title: Text(
                                "New Game",
                                style: new TextStyle(
                                  color: Constants.colors[Constants.colorindex],
                                  fontSize: 30.0,
                                ),
                              ),
                              backgroundColor: Constants.iBlack,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      'Create a new game and invite your friends by sharing the group code.' +
                                          '\n' +
                                          'Or join a game by entering the group code.',
                                      style: new TextStyle(
                                        color: Constants.iWhite,
                                        fontSize: 25.0,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                  ],
                                )
                              ],
                            ),
                            ExpansionTile(
                              title: Text(
                                "Start Game",
                                style: new TextStyle(
                                  color: Constants.colors[Constants.colorindex],
                                  fontSize: 30.0,
                                ),
                              ),
                              backgroundColor: Constants.iBlack,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      'When you join or create a game you enter the game lobby.' +
                                          '\n' +
                                          'Press the ready button to ready up.' +
                                          '\n' +
                                          'When all players are ready, the ready button on the bottom becomes the start button, press start to begin the game.' +
                                          '\n' +
                                          'Each player name has an indicator, indicating whether the layer is ready or not.',
                                      style: new TextStyle(
                                        color: Constants.iWhite,
                                        fontSize: 25.0,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                  ],
                                )
                              ],
                            ),
                            ExpansionTile(
                              title: Text(
                                "Voting",
                                style: new TextStyle(
                                  color: Constants.colors[Constants.colorindex],
                                  fontSize: 30.0,
                                ),
                              ),
                              backgroundColor: Constants.iBlack,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      'Vote on a group member.' +
                                          '\n' +
                                          'Once a vote is submitted, it can not be changed.',
                                      style: new TextStyle(
                                        color: Constants.iWhite,
                                        fontSize: 25.0,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                  ],
                                )
                              ],
                            ),
                            ExpansionTile(
                              title: Text(
                                "Collecting results",
                                style: new TextStyle(
                                  color: Constants.colors[Constants.colorindex],
                                  fontSize: 30.0,
                                ),
                              ),
                              backgroundColor: Constants.iBlack,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      'After you have voted you will enter a collecting results waiting screen.' +
                                          '\n' +
                                          'It shows the number of people that still have to vote.' +
                                          '\n' +
                                          'The group creator wil see a countdown timer. It shows the time there is left for the members to vote.' +
                                          '\n' +
                                          'When this time is elapsed the players go to the results screen, no matter how many people still have to vote.' +
                                          '\n' +
                                          '',
                                      style: new TextStyle(
                                        color: Constants.iWhite,
                                        fontSize: 25.0,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                  ],
                                )
                              ],
                            ),
                            ExpansionTile(
                              title: Text(
                                "Questions",
                                style: new TextStyle(
                                  color: Constants.colors[Constants.colorindex],
                                  fontSize: 30.0,
                                ),
                              ),
                              backgroundColor: Constants.iBlack,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      'Questions are generated in a random order.' +
                                          '\n' +
                                          'You can submit own question ideas ingame. These will be iserted in the queue of questions.' +
                                          '\n' +
                                          'All players have the ability to rate teh questions, giving us feedback about the questions helps us inproving the game.',
                                      style: new TextStyle(
                                        color: Constants.iWhite,
                                        fontSize: 25.0,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                  ],
                                )
                              ],
                            ),
                            ExpansionTile(
                              title: Text(
                                "Leave",
                                style: new TextStyle(
                                  color: Constants.colors[Constants.colorindex],
                                  fontSize: 30.0,
                                ),
                              ),
                              backgroundColor: Constants.iBlack,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      'Leave a running game by clicking on the leave in the top right corner.' +
                                          '\n' +
                                          'Please do not close the app before leaving an active game.',
                                      style: new TextStyle(
                                        color: Constants.iWhite,
                                        fontSize: 25.0,
                                      ),
                                    ),
                                    Text(
                                      'If there are no more players in a group, the group is deleted',
                                      style: new TextStyle(
                                        color: Constants.iWhite,
                                        fontSize: 25.0,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                  ],
                                )
                              ],
                            ),
                            ExpansionTile(
                              title: Text(
                                "End game",
                                style: new TextStyle(
                                  color: Constants.colors[Constants.colorindex],
                                  fontSize: 30.0,
                                ),
                              ),
                              backgroundColor: Constants.iBlack,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      'When all questions are played the game ends and a overview of all questions and results is shown.' +
                                          '\n' +
                                          'The group leader has the ability to end the game prematurely, after the next questions the results are shown.',
                                      style: new TextStyle(
                                        color: Constants.iWhite,
                                        fontSize: 25.0,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                  ],
                                )
                              ],
                            ),
                          ],
                        )),
                        SizedBox(height: 15.0),
                      ],
                    ),
                  ),
                ))));
  }
}
