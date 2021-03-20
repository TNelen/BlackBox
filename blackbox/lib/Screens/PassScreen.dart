import 'package:blackbox/Models/OfflineGroupData.dart';
import 'package:blackbox/Screens/PartyResultsScreen.dart';
import 'package:blackbox/Screens/animation/ScalePageRoute.dart';
import 'package:blackbox/Screens/animation/SlidePageRoute.dart';
import 'package:blackbox/Screens/popups/Popup.dart';
import 'package:blackbox/Screens/widgets/IconCard.dart';
import 'package:blackbox/Screens/widgets/PassScreenButton.dart';
import 'package:blackbox/Util/Curves.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:progress_indicators/progress_indicators.dart';
import '../Constants.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import 'EditPlayersScreen.dart';
import 'PartyQuestionScreen.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:blackbox/translations/translations.i18n.dart';
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
        ? ((offlineGroupData.getPlayers().length - 1) ==
            offlineGroupData.getAmountOfCurrentVotes())
        : (offlineGroupData.getPlayers().length ==
            offlineGroupData.getAmountOfCurrentVotes());
  }

  void _moveToResults(bool doAnimate) {
    Navigator.push(
      context,
      doAnimate
          ? SlidePageRoute(
              fromPage: widget, toPage: PartyResultScreen(offlineGroupData))
          : PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) =>
                  PartyResultScreen(offlineGroupData),
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
            fontFamily: "roboto", scaffoldBackgroundColor: Constants.iBlack),
        home: I18n(
            child: Scaffold(
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
              fit: StackFit.expand,
              children: <Widget>[
                CustomPaint(
                  painter: PassTopCurvePainter(),
                ),
                CustomPaint(
                  painter: BottomCurvePainter(),
                ),
                ListView(
                  padding: const EdgeInsets.only(
                      top: 80.0, bottom: 20, left: 45, right: 45),
                  children: [
                    SizedBox(height: 10.0),
                    Row(mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.,
                        children: [
                          Text(
                            'Pass the phone'.i18n,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Constants.iWhite,
                                fontSize: Constants.normalFontSize + 3,
                                fontWeight: FontWeight.w300),
                          ),
                          JumpingDotsProgressIndicator(
                            numberOfDots: 3,
                            fontSize: Constants.normalFontSize + 3,
                            color: Constants.iWhite,
                          ),
                        ]),
                    SizedBox(height: 20.0),
                    Text(
                      offlineGroupData.canVoteBlank
                          ? offlineGroupData
                                  .getAmountOfCurrentVotes()
                                  .toString() +
                              '/' +
                              (offlineGroupData.getPlayers().length - 1)
                                  .toString() +
                              ' players have voted'.i18n
                          : offlineGroupData
                                  .getAmountOfCurrentVotes()
                                  .toString() +
                              '/' +
                              offlineGroupData.getPlayers().length.toString() +
                              ' players have voted'.i18n,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Constants.iLight,
                          fontSize: Constants.smallFontSize,
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
                          color: Constants.iLight,
                          fontSize: Constants.miniFontSize,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 75.0),
                    PassScreenButton(
                      title: "Vote!".i18n,
                      titleStyle: TextStyle(
                          color: allPlayersVoted()
                              ? Constants.iLight
                              : Constants.iWhite,
                          fontSize: Constants.normalFontSize - 3,
                          fontWeight: FontWeight.w500),
                      subtitle: allPlayersVoted()
                          ? "All players voted".i18n
                          : "New vote for this round".i18n,
                      subtitleStyle: TextStyle(
                          color: Constants.iLight,
                          fontSize: Constants.smallFontSize - 2,
                          fontWeight: FontWeight.w300),
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
                              Constants.iAccent,
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
                      title: "Add question".i18n,
                      subtitle: "Want to ask a question? Submit it here!".i18n,
                      titleStyle: TextStyle(
                          color: allPlayersVoted()
                              ? Constants.iLight
                              : Constants.iWhite,
                          fontSize: Constants.normalFontSize - 3,
                          fontWeight: FontWeight.w500),
                      subtitleStyle: TextStyle(
                          color: Constants.iLight,
                          fontSize: Constants.smallFontSize - 2,
                          fontWeight: FontWeight.w300),
                      iconCard: IconCard(
                        OMIcons.libraryAdd,
                        Constants.iGrey.withOpacity(0.1),
                        Constants.iAccent,
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
                  top: 20,
                  child: SafeArea(child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    child: InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FaIcon(
                          FontAwesomeIcons.userEdit,
                          color: Constants.iDarkGrey,
                          size: 25,
                        ),
                      ),
                      splashColor: Constants.iDarkGrey,
                      onTap: () {
                        Navigator.push(
                            context,
                            ScaleUpPageRoute(
                                EditPlayersScreen(offlineGroupData)));
                      },
                    ),
                  ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: ConfirmationSlider(
            backgroundColor: Constants.iDarkGrey,
            foregroundColor: Constants.iLight,
            backgroundShape: BorderRadius.circular(16.0),
            foregroundShape: BorderRadius.circular(16.0),
            text: "Swipe to go to results".i18n,
            textStyle: TextStyle(
                color: Constants.iLight,
                fontSize: Constants.miniFontSize,
                fontWeight: FontWeight.w500),
            icon: FontAwesomeIcons.angleDoubleRight,
            iconColor: Constants.iDarkGrey,
            onConfirmation: () {
              _moveToResults(true);
            },
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        )));
  }
}
