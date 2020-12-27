import 'package:blackbox/Models/OfflineGroupData.dart';
import 'package:blackbox/Screens/PartyScreens/PassScreen.dart';
import 'package:blackbox/Screens/popups/noMembersScelectedPopup.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import '../../Constants.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import '../../Database/FirebaseStream.dart';

class PartyQuestionScreen extends StatefulWidget {
  final OfflineGroupData offlineGroupData;

  @override
  PartyQuestionScreen(this.offlineGroupData) {}

  _PartyQuestionScreenState createState() =>
      _PartyQuestionScreenState(offlineGroupData);
}

class _PartyQuestionScreenState extends State<PartyQuestionScreen>
    with WidgetsBindingObserver {
  Color color;
  String selectedPlayer;
  OfflineGroupData offlineGroupData;

  FirebaseStream stream;
  TextEditingController questionController = TextEditingController();

  _PartyQuestionScreenState(OfflineGroupData offlineGroupData) {
    this.offlineGroupData = offlineGroupData;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent) {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final List<String> players = offlineGroupData.getPlayers();

    final membersList = GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      childAspectRatio: (3 / 1),
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      children:
          players.map((playerName) => buildUserVoteCard(playerName)).toList(),
    );

    final voteButton = Padding(
      padding: const EdgeInsets.only(left: 35, right: 35),
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(28.0),
        color: Constants.colors[Constants.colorindex],
        child: MaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28.0),
          ),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            if (selectedPlayer != null) {
              FirebaseAnalytics().logEvent(name: 'game_action', parameters: {
                'type': 'PartyVoteCast',
              });

              FirebaseAnalytics()
                  .logEvent(name: 'PartyVoteOnUser', parameters: null);
              offlineGroupData.vote(selectedPlayer);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        PassScreen(offlineGroupData),
                  ));
            } else {
              NoMemberSelectedPopup.noMemberSelectedPopup(context);
            }
          },
          child: Text("Vote",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: Constants.actionbuttonFontSize)
                  .copyWith(
                      color: Constants.iBlack, fontWeight: FontWeight.bold)),
        ),
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "atarian",
        scaffoldBackgroundColor: Constants.iBlack,
      ),
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Constants.iBlack,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [],
          ),
        ),
        body: Builder(
            // Create an inner BuildContext so that the onPressed methods
            // can refer to the Scaffold with Scaffold.of().
            builder: (BuildContext context) {
          return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  stops: [0.1, 0.9],
                  colors: [
                    Constants.gradient1,
                    Constants.gradient2,
                  ],
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 3.0),
              child: ListView(
                children: [
                  //submit own question button
                  Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 1.0, vertical: 1.0),
                    color: Colors.transparent,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 10),
                          Text(
                            'Question',
                            style: TextStyle(
                                color: Constants.colors[Constants.colorindex],
                                fontSize: Constants.subtitleFontSize,
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(height: 15),
                          Card(
                            elevation: 5.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            color: Constants.iDarkGrey,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 20.0),
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    offlineGroupData
                                        .getCurrentQuestion()
                                        .getQuestion(),
                                    style: TextStyle(
                                        color: Constants.iWhite,
                                        fontSize: Constants.normalFontSize,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        width: 150.0,
                                        child: Text(
                                          '- ' +
                                              offlineGroupData
                                                  .getCurrentQuestion()
                                                  .getCategory() +
                                              ' -',
                                          style: TextStyle(
                                              color: Constants.iWhite,
                                              fontSize: Constants.smallFontSize,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Select a friend',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Constants.colors[Constants.colorindex],
                        fontSize: Constants.normalFontSize,
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  membersList,
                  SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    height: 75,
                  ),
                ],
              ));
        }),
        floatingActionButton: voteButton,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Widget buildUserVoteCard(String playerName) {
    return Container(
        child: Card(
      elevation: 5.0,
      color:
          playerName == selectedPlayer ? Constants.iLight : Constants.iDarkGrey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.0),
        splashColor: Constants.colors[Constants.colorindex],
        onTap: () {
          setState(() {
            color = Constants.colors[Constants.colorindex];
            selectedPlayer = playerName;
          });
        },
        child: Center(
            child: Padding(
          padding:
              const EdgeInsets.only(top: 1.0, bottom: 1, left: 7, right: 7),
          child: Text(
            playerName,
            style: TextStyle(
                color: playerName == selectedPlayer
                    ? Constants.iDarkGrey
                    : Constants.iWhite,
                fontSize: Constants.smallFontSize,
                fontWeight: FontWeight.bold),
          ),
        )),
      ),
    ));
  }
}
