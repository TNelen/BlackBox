// @dart=2.9

import 'package:blackbox/Models/OfflineGroupData.dart';
import 'package:blackbox/Screens/PassScreen.dart';
import 'package:blackbox/Screens/animation/SlidePageRoute.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

    final membersList = AnimationLimiter(
      child: GridView.count(
        childAspectRatio: 2.75,
        crossAxisCount: 2,
        shrinkWrap: true,
        clipBehavior: Clip.antiAlias,
        children: List.generate(
          players.length,
          (int index) {
            return AnimationConfiguration.staggeredGrid(
              position: index,
              duration: const Duration(milliseconds: 600),
              columnCount: 2,
              child: ScaleAnimation(
                child: FadeInAnimation(
                  child: buildUserVoteCard(players[index], index),
                ),
              ),
            );
          },
        ),
      ),
    );

    final voteButton = Card(
      elevation: 5.0,
      color: Constants.iBlue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0),
        splashColor: Constants.iBlue,
        onTap: () {
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
        },
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          height: 50,
          child: Padding(
            padding:
                const EdgeInsets.only(top: 3, left: 3.0, right: 3, bottom: 3),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Vote".i18n,
                    style: TextStyle(
                        fontFamily: "roboto",
                        fontSize: Constants.smallFontSize,
                        color: Constants.iWhite,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  FaIcon(
                    FontAwesomeIcons.chevronRight,
                    size: 18,
                    color: Constants.iWhite,
                  )
                ]),
          ),
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
                color: Constants.black.withOpacity(0.7),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 50,
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 30, right: 30, top: 20, bottom: 30),
                        child: DelayedDisplay(
                          delay: Duration(milliseconds: 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                offlineGroupData
                                    .getCurrentQuestion()
                                    .getQuestion(),
                                style: TextStyle(
                                    color: Constants.iWhite,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w300),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    width: 220.0,
                                    child: Text(
                                      '- ' +
                                          offlineGroupData
                                              .getCurrentQuestion()
                                              .getCategory() +
                                          ' -',
                                      style: TextStyle(
                                          color: Constants.iLight,
                                          fontSize: Constants.smallFontSize,
                                          fontWeight: FontWeight.w500),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40.0),
                              topRight: Radius.circular(40.0),
                              bottomLeft: Radius.zero,
                              bottomRight: Radius.zero,
                            ),
                          ),
                          color: Constants.iDarkGrey,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 20.0,
                              ),
                              Text(
                                'Select a friend'.i18n,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Constants.iLight,
                                    fontWeight: FontWeight.w300),
                              ),
                              Container(
                                  padding: EdgeInsets.only(left: 30, right: 30),
                                  child: membersList),
                              SizedBox(
                                height: 60,
                              ),
                            ],
                          )),
                    ),
                  ],
                ));
          }),
          floatingActionButton:
              selectedPlayer != null ? voteButton : SizedBox(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        ),
      ),
    );
  }

  Widget buildUserVoteCard(String playerName, int index) {
    return Container(
        child: Card(
      elevation: 0.0,
      color: playerName == selectedPlayer
          ? Constants.categoryColors[index % 7]
          : Constants.categoryColors[index % 7].withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15.0),
        splashColor: Constants.iBlue,
        onTap: () {
          setState(() {
            color = Constants.iBlue;
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
                  : Constants.iLight,
              fontSize: Constants.smallFontSize,
              fontWeight: playerName == selectedPlayer
                  ? FontWeight.w600
                  : FontWeight.w400,
            ),
          ),
        )),
      ),
    ));
  }
}
