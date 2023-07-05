import 'package:blackbox/Repositories/gameStateRepository.dart';
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

import '../main.dart';

class PartyVoteScreen extends StatefulWidget {
  const PartyVoteScreen({
    Key? key,
  }) : super(key: key);

  _PartyVoteScreenState createState() => _PartyVoteScreenState();
}

class _PartyVoteScreenState extends State<PartyVoteScreen> with WidgetsBindingObserver {
  late Color color;
  String selectedPlayer = "";

  TextEditingController questionController = TextEditingController();
  final GameStateRepository gameStateRepo = getIt.get<GameStateRepository>();

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

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    List<String> players = gameStateRepo.getPlayers();

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
          FirebaseAnalytics.instance.logEvent(name: 'game_action', parameters: {
            'type': 'PartyVoteCast',
          });
          FirebaseAnalytics.instance.logEvent(name: 'PartyVoteOnUser', parameters: null);
          if (selectedPlayer != "") gameStateRepo.vote(selectedPlayer!);
          Navigator.push(context, SlidePageRoute(fromPage: widget, toPage: PassScreen()));
        },
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          height: 50,
          child: Padding(
            padding: const EdgeInsets.only(top: 3, left: 3.0, right: 3, bottom: 3),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              Text(
                "Vote".i18n,
                style: TextStyle(fontFamily: "atarian", fontSize: Constants.smallFontSize, color: Constants.iWhite, fontWeight: FontWeight.w500),
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

    return Scaffold(
      backgroundColor: Constants.black.withOpacity(0.7),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.33,
            padding: EdgeInsets.only(left: 30, right: 30, top: 70, bottom: 30),
            child: DelayedDisplay(
              delay: Duration(milliseconds: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    gameStateRepo.getCurrentQuestion().getQuestion().i18n,
                    style: TextStyle(color: Constants.iWhite, fontSize: 25, fontWeight: FontWeight.w300),
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
                          '- ' + gameStateRepo.getCurrentQuestion().getCategory().i18n + ' -',
                          style: TextStyle(color: Constants.iLight, fontSize: Constants.smallFontSize, fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
              height: MediaQuery.of(context).size.height * 0.66,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                  bottomLeft: Radius.zero,
                  bottomRight: Radius.zero,
                ),
                color: Constants.iDarkGrey,
              ),
              child: ListView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 20),
                      child: Text(
                        'Select a friend'.i18n,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 25, color: Constants.iLight, fontWeight: FontWeight.w300),
                      )),
                  Container(height: MediaQuery.of(context).size.height * 0.6, padding: EdgeInsets.only(left: 30, right: 30, bottom: 70), child: membersList),
                ],
              )),
        ],
      ),
      floatingActionButton: selectedPlayer != null ? voteButton : SizedBox(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget buildUserVoteCard(String playerName, int index) {
    return Container(
        child: Card(
      elevation: 0.0,
      color: playerName == selectedPlayer ? Constants.categoryColors[index % 7] : Constants.categoryColors[index % 7].withOpacity(0.3),
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
          padding: const EdgeInsets.only(top: 1.0, bottom: 1, left: 7, right: 7),
          child: Text(
            playerName,
            style: TextStyle(
              color: playerName == selectedPlayer ? Constants.iDarkGrey : Constants.iLight,
              fontSize: Constants.smallFontSize,
              fontWeight: playerName == selectedPlayer ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        )),
      ),
    ));
  }
}
