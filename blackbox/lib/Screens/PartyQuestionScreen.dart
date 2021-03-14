import 'package:blackbox/Models/OfflineGroupData.dart';
import 'package:blackbox/Screens/PassScreen.dart';
import 'package:blackbox/Screens/animation/SlidePageRoute.dart';
import 'package:blackbox/Screens/popups/noMembersScelectedPopup.dart';
import 'package:blackbox/Util/Curves.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import '../Constants.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';

import 'package:blackbox/translations/translations.i18n.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
                  SlidePageRoute(
                      fromPage: widget, toPage: PassScreen(offlineGroupData)));
            } else {
              NoMemberSelectedPopup.noMemberSelectedPopup(context);
            }
          },
          child: Text("Vote".i18n,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: Constants.actionbuttonFontSize)
                  .copyWith(
                      color: Constants.iBlack, fontWeight: FontWeight.bold)),
        ),
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''), // English, no country code
        const Locale('nl', ''), // nl, no country code
      ],
      theme: ThemeData(
        fontFamily: "roboto",
        scaffoldBackgroundColor: Constants.iBlack,
      ),
      home: I18n(
        child: Scaffold(
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
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  CustomPaint(
                    painter: QuestionTopCurvePainter(),
                  ),
                  CustomPaint(
                    painter: BottomCurvePainter(),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            'Question'.i18n,
                            style: TextStyle(
                                color: Constants.iWhite,
                                fontSize: Constants.normalFontSize,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      )),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Text(
                              offlineGroupData
                                  .getCurrentQuestion()
                                  .getQuestion(),
                              style: TextStyle(
                                  color: Constants.iWhite,
                                  fontSize: Constants.normalFontSize,
                                  fontWeight: FontWeight.w300),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: 180.0,
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
                      Expanded(
                          child: Column(
                        children: [
                          Text(
                            'Select a friend'.i18n,
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
                        ],
                      )),
                      Expanded(child: voteButton)
                    ],
                  )
                ],
              ),
            );
          }),
        ),
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
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(24.0),
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
