import 'package:blackbox/Repositories/gameStateRepository.dart';
import 'package:blackbox/Screens/PartyResultsScreen.dart';
import 'package:blackbox/Screens/animation/SlidePageRoute.dart';
import 'package:blackbox/Screens/popups/Popup.dart';
import 'package:blackbox/Screens/widgets/IconCard.dart';
import 'package:blackbox/Screens/widgets/PassScreenButton.dart';
import 'package:blackbox/main.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:progress_indicators/progress_indicators.dart';
import '../Constants.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import 'PartyVoteScreen.dart';
import 'package:blackbox/translations/translations.i18n.dart';

class PassScreen extends StatefulWidget {
  PassScreen() {}

  @override
  _PassScreenState createState() => _PassScreenState();
}

class _PassScreenState extends State<PassScreen> {
  final GameStateRepository gameStateRepo = getIt.get<GameStateRepository>();

  _PassScreenState() {
    FirebaseAnalytics.instance.logEvent(name: 'open_screen', parameters: {'screen_name': 'PassScreen'});
  }

  bool allPlayersVoted() {
    return gameStateRepo.canVoteBlank
        ? ((gameStateRepo.getPlayers().length - 1) == gameStateRepo.getAmountOfCurrentVotes())
        : (gameStateRepo.getPlayers().length == gameStateRepo.getAmountOfCurrentVotes());
  }

  void _moveToResults(bool doAnimate) {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => PartyResultScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Constants.iBlack,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            ListView(
              padding: const EdgeInsets.only(top: 60.0, bottom: 20, left: 45, right: 45),
              children: [
                SizedBox(height: 10.0),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.,
                    children: [
                      Text(
                        'Pass the phone'.i18n,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Constants.iLight, fontSize: Constants.normalFontSize - 3, fontWeight: FontWeight.w300),
                      ),
                      JumpingDotsProgressIndicator(
                        numberOfDots: 3,
                        fontSize: Constants.normalFontSize - 3,
                        color: Constants.iLight,
                      ),
                    ]),
                SizedBox(height: 35.0),
                Text(
                  gameStateRepo.getCurrentQuestion().getQuestion().i18n,
                  style: TextStyle(color: Constants.iBlue.withOpacity(0.7), fontSize: Constants.normalFontSize, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 45.0),
                Text(
                  gameStateRepo.canVoteBlank
                      ? gameStateRepo.getAmountOfCurrentVotes().toString() + '/' + (gameStateRepo.getPlayers().length - 1).toString() + ' players have voted'.i18n
                      : gameStateRepo.getAmountOfCurrentVotes().toString() + '/' + gameStateRepo.getPlayers().length.toString() + ' players have voted'.i18n,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Constants.iLight, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  gameStateRepo.questionsLeft().toString() + " questions remaining".i18n,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Constants.iLight, fontSize: Constants.smallFontSize - 2, fontWeight: FontWeight.w300),
                ),
                SizedBox(height: 50.0),
                PassScreenButton(
                  title: "Vote!".i18n,
                  titleStyle: TextStyle(color: allPlayersVoted() ? Constants.iLight : Constants.iWhite, fontSize: Constants.normalFontSize - 3, fontWeight: FontWeight.w500),
                  subtitle: allPlayersVoted() ? "All players voted".i18n : "New vote for this round".i18n,
                  subtitleStyle: TextStyle(color: Constants.iLight, fontSize: Constants.smallFontSize - 2, fontWeight: FontWeight.w300),
                  iconCard: allPlayersVoted()
                      ? IconCard(
                          Icons.check_circle_outline,
                          Constants.iGrey.withOpacity(0.1),
                          Constants.iLight.withOpacity(0.5),
                          35,
                        )
                      : IconCard(
                          Icons.check_circle_outline,
                          Constants.iGrey.withOpacity(0.1),
                          Constants.iBlue,
                          35,
                        ),
                  onTap: () {
                    allPlayersVoted()
                        ? null
                        : Navigator.push(
                            context,
                            SlidePageRoute(
                              fromPage: widget,
                              toPage: PartyVoteScreen(),
                            ));
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                PassScreenButton(
                  title: "Add question".i18n,
                  subtitle: "Want to ask a question? Submit it here!".i18n,
                  titleStyle: TextStyle(color: allPlayersVoted() ? Constants.iLight : Constants.iWhite, fontSize: Constants.normalFontSize - 3, fontWeight: FontWeight.w500),
                  subtitleStyle: TextStyle(color: Constants.iLight, fontSize: Constants.smallFontSize - 2, fontWeight: FontWeight.w300),
                  iconCard: IconCard(
                    Icons.library_add_outlined,
                    Constants.iGrey.withOpacity(0.1),
                    Constants.iBlue,
                    35,
                  ),
                  onTap: () {
                    Popup.submitQuestionOfflinePopup(context);
                  },
                ),
              ],
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
        textStyle: TextStyle(color: Constants.iLight, fontSize: 18, fontWeight: FontWeight.w500),
        sliderButtonContent: Icon(FontAwesomeIcons.angleDoubleRight),
        iconColor: Constants.iDarkGrey,
        onConfirmation: () {
          _moveToResults(true);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
