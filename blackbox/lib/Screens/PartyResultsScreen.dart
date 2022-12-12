// @dart=2.9

import 'package:blackbox/Models/OfflineGroupData.dart';
import 'package:blackbox/Screens/PartyQuestionScreen.dart';
import 'package:blackbox/Screens/animation/SlidePageRoute.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Constants.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:blackbox/Screens/popups/rate_popup.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../main.dart';

class PartyResultScreen extends StatefulWidget {
  OfflineGroupData offlineGroupData;

  PartyResultScreen(OfflineGroupData offlineGroupData) {
    this.offlineGroupData = offlineGroupData;
  }

  @override
  PartyResultScreenState createState() => PartyResultScreenState(offlineGroupData);
}

class PartyResultScreenState extends State<PartyResultScreen> {
  OfflineGroupData offlineGroupData;

  PartyResultScreenState(OfflineGroupData offlineGroupData) {
    this.offlineGroupData = offlineGroupData;
  }

  bool showMoreCurrent;
  bool showMoreAll;

  final controller = PageController(
    initialPage: 0,
    keepPage: false,
    viewportFraction: 0.85,
  );

  void _moveToNext(bool doAnimate) {
    Navigator.push(
      context,
      doAnimate
          ? SlidePageRoute(fromPage: widget, toPage: PartyQuestionScreen(offlineGroupData))
          : PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) => PartyQuestionScreen(offlineGroupData),
              transitionDuration: Duration(seconds: 0),
            ),
    );
  }

  bool _showRatePop() {
    return offlineGroupData.questionsLeft() == 10;
  }

  @override
  void initState() {
    showMoreCurrent = false;
    showMoreAll = false;

    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  dispose() {
    controller.dispose();
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    List<String> currentWinners = offlineGroupData.getCurrentRanking();
    Map<String, int> currentVotes = offlineGroupData.getCurrentVotes();

    void toggleAlltime() {
      showMoreAll = !showMoreAll;
    }

    void toggleCurrent() {
      showMoreCurrent = !showMoreCurrent;
    }

    final results = Container(
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: ListView.separated(
          padding: EdgeInsets.only(left: 25, right: 25),
          separatorBuilder: (context, index) => Divider(
            color: Colors.white,
          ),
          shrinkWrap: true,
          itemCount: currentWinners.length,
          itemBuilder: (context, index) {
            return Padding(
                padding: const EdgeInsets.only(top: 1.0, bottom: 1, left: 15, right: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
                      SizedBox(
                        width: 15,
                      ),
                      index == 0
                          ? Text(
                              (index + 1).toString() + 'st',
                              style: TextStyle(color: Constants.iWhite, fontSize: Constants.smallFontSize, fontWeight: FontWeight.w400),
                              textAlign: TextAlign.start,
                            )
                          : index == 1
                              ? Text(
                                  (index + 1).toString() + 'nd',
                                  style: TextStyle(color: Constants.iWhite, fontSize: Constants.smallFontSize, fontWeight: FontWeight.w400),
                                  textAlign: TextAlign.start,
                                )
                              : index == 2
                                  ? Text(
                                      (index + 1).toString() + 'rd',
                                      style: TextStyle(color: Constants.iWhite, fontSize: Constants.smallFontSize, fontWeight: FontWeight.w400),
                                      textAlign: TextAlign.start,
                                    )
                                  : Text(
                                      (index + 1).toString() + 'th',
                                      style: TextStyle(color: Constants.iWhite, fontSize: Constants.smallFontSize, fontWeight: FontWeight.w400),
                                      textAlign: TextAlign.start,
                                    ),
                      SizedBox(
                        width: 12,
                      ),
                      Text(
                        currentWinners[index],
                        style: TextStyle(color: Constants.iWhite, fontSize: Constants.smallFontSize, fontWeight: FontWeight.w300),
                        textAlign: TextAlign.start,
                      ),
                    ]),
                    Text(
                      currentVotes[currentWinners[index]].toString(),
                      style: TextStyle(color: Constants.iWhite, fontSize: Constants.smallFontSize, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ));
          },
        ));

    final nextButton = Padding(
      padding: EdgeInsets.only(bottom: 35),
      child: MaterialButton(
        elevation: 5.0,
        color: Constants.iBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        onPressed: () {
          if (!offlineGroupData.isGameEnded()) {
            offlineGroupData.nextRound();
            _moveToNext(true);
            if (_showRatePop()) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return RatePopup();
                },
              );
            }
          } else {
            Navigator.push(
                //TODO : create endScreen
                context,
                SlidePageRoute(fromPage: widget, toPage: SplashScreen()));
          }
        },
        //change isplaying field in database for this group to TRUE
        child: !offlineGroupData.isGameEnded()
            ? Container(
                width: MediaQuery.of(context).size.width / 2,
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.only(top: 3, left: 3.0, right: 3, bottom: 3),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                    Text(
                      "Next Question",
                      style: TextStyle(fontFamily: "roboto", fontSize: Constants.smallFontSize, color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    FaIcon(
                      FontAwesomeIcons.chevronRight,
                      size: 22,
                      color: Colors.white,
                    )
                  ]),
                ),
              )
            : Container(
                width: MediaQuery.of(context).size.width / 2,
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.only(top: 3, left: 3.0, right: 3, bottom: 3),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                    Text(
                      "The games has ended",
                      style: TextStyle(fontFamily: "roboto", fontSize: Constants.smallFontSize, color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    FaIcon(FontAwesomeIcons.chevronRight, size: 22, color: Colors.white)
                  ]),
                )),
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
      ],
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.transparent,
      ),
      home: Scaffold(
        floatingActionButton: nextButton,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            // CustomPaint(
            //   painter: ResultsBottomCurvePainter(),
            // ),
            Positioned(
              right: 12,
              top: 12,
              child: SafeArea(
                child: InkWell(
                  onTap: () {
                    FirebaseAnalytics.instance.logEvent(name: 'game_action', parameters: {
                      'type': 'PartyGameEnded',
                    });
                    Navigator.push(
                        context,
                        SlidePageRoute(
                            //TODO : create endScreen
                            fromPage: widget,
                            toPage: SplashScreen()));
                  },
                  child: Text(
                    "End game",
                    style: TextStyle(fontSize: Constants.smallFontSize, color: Constants.iLight, fontWeight: FontWeight.w300),
                  ),
                ),
              ),
            ),
            Column(
              children: <Widget>[
                //Title
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 70,
                    ),
                    Center(
                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                      Text(
                        'Round results',
                        style: TextStyle(fontSize: Constants.normalFontSize, color: Constants.iBlue, fontWeight: FontWeight.w300),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.timeline,
                        size: 50,
                        color: Constants.iBlue,
                      ),
                    ])),
                    SizedBox(
                      height: 25,
                    ),
                    //question
                    Padding(
                      padding: EdgeInsets.only(left: 35, right: 35),
                      child: Text(
                        offlineGroupData.getCurrentQuestion().getQuestion(),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Constants.iWhite, fontSize: 20, fontWeight: FontWeight.w300),
                      ),
                    ),
                  ],
                ),
                //results
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 60),
                  child: results,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
