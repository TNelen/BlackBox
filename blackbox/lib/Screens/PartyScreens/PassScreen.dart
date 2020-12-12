import 'package:blackbox/DataContainers/OfflineGroupData.dart';
import 'package:blackbox/Screens/PartyScreens/PartyResultsScreen.dart';
import 'package:blackbox/Screens/popups/Popup.dart';
import 'package:blackbox/Screens/widgets/IconCard.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import '../../Constants.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import 'PartyQuestionScreen.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

class PassScreen extends StatefulWidget {
  OfflineGroupData offlineGroupData;

  PassScreen(OfflineGroupData offlineGroupData) {
    this.offlineGroupData = offlineGroupData;
  }

  @override
  _PassScreenState createState() => _PassScreenState(offlineGroupData);
}

class _PassScreenState extends State<PassScreen> {
  OfflineGroupData offlineGroupData;

  _PassScreenState(this.offlineGroupData) {
    FirebaseAnalytics().logEvent(
        name: 'open_screen', parameters: {'screen_name': 'PassScreen'});
  }

  bool allPlayersVoted() {
    return offlineGroupData.canVoteBlank
        ? ((offlineGroupData.getPlayers().length - 1) ==
            offlineGroupData.getAmountOfCurrentVotes())
        : (offlineGroupData.getPlayers().length ==
            offlineGroupData.getAmountOfCurrentVotes());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BlackBox',
        theme: ThemeData(
            fontFamily: "atarian", scaffoldBackgroundColor: Constants.iBlack),
        home: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Constants.iBlack,
            title:
                Row(mainAxisAlignment: MainAxisAlignment.start, children: []),
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
              padding: const EdgeInsets.only(
                  top: 20.0, bottom: 20, left: 50, right: 50),
              children: [
                SizedBox(height: 10.0),
                Row(mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.,
                    children: [
                      Text(
                        'pass the phone',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Constants.colors[Constants.colorindex],
                            fontSize: Constants.titleFontSize,
                            fontWeight: FontWeight.w300),
                      ),
                      JumpingDotsProgressIndicator(
                        numberOfDots: 3,
                        fontSize: Constants.titleFontSize,
                        color: Constants.colors[Constants.colorindex],
                      ),
                    ]),
                SizedBox(height: 20.0),
                Text(
                  offlineGroupData.canVoteBlank
                      ? offlineGroupData.getAmountOfCurrentVotes().toString() +
                          '/' +
                          (offlineGroupData.getPlayers().length - 1)
                              .toString() +
                          ' players have voted'
                      : offlineGroupData.getAmountOfCurrentVotes().toString() +
                          '/' +
                          offlineGroupData.getPlayers().length.toString() +
                          ' players have voted',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Constants.iWhite,
                      fontSize: Constants.normalFontSize,
                      fontWeight: FontWeight.w300),
                ),
                SizedBox(height: 40.0),
                Card(
                  elevation: 5.0,
                  color: Constants.iDarkGrey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16.0),
                    onTap: () {
                      allPlayersVoted()
                          ? null
                          : Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    PartyQuestionScreen(offlineGroupData),
                              ));
                    },
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 5, left: 10.0, right: 10, bottom: 5),
                        child: Stack(children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 35),
                              Text(
                                "  Vote!",
                                style: TextStyle(
                                    color: allPlayersVoted()
                                        ? Constants.iLight
                                        : Constants.iWhite,
                                    fontSize: Constants.normalFontSize,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 5),
                              allPlayersVoted()
                                  ? Text(
                                      "  All players voted",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Constants.iLight,
                                          fontSize: Constants.smallFontSize,
                                          fontWeight: FontWeight.bold),
                                    )
                                  : Text(
                                      "  New vote for this round",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Constants.iLight,
                                          fontSize: Constants.smallFontSize,
                                          fontWeight: FontWeight.bold),
                                    ),
                              SizedBox(height: 10),
                            ],
                          ),
                          Positioned(
                            right: 0.0,
                            top: 0.0,
                            child: allPlayersVoted()
                                ? IconCard(
                                    OMIcons.edit,
                                    Constants.iGrey.withOpacity(0.1),
                                    Constants.iLight.withOpacity(0.5),
                                    35,
                                  )
                                : IconCard(
                                    OMIcons.edit,
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
                    borderRadius: BorderRadius.circular(16.0),
                    onTap: () {
                      Popup.submitQuestionOfflinePopup(
                          context, offlineGroupData);
                    },
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 5, left: 10.0, right: 10, bottom: 5),
                        child: Stack(children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 35),
                              Text(
                                "  Add question",
                                style: TextStyle(
                                    color: Constants.iWhite,
                                    fontSize: Constants.normalFontSize,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "  Want to ask a question? Submit it here!",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Constants.iLight,
                                    fontSize: Constants.smallFontSize,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                          Positioned(
                            right: 0.0,
                            top: 0.0,
                            child: IconCard(
                              OMIcons.libraryAdd,
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
                SizedBox(
                  height: 10,
                ),
                Text(
                  offlineGroupData.questionsLeft().toString() +
                      " questions remaining",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Constants.iWhite,
                      fontSize: Constants.smallFontSize,
                      fontWeight: FontWeight.bold),
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
            textStyle: TextStyle(
                color: Constants.iWhite,
                fontSize: Constants.smallFontSize,
                fontWeight: FontWeight.bold),
            icon: OMIcons.chevronRight,
            onConfirmation: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        PartyResultScreen(offlineGroupData),
                  ));
            },
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        ));
  }
}
