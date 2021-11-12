// @dart=2.9

import 'package:blackbox/Models/OfflineGroupData.dart';
import 'package:blackbox/Screens/PartyQuestionScreen.dart';
import 'package:blackbox/Screens/animation/SlidePageRoute.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Constants.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:blackbox/Screens/popups/rate_popup.dart';
import 'package:blackbox/translations/translations.i18n.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../main.dart';

class PartyResultScreen extends StatefulWidget {
  OfflineGroupData offlineGroupData;

  PartyResultScreen(OfflineGroupData offlineGroupData) {
    this.offlineGroupData = offlineGroupData;
  }

  @override
  PartyResultScreenState createState() =>
      PartyResultScreenState(offlineGroupData);
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
          ? SlidePageRoute(
              fromPage: widget, toPage: PartyQuestionScreen(offlineGroupData))
          : PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) =>
                  PartyQuestionScreen(offlineGroupData),
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

  bool myInterceptor(bool stopDefaultButtonEvent) {
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
        child: Column(children: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          currentWinners.length >= 2
              ? DelayedDisplay(
                  delay: Duration(milliseconds: 400),
                  slidingBeginOffset: const Offset(0.0, 0.2),
                  child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: SizedBox(
                                width: MediaQuery.of(context).size.width / 4.5,
                                height: MediaQuery.of(context).size.width / 4.5,
                                child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Constants.iDarkGrey,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        AutoSizeText(
                                          currentWinners[1],
                                          style: TextStyle(
                                              color: Constants.iWhite,
                                              fontSize: Constants.smallFontSize,
                                              fontWeight: FontWeight.w600),
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                        ),
                                        Text(
                                          currentVotes[currentWinners[1]]
                                                  .toString() +
                                              (currentVotes[currentWinners[1]]
                                                          .toString() ==
                                                      '1'
                                                  ? ' vote'.i18n
                                                  : ' votes'.i18n),
                                          style: TextStyle(
                                              color: Constants.iLight,
                                              fontSize:
                                                  Constants.smallFontSize - 2,
                                              fontWeight: FontWeight.w400),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(
                                          height: 12,
                                        )
                                      ],
                                    )))),
                        Card(
                            color: Constants.iBlue,
                            child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 3, horizontal: 6),
                                child: Text(
                                  '2',
                                  style: TextStyle(
                                      fontSize: Constants.smallFontSize,
                                      color: Constants.iBlack),
                                )))
                      ]))
              : SizedBox(
                  width: MediaQuery.of(context).size.width / 4.5,
                ),
          SizedBox(
            width: 10,
          ),
          DelayedDisplay(
            delay: Duration(milliseconds: 200),
            slidingBeginOffset: const Offset(0.0, 0.2),
            child: Stack(alignment: Alignment.bottomCenter, children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width / 3.8,
                      height: MediaQuery.of(context).size.width / 3.8,
                      child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Constants.iDarkGrey,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              AutoSizeText(
                                currentWinners[0],
                                style: TextStyle(
                                    color: Constants.iWhite,
                                    fontSize: Constants.smallFontSize,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                              ),
                              Text(
                                currentVotes[currentWinners[0]].toString() +
                                    (currentVotes[currentWinners[0]]
                                                .toString() ==
                                            '1'
                                        ? ' vote'.i18n
                                        : ' votes'.i18n),
                                style: TextStyle(
                                    color: Constants.iLight,
                                    fontSize: Constants.smallFontSize - 2,
                                    fontWeight: FontWeight.w400),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 12,
                              )
                            ],
                          )))),
              Card(
                  elevation: 0.0,
                  color: Constants.iBlue,
                  child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 11),
                      child: Text(
                        '1',
                        style: TextStyle(
                            fontSize: Constants.smallFontSize,
                            color: Constants.iBlack),
                      ))),
            ]),
          ),
          SizedBox(
            width: 10,
          ),
          currentWinners.length >= 3
              ? DelayedDisplay(
                  delay: Duration(milliseconds: 600),
                  slidingBeginOffset: const Offset(0.0, 0.2),
                  child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: SizedBox(
                                height: MediaQuery.of(context).size.width / 4.5,
                                width: MediaQuery.of(context).size.width / 4.5,
                                child: Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Constants.iDarkGrey,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        AutoSizeText(
                                          currentWinners[2],
                                          style: TextStyle(
                                              color: Constants.iWhite,
                                              fontSize: Constants.smallFontSize,
                                              fontWeight: FontWeight.w600),
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                        ),
                                        Text(
                                          currentVotes[currentWinners[2]]
                                                  .toString() +
                                              (currentVotes[currentWinners[2]]
                                                          .toString() ==
                                                      '1'
                                                  ? ' vote'.i18n
                                                  : ' votes'.i18n),
                                          style: TextStyle(
                                              color: Constants.iLight,
                                              fontSize:
                                                  Constants.smallFontSize - 2,
                                              fontWeight: FontWeight.w400),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(
                                          height: 12,
                                        )
                                      ],
                                    )))),
                        Card(
                            color: Constants.iBlue,
                            child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 3, horizontal: 6),
                                child: Text(
                                  '3',
                                  style: TextStyle(
                                      fontSize: Constants.smallFontSize,
                                      color: Constants.iBlack),
                                )))
                      ]))
              : SizedBox(
                  width: MediaQuery.of(context).size.width / 4.5,
                ),
        ],
      ),
      SizedBox(
        height: 20,
      ),
      currentWinners.length > 3
          ? AnimationLimiter(
              child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(left: 20, right: 20),
                  scrollDirection: Axis.vertical,
                  itemCount: currentWinners.length - 3,
                  itemBuilder: (BuildContext context, int index) =>
                      AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 1200),
                          child: SlideAnimation(
                              verticalOffset: 25.0,
                              child: FadeInAnimation(
                                  child: Card(
                                      elevation: 0.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      color: Colors.transparent,
                                      child: Center(
                                        child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 5,
                                                bottom: 5,
                                                left: 15,
                                                right: 30),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      SizedBox(
                                                        width: 15,
                                                      ),
                                                      Text(
                                                        (index + 4).toString() +
                                                            'th'.i18n,
                                                        style: TextStyle(
                                                            color: Constants
                                                                .iWhite,
                                                            fontSize: Constants
                                                                .smallFontSize,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                        textAlign:
                                                            TextAlign.start,
                                                      ),
                                                      SizedBox(
                                                        width: 12,
                                                      ),
                                                      Text(
                                                        currentWinners[
                                                            index + 3],
                                                        style: TextStyle(
                                                            color: Constants
                                                                .iWhite,
                                                            fontSize: Constants
                                                                .smallFontSize,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w300),
                                                        textAlign:
                                                            TextAlign.start,
                                                      ),
                                                    ]),
                                                Text(
                                                  currentVotes[currentWinners[
                                                          index + 3]]
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Constants.iWhite,
                                                      fontSize: Constants
                                                          .smallFontSize,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                  textAlign: TextAlign.start,
                                                ),
                                              ],
                                            )),
                                      )))))))
          : SizedBox(
              height: 1,
            ),
    ]));

    final nextButton = Card(
      elevation: 5.0,
      color: Constants.iBlue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0),
        splashColor: Constants.iBlue,
        onTap: () {
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
                    !offlineGroupData.isGameEnded()
                        ? 'Next Question'.i18n
                        : "The games has ended".i18n,
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
        scaffoldBackgroundColor: Colors.transparent,
      ),
      home: I18n(
        child: Scaffold(
          backgroundColor: Constants.iBlack,
          body: ListView(
            padding: EdgeInsets.only(left: 10, right: 10),
            children: [
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.topRight,
                child: SafeArea(
                  child: InkWell(
                    onTap: () {
                      FirebaseAnalytics()
                          .logEvent(name: 'game_action', parameters: {
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
                      "End game".i18n,
                      style: TextStyle(
                          fontSize: Constants.smallFontSize,
                          color: Constants.iLight,
                          fontWeight: FontWeight.w300),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Center(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                    Text(
                      'Round results'.i18n,
                      style: TextStyle(
                          fontSize: Constants.normalFontSize,
                          color: Constants.iWhite,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Icons.timeline,
                      size: 50,
                      color: Constants.iWhite,
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
                  style: TextStyle(
                      color: Constants.iLight,
                      fontSize: 20,
                      fontWeight: FontWeight.w300),
                ),
              ),
              SizedBox(
                height: 30,
              ),

              results,

              SizedBox(
                height: 60,
              ),
            ],
          ),
          floatingActionButton: nextButton,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        ),
      ),
    );
  }
}
