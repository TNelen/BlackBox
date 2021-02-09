import 'package:blackbox/Models/OfflineGroupData.dart';
import 'package:blackbox/Screens/PartyScreens/PartyResultsScreen.dart';
import 'package:blackbox/Screens/PartyScreens/widgets/PassScreenButton.dart';
import 'package:blackbox/Screens/animation/ScalePageRoute.dart';
import 'package:blackbox/Screens/animation/SlidePageRoute.dart';
import 'package:blackbox/Screens/popups/Popup.dart';
import 'package:blackbox/Screens/widgets/IconCard.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import '../../Constants.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import 'EditPlayersScreen.dart';
import 'PartyQuestionScreen.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:blackbox/translations/gameScreens.i18n.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
        ? ((offlineGroupData.getPlayers().length - 1) == offlineGroupData.getAmountOfCurrentVotes())
        : ( offlineGroupData.getPlayers().length      == offlineGroupData.getAmountOfCurrentVotes());
  }


  void _moveToResults(bool doAnimate) {
    Navigator.push(
        context,
        doAnimate ?
          SlidePageRoute(
              fromPage: widget,
              toPage: PartyResultScreen(offlineGroupData)
          ) :
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => PartyResultScreen(offlineGroupData),
            transitionDuration: Duration(seconds: 0),
          ),
    );
  }


  @override
  Widget build(BuildContext context) {
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
        title: 'BlackBox',
        theme: ThemeData(
            fontFamily: "atarian", scaffoldBackgroundColor: Constants.iBlack),
        home: I18n(child:Scaffold(
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
            child: Stack(
              children: [
                ListView(
                  padding: const EdgeInsets.only(
                      top: 40.0, bottom: 20, left: 45, right: 45),
                  children: [
                    SizedBox(height: 10.0),
                    Row(mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.,
                        children: [
                          Text(
                            'pass the phone'.i18n,
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
                              (offlineGroupData.getPlayers().length - 1).toString() +
                              ' players have voted'.i18n
                          : offlineGroupData.getAmountOfCurrentVotes().toString() +
                              '/' +
                              offlineGroupData.getPlayers().length.toString() +
                              ' players have voted'.i18n,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Constants.iWhite,
                          fontSize: Constants.normalFontSize,
                          fontWeight: FontWeight.w300),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      offlineGroupData.questionsLeft().toString() +
                          " questions remaining".i18n,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Constants.iWhite,
                          fontSize: Constants.smallFontSize,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 40.0),
                    PassScreenButton(
                      title: "  Vote!".i18n,
                      titleStyle: TextStyle(
                          color: allPlayersVoted()
                              ? Constants.iLight
                              : Constants.iWhite,
                          fontSize: Constants.normalFontSize,
                          fontWeight: FontWeight.bold
                      ),
                      subtitle: allPlayersVoted() ? "  All players voted".i18n : "  New vote for this round".i18n,
                      subtitleStyle: TextStyle(
                          color: Constants.iLight,
                          fontSize: Constants.smallFontSize,
                          fontWeight: FontWeight.bold
                      ),
                      iconCard: allPlayersVoted()
                          ? IconCard(
                        OMIcons.checkCircle,
                        Constants.iGrey.withOpacity(0.1),
                        Constants.iLight.withOpacity(0.5),
                        35,
                      )
                          : IconCard(
                        OMIcons.checkCircle,
                        Constants.iGrey.withOpacity(0.1),
                        Constants.colors[Constants.colorindex],
                        35,
                      ),
                      onTap: () {
                        allPlayersVoted()
                            ? null
                            : Navigator.push(
                            context,
                            SlidePageRoute(
                              fromPage: widget,
                              toPage: PartyQuestionScreen(offlineGroupData),
                            ));
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    PassScreenButton(
                      title: "  Add question".i18n,
                      subtitle: "  Want to ask a question? Submit it here!".i18n,
                      iconCard: IconCard(
                        OMIcons.libraryAdd,
                        Constants.iGrey.withOpacity(0.1),
                        Constants.colors[Constants.colorindex],
                        35,
                      ),
                      onTap: () {
                        Popup.submitQuestionOfflinePopup(
                            context, offlineGroupData);
                      },
                    ),
                  ],
                ),
                Positioned(
                  right: 20,
                  child: Material(
                    color: Constants.iDarkGrey,
                    borderRadius: BorderRadius.all( Radius.circular( 10.0 ) ),
                    child: InkWell(
                      borderRadius: BorderRadius.all( Radius.circular( 10.0 ) ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.edit,
                          color: Constants.colors[Constants.colorindex],
                          size: 35,
                        ),
                      ),
                      splashColor: Constants.colors[Constants.colorindex],
                      onTap: () {
                        Navigator.push(
                            context,
                            ScaleUpPageRoute(
                                EditPlayersScreen( offlineGroupData )
                            ));
                      },

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
            text: "Swipe to go to results".i18n,
            textStyle: TextStyle(
                color: Constants.iWhite,
                fontSize: Constants.smallFontSize,
                fontWeight: FontWeight.bold),
            icon: OMIcons.chevronRight,
            onConfirmation: () {

              _moveToResults( true );
            },
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        )));
  }
}
