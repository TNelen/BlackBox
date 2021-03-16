import 'package:blackbox/Models/OfflineGroupData.dart';
import 'package:blackbox/Screens/PartyQuestionScreen.dart';
import 'package:blackbox/Screens/animation/SlidePageRoute.dart';
import 'package:blackbox/Util/Curves.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Constants.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:blackbox/ad_manager.dart';
import 'package:firebase_admob/firebase_admob.dart';
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

  InterstitialAd _interstitialAd;

  bool _isInterstitialAdReady;

  void _loadInterstitialAd() {
    _interstitialAd.load();
  }

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

  void _onInterstitialAdEvent(MobileAdEvent event) {
    switch (event) {
      case MobileAdEvent.loaded:
        _isInterstitialAdReady = true;
        break;
      case MobileAdEvent.failedToLoad:
        _isInterstitialAdReady = false;
        print('Failed to load an interstitial ad');
        break;
      case MobileAdEvent.closed:
        _moveToNext(false);
        break;
      default:
      // do nothing
    }
  }

  @override
  void initState() {
    showMoreCurrent = false;
    showMoreAll = false;

    BackButtonInterceptor.add(myInterceptor);

    _isInterstitialAdReady = false;

    _interstitialAd = InterstitialAd(
      adUnitId: AdManager.interstitialAdUnitId,
      listener: _onInterstitialAdEvent,
    );

    if (!_isInterstitialAdReady) {
      _loadInterstitialAd();
    }
  }

  @override
  dispose() {
    controller.dispose();
    BackButtonInterceptor.remove(myInterceptor);
    _interstitialAd?.dispose();
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
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: Column(children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              currentWinners.length >= 2
                  ? Stack(alignment: Alignment.bottomCenter, children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width / 4.5,
                              height: MediaQuery.of(context).size.width / 4.5,
                              child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Constants.iLight.withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      AutoSizeText(
                                        currentWinners[1],
                                        style: TextStyle(
                                            color: Constants.iDarkGrey,
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
                                            color: Constants.iWhite,
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
                          color: Constants.iWhite,
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 3, horizontal: 6),
                              child: Text(
                                '2',
                                style: TextStyle(
                                    fontSize: Constants.smallFontSize,
                                    color: Constants.iBlack),
                              )))
                    ])
                  : SizedBox(
                      width: MediaQuery.of(context).size.width / 4.5,
                    ),
              SizedBox(
                width: 10,
              ),
              Stack(alignment: Alignment.bottomCenter, children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width / 3.8,
                        height: MediaQuery.of(context).size.width / 3.8,
                        child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Constants.iLight.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                AutoSizeText(
                                  currentWinners[0],
                                  style: TextStyle(
                                      color: Constants.iDarkGrey,
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
                                      color: Constants.iWhite,
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
                    color: Constants.iAccent,
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
              SizedBox(
                width: 10,
              ),
              currentWinners.length >= 3
                  ? Stack(alignment: Alignment.bottomCenter, children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: SizedBox(
                              height: MediaQuery.of(context).size.width / 4.5,
                              width: MediaQuery.of(context).size.width / 4.5,
                              child: Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Constants.iLight.withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      AutoSizeText(
                                        currentWinners[2],
                                        style: TextStyle(
                                            color: Constants.iDarkGrey,
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
                                            color: Constants.iWhite,
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
                          color: Constants.iWhite,
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 3, horizontal: 6),
                              child: Text(
                                '3',
                                style: TextStyle(
                                    fontSize: Constants.smallFontSize,
                                    color: Constants.iBlack),
                              )))
                    ])
                  : SizedBox(
                      width: MediaQuery.of(context).size.width / 4.5,
                    ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          currentWinners.length > 3
              ? Container(
                  height: MediaQuery.of(context).size.height / 4.5,
                  child: ListView.separated(
                    padding: EdgeInsets.only(left: 25, right: 25),
                    separatorBuilder: (context, index) => Divider(
                      color: Colors.white,
                    ),
                    shrinkWrap: true,
                    itemCount: currentWinners.length - 3,
                    itemBuilder: (context, index) {
                      return Card(
                          elevation: 0.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          color: Colors.transparent,
                          child: Center(
                            child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 1.0, bottom: 1, left: 15, right: 30),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Text(
                                            (index + 4).toString() + 'th'.i18n,
                                            style: TextStyle(
                                                color: Constants.iWhite,
                                                fontSize:
                                                    Constants.smallFontSize,
                                                fontWeight: FontWeight.w400),
                                            textAlign: TextAlign.start,
                                          ),
                                          SizedBox(
                                            width: 12,
                                          ),
                                          Text(
                                            currentWinners[index + 3],
                                            style: TextStyle(
                                                color: Constants.iWhite,
                                                fontSize:
                                                    Constants.smallFontSize,
                                                fontWeight: FontWeight.w300),
                                            textAlign: TextAlign.start,
                                          ),
                                        ]),
                                    Text(
                                      currentVotes[currentWinners[index + 3]]
                                          .toString(),
                                      style: TextStyle(
                                          color: Constants.iWhite,
                                          fontSize: Constants.smallFontSize,
                                          fontWeight: FontWeight.w600),
                                      textAlign: TextAlign.start,
                                    ),
                                  ],
                                )),
                          ));
                    },
                  ),
                )
              : SizedBox(
                  height: 1,
                ),
        ]));

    final nextButton = Padding(
      padding: EdgeInsets.only(bottom: 35),
      child: Card(
        elevation: 5.0,
        color: Constants.iLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: InkWell(
            borderRadius: BorderRadius.circular(12.0),
            // splashColor: Constants.iAccent,
            onTap: () {
              if (!offlineGroupData.isGameEnded()) {
                offlineGroupData.nextRound();

                if (_isInterstitialAdReady) {
                  _interstitialAd.show();
                }

                _moveToNext(true);
                if (_showRatePop()) {
                  showDialog(
                    context: context,
                    child: RatePopup(),
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
                      padding: const EdgeInsets.only(
                          top: 3, left: 3.0, right: 3, bottom: 3),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Next Question".i18n,
                              style: TextStyle(
                                  fontFamily: "roboto",
                                  fontSize: Constants.smallFontSize,
                                  color: Constants.iDarkGrey,
                                  fontWeight: FontWeight.w700),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            FaIcon(
                              FontAwesomeIcons.chevronCircleRight,
                              size: 22,
                              color: Constants.iDarkGrey,
                            )
                          ]),
                    ),
                  )
                : Container(
                    width: MediaQuery.of(context).size.width / 2,
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 3, left: 3.0, right: 3, bottom: 3),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "The games has ended".i18n,
                              style: TextStyle(
                                  fontFamily: "roboto",
                                  fontSize: Constants.smallFontSize,
                                  color: Constants.iDarkGrey,
                                  fontWeight: FontWeight.w700),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            FaIcon(
                              FontAwesomeIcons.chevronCircleRight,
                              size: 22,
                              color: Constants.iDarkGrey,
                            )
                          ]),
                    ),
                  )),
      ),
    );
    return MaterialApp(
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
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Constants.iBlack,
            title: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              FlatButton(
                onPressed: () {
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
              )
            ]),
          ),
          body: Container(
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
                  painter: ResultsBottomCurvePainter(),
                ),
                Column(
                  children: <Widget>[
                    //Title
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 25,
                          ),
                          Center(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                Text(
                                  'Round results'.i18n,
                                  style: TextStyle(
                                      fontSize: Constants.normalFontSize,
                                      color: Constants.iAccent,
                                      fontWeight: FontWeight.w300),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.timeline,
                                  size: 50,
                                  color: Constants.iAccent,
                                ),
                              ])),
                          SizedBox(
                            height: 25,
                          ),
                          //question
                          Padding(
                            padding: EdgeInsets.only(left: 35, right: 35),
                            child: Text(
                              offlineGroupData
                                  .getCurrentQuestion()
                                  .getQuestion(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Constants.iWhite,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //results
                    Expanded(
                        flex: 2,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              results,
                              nextButton,
                            ],
                          ),
                        )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
