import 'package:audioplayers/audio_cache.dart';
import 'package:blackbox/Models/OfflineGroupData.dart';
import 'package:blackbox/Screens/HomeScreen.dart';
import 'package:blackbox/Screens/PartyScreens/PartyQuestionScreen.dart';
import 'package:blackbox/Util/VibrationHandler.dart';
import 'package:flutter/material.dart';
import '../../Models/GroupData.dart';
import '../../Constants.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:blackbox/ad_manager.dart';
import 'package:firebase_admob/firebase_admob.dart';

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

  void _moveToNext() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) =>
              PartyQuestionScreen(offlineGroupData),
        ));
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
        _moveToNext();
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

    if(!_isInterstitialAdReady) {
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
  Widget _buildBody(BuildContext context) {
    List<String> alltimeWinners = offlineGroupData.getAlltimeRanking();
    Map<String, int> allTimeVotes = offlineGroupData.getTotalVotes();
    List<String> currentWinners = offlineGroupData.getCurrentRanking();
    Map<String, int> currentVotes = offlineGroupData.getCurrentVotes();

    void toggleAlltime() {
      showMoreAll = !showMoreAll;
    }

    void toggleCurrent() {
      showMoreCurrent = !showMoreCurrent;
    }

    final alltime = Container(
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: Column(children: <Widget>[
          Text(
            'Alltime leaderboard',
            style: TextStyle(
                color: Constants.iWhite,
                fontSize: Constants.normalFontSize,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 5,
          ),
          ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => Divider(
              color: Colors.white,
            ),
            shrinkWrap: true,
            itemCount: !showMoreAll
                ? (alltimeWinners.length >= 3 ? 3 : alltimeWinners.length)
                : alltimeWinners.length,
            itemBuilder: (context, index) {
              String playerName = alltimeWinners[index];
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    (index + 1).toString() +
                                        (index == 0
                                            ? 'st'
                                            : index == 1
                                                ? 'nd'
                                                : index == 2 ? 'rd' : 'th'),
                                    style: TextStyle(
                                        color: index == 0
                                            ? Constants
                                                .colors[Constants.colorindex]
                                            : Constants.iWhite,
                                        fontSize: Constants.smallFontSize,
                                        fontWeight: FontWeight.w400),
                                    textAlign: TextAlign.start,
                                  ),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Text(
                                    playerName,
                                    style: TextStyle(
                                        color: index == 0
                                            ? Constants
                                                .colors[Constants.colorindex]
                                            : Constants.iWhite,
                                        fontSize: Constants.smallFontSize,
                                        fontWeight: FontWeight.w300),
                                    textAlign: TextAlign.start,
                                  ),
                                ]),
                            Text(
                              allTimeVotes[playerName].toString(),
                              style: TextStyle(
                                  color: index == 0
                                      ? Constants.colors[Constants.colorindex]
                                      : Constants.iWhite,
                                  fontSize: Constants.smallFontSize,
                                  fontWeight: FontWeight.w600),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        )),
                  ));
            },
          ),
          alltimeWinners.length > 3
              ? FlatButton(
                  color: Colors.transparent,
                  onPressed: () {
                    toggleAlltime();
                    setState(() {});
                  },
                  splashColor: Constants.colors[Constants.colorindex],
                  child: showMoreAll
                      ? Text(
                          "Show less",
                          style: TextStyle(
                              color: Constants.colors[Constants.colorindex],
                              fontSize: Constants.smallFontSize),
                        )
                      : Text(
                          "Show More",
                          style: TextStyle(
                              color: Constants.colors[Constants.colorindex],
                              fontSize: Constants.smallFontSize),
                        ),
                )
              : SizedBox(
                  height: 25,
                )
        ]));

    final results = Container(
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: Column(children: <Widget>[
          Text(
            'Results',
            style: TextStyle(
                color: Constants.iWhite,
                fontSize: Constants.normalFontSize,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 5,
          ),
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
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Constants.iDarkGrey,
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                      color: Constants.iWhite,
                                      width: 1,
                                    ),
                                  ),
                                  child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      color: Constants.iDarkGrey,
                                      child: Column(
                                        children: <Widget>[
                                          AutoSizeText(
                                            currentWinners[1],
                                            style: TextStyle(
                                                color: Constants.colors[
                                                    Constants.colorindex],
                                                fontSize:
                                                    Constants.smallFontSize,
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
                                                    ? ' vote'
                                                    : ' votes'),
                                            style: TextStyle(
                                                color: Constants.iWhite,
                                                fontSize:
                                                    Constants.miniFontSize,
                                                fontWeight: FontWeight.w400),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(
                                            height: 12,
                                          )
                                        ],
                                      ))))),
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
                width: 5,
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
                              color: Constants.iDarkGrey,
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                color: Constants.iWhite,
                                width: 1,
                              ),
                            ),
                            child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                color: Constants.iDarkGrey,
                                elevation: 0.0,
                                child: Column(
                                  children: <Widget>[
                                    AutoSizeText(
                                      currentWinners.length == 0
                                          ? ""
                                          : currentWinners[0].toString(),
                                      style: TextStyle(
                                          color: Constants
                                              .colors[Constants.colorindex],
                                          fontSize: Constants.normalFontSize,
                                          fontWeight: FontWeight.w600),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                    ),
                                    Text(
                                      currentWinners.length == 0
                                          ? ""
                                          : currentVotes[currentWinners[0]]
                                                  .toString() +
                                              (currentVotes[currentWinners[0]]
                                                          .toString() ==
                                                      '1'
                                                  ? ' vote'
                                                  : ' votes'),
                                      style: TextStyle(
                                          color: Constants.iWhite,
                                          fontSize: Constants.smallFontSize,
                                          fontWeight: FontWeight.w400),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      height: 14,
                                    )
                                  ],
                                ))))),
                Card(
                    elevation: 0.0,
                    color: Constants.colors[Constants.colorindex],
                    child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 11),
                        child: Text(
                          '1',
                          style: TextStyle(
                              fontSize: Constants.smallFontSize,
                              color: Constants.iBlack),
                        )))
              ]),
              SizedBox(
                width: 5,
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
                                    color: Constants.iDarkGrey,
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                      color: Constants.iWhite,
                                      width: 1,
                                    ),
                                  ),
                                  child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      color: Constants.iDarkGrey,
                                      child: Column(
                                        children: <Widget>[
                                          AutoSizeText(
                                            currentWinners[2].toString(),
                                            style: TextStyle(
                                                color: Constants.colors[
                                                    Constants.colorindex],
                                                fontSize:
                                                    Constants.smallFontSize,
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
                                                    ? ' vote'
                                                    : ' votes'),
                                            style: TextStyle(
                                                color: Constants.iWhite,
                                                fontSize:
                                                    Constants.miniFontSize,
                                                fontWeight: FontWeight.w400),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(
                                            height: 12,
                                          )
                                        ],
                                      ))))),
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
          currentWinners.length > 3
              ? ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) => Divider(
                    color: Colors.white,
                  ),
                  shrinkWrap: true,
                  itemCount: !showMoreCurrent
                      ? (currentWinners.length >= 3
                          ? 0
                          : currentWinners.length - 3)
                      : currentWinners.length - 3,
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
                                          (index + 4).toString() + 'th',
                                          style: TextStyle(
                                              color: Constants.iWhite,
                                              fontSize: Constants.smallFontSize,
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
                                              fontSize: Constants.smallFontSize,
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
                )
              : SizedBox(
                  height: 1,
                ),
          currentWinners.length > 3
              ? FlatButton(
                  color: Colors.transparent,
                  onPressed: () {
                    toggleCurrent();
                    setState(() {});
                  },
                  splashColor: Constants.colors[Constants.colorindex],
                  child: showMoreCurrent
                      ? Text(
                          "Show less",
                          style: TextStyle(
                              color: Constants.colors[Constants.colorindex],
                              fontSize: Constants.smallFontSize),
                        )
                      : Text(
                          "Show More",
                          style: TextStyle(
                              color: Constants.colors[Constants.colorindex],
                              fontSize: Constants.smallFontSize),
                        ),
                )
              : SizedBox(
                  height: 50,
                )
        ]));

    final nextButton = Padding(
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
              if (!offlineGroupData.isGameEnded()) {
                offlineGroupData.nextRound();
                if (_isInterstitialAdReady) {
                  _interstitialAd.show();
                }

                _moveToNext();
              } else {
                if (_isInterstitialAdReady) {
                  _interstitialAd.show();
                }
                //go to overview
                Navigator.push(
                    //TODO : create endScreen
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => HomeScreen(),
                    ));
              }
            },
            //change isplaying field in database for this group to TRUE
            child: !offlineGroupData.isGameEnded()
                ? Text("Next Question",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: Constants.actionbuttonFontSize)
                        .copyWith(
                            color: Constants.iBlack,
                            fontWeight: FontWeight.bold))
                : Text("The games has ended",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: Constants.actionbuttonFontSize)
                        .copyWith(
                            color: Constants.iBlack,
                            fontWeight: FontWeight.bold))),
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "atarian",
        scaffoldBackgroundColor: Colors.transparent,
      ),
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Constants.iBlack,
          title: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            FlatButton(
              onPressed: () {
                FirebaseAnalytics().logEvent(name: 'game_action', parameters: {
                  'type': 'PartyGameEnded',
                });
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      //TODO : create endScreen
                      builder: (BuildContext context) => HomeScreen(),
                    ));
              },
              child: Text(
                "End game",
                style: TextStyle(
                    fontSize: Constants.actionbuttonFontSize,
                    color: Constants.colors[Constants.colorindex]),
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
          child: ListView(
            //shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: <Widget>[
              //Title
              Center(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                    Text(
                      'Leaderboard',
                      style: TextStyle(
                          fontSize: Constants.subtitleFontSize,
                          color: Constants.colors[Constants.colorindex],
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Icons.timeline,
                      size: 50,
                      color: Constants.colors[Constants.colorindex],
                    ),
                  ])),

              //question
              SizedBox(height: 30),
              Padding(
                padding: EdgeInsets.only(left: 35, right: 35),
                child: Text(
                  offlineGroupData.getCurrentQuestion().getQuestion(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Constants.iWhite,
                      fontSize: Constants.normalFontSize,
                      fontWeight: FontWeight.bold),
                ),
              ),

              SizedBox(height: 30),

              //results
              Padding(
                  padding: EdgeInsets.only(left: 35, right: 35),
                  child: results),

              //AllTime
              Padding(
                  padding: EdgeInsets.only(left: 35, right: 35),
                  child: alltime),

              SizedBox(
                height: 75,
              ),
            ],
          ),
        ),
        floatingActionButton: nextButton,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.transparent,
        ),
        home: Scaffold(
          body: _buildBody(context),
        ));
  }

  /// Plays audio and vibrates the phone indicating whether or not the player is in the previous top three
  /// See https://pub.dev/packages/audioplayers for more information
  ///

  void handleWinnerFeedback(GroupData groupData) async {
    if (groupData
        .getTopThreeIDs('previous')
        .containsKey(Constants.getUserID())) {
      if (Constants.getSoundEnabled()) playSound("winner.wav");
      if (Constants.getVibrationEnabled())
        VibrationHandler.vibrate(
            vibratePattern: [10, 50, 46, 48, 49, 70, 64, 66, 41, 70]);
    } else {
      if (Constants.getSoundEnabled()) playSound("loser.wav");
      if (Constants.getVibrationEnabled())
        VibrationHandler.vibrate(vibratePattern: [50, 50, 50, 129]);
    }
  }

  /// Plays and terminates a sound in the assets/sounds folder
  /// eg. assets/sounds/music.mp3 would be played by passing music.mp3 as parameter
  void playSound(String path) async {
    String full_path = 'sounds/' + path;

    final AudioCache player = AudioCache();

    /// Create an instance that is able to play sounds
    await player.play(full_path);

    /// Play the sound and wait for completion
    player.clear(full_path);

    /// Delete the loaded sound from temp memory
  }
}
