import 'package:blackbox/DataContainers/GroupData.dart';
import 'package:blackbox/DataContainers/UserData.dart';
import 'package:blackbox/Screens/PartyScreens/PartyResultsScreen.dart';
import 'package:blackbox/Screens/popups/Popup.dart';
import 'package:blackbox/Screens/widgets/iconCard.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import '../../Constants.dart';
import '../../Interfaces/Database.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import 'PartyQuestionScreen.dart';

class PassScreen extends StatefulWidget {
  Database _database;
  GroupData groupData;
  String code;
  Map<UserData, int> playerVotes;
  int numberOfVotes;

  PassScreen(Database db, GroupData groupData, String code, Map<UserData, int> playerVotes, int numberOfVotes) {
    this._database = db;
    this.groupData = groupData;
    this.code = code;
    this.playerVotes = playerVotes;
    this.numberOfVotes = numberOfVotes;
  }

  @override
  _PassScreenState createState() => new _PassScreenState(_database, groupData, code, playerVotes, numberOfVotes);
}

class _PassScreenState extends State<PassScreen> {
  Database _database;
  GroupData groupData;
  String code;
  Map<UserData, int> playerVotes;
  final int numberOfVotes;

  _PassScreenState(this._database, this.groupData, this.code, this.playerVotes, this.numberOfVotes) {
    FirebaseAnalytics().logEvent(name: 'open_screen', parameters: {'screen_name': 'RulesScreen'});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BlackBox',
        theme: new ThemeData(fontFamily: "atarian", scaffoldBackgroundColor: Constants.iBlack),
        home: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Constants.iBlack,
            title: Row(mainAxisAlignment: MainAxisAlignment.start, children: []),
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
            child: ListView(
              padding: const EdgeInsets.only(top: 20.0, bottom: 20, left: 50, right: 50),
              children: [
                SizedBox(height: 10.0),
                Row(mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.,
                    children: [
                      Text(
                        'pass the phone',
                        textAlign: TextAlign.center,
                        style: new TextStyle(color: Constants.colors[Constants.colorindex], fontSize: Constants.titleFontSize, fontWeight: FontWeight.w300),
                      ),
                      JumpingDotsProgressIndicator(
                        numberOfDots: 3,
                        fontSize: Constants.titleFontSize,
                        color: Constants.colors[Constants.colorindex],
                      ),
                    ]),
                SizedBox(height: 20.0),
                Text(
                  numberOfVotes > 1 ? numberOfVotes.toString() + ' players have voted' : numberOfVotes.toString() + ' player has voted',
                  textAlign: TextAlign.center,
                  style: new TextStyle(color: Constants.iWhite, fontSize: Constants.normalFontSize, fontWeight: FontWeight.w300),
                ),
                SizedBox(height: 40.0),
                Hero(
                  tag: "newVote",
                  child: Card(
                    elevation: 5.0,
                    color: Constants.iDarkGrey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => PartyQuestionScreen(_database, groupData, code, playerVotes, numberOfVotes),
                            ));
                      },
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5, left: 10.0, right: 10, bottom: 5),
                          child: Stack(children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 35),
                                Text(
                                  "  Vote!",
                                  style: new TextStyle(color: Constants.iWhite, fontSize: Constants.normalFontSize, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "  New vote for this round",
                                  textAlign: TextAlign.start,
                                  style: new TextStyle(color: Constants.iLight, fontSize: Constants.smallFontSize, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                            Positioned(
                              right: 0.0,
                              top: 0.0,
                              child: IconCard(
                                Icons.edit,
                                Constants.iGrey.withOpacity(0.1),
                                Constants.colors[Constants.colorindex],
                                35,
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Card(
                  elevation: 5.0,
                  color: Constants.iDarkGrey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: InkWell(
                    onTap: () {
                      Popup.submitQuestionIngamePopup(context, _database, groupData);
                    },
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5, left: 10.0, right: 10, bottom: 5),
                        child: Stack(children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 35),
                              Text(
                                "  Add question",
                                style: new TextStyle(color: Constants.iWhite, fontSize: Constants.normalFontSize, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "  Want to ask a question? Submit it here!",
                                textAlign: TextAlign.start,
                                style: new TextStyle(color: Constants.iLight, fontSize: Constants.smallFontSize, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                          Positioned(
                            right: 0.0,
                            top: 0.0,
                            child: IconCard(
                              Icons.library_add,
                              Constants.iGrey.withOpacity(0.1),
                              Constants.colors[Constants.colorindex],
                              35,
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: ConfirmationSlider(
            backgroundColor: Constants.iDarkGrey,
            foregroundColor: Constants.colors[Constants.colorindex],
            backgroundShape: BorderRadius.circular(16.0),
            foregroundShape: BorderRadius.circular(16.0),
            text: "Swipe to go to results",
            textStyle: TextStyle(color: Constants.iWhite, fontSize: Constants.smallFontSize, fontWeight: FontWeight.bold),
            icon: Icons.chevron_right,
            onConfirmation: () {
              String currentQuestion = groupData.getQuestionID();
              String currentQuestionString = groupData.getNextQuestionString();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => PartyResultScreen(_database, groupData, code, currentQuestion, currentQuestionString, playerVotes),
                  ));
            },
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        ));
  }
}
