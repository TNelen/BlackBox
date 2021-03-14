import 'package:blackbox/Assets/questions.dart';
import 'package:blackbox/Models/OfflineGroupData.dart';
import 'package:blackbox/Screens/PartyQuestionScreen.dart';
import 'package:blackbox/Screens/animation/SlidePageRoute.dart';
import 'package:blackbox/Screens/widgets/toggle_button_card.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'popups/Popup.dart';
import '../Constants.dart';
import 'package:blackbox/translations/translations.i18n.dart';

import 'package:i18n_extension/i18n_widget.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class TopCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.lightBlueAccent[100].withOpacity(0.5);
    paint.style = PaintingStyle.fill; // Change this to fill

    var path = Path();

    path.moveTo(0, size.height * 0.24);
    path.quadraticBezierTo(size.width * 0.1, size.height * 0.27,
        size.width * 0.5, size.height * 0.27);
    path.quadraticBezierTo(size.width * 0.9, size.height * 0.27,
        size.width * 1.0, size.height * 0.33);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class BottomCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.lightBlueAccent[100].withOpacity(0.5);
    paint.style = PaintingStyle.fill; // Change this to fill

    var path = Path();

    path.moveTo(0, size.height * 0.8);
    path.quadraticBezierTo(size.width * 0.1, size.height * 0.86,
        size.width * 0.5, size.height * 0.86);
    path.quadraticBezierTo(size.width * 0.9, size.height * 0.86,
        size.width * 1.0, size.height * 0.9);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class SetPlayersScreen extends StatefulWidget {
  List<Category> selectedCategory = [];

  SetPlayersScreen(List<Category> selectedCategory) {
    this.selectedCategory = selectedCategory;
  }

  @override
  _SetPlayersScreenState createState() =>
      _SetPlayersScreenState(selectedCategory);
}

class _SetPlayersScreenState extends State<SetPlayersScreen> {
  List<Category> selectedCategory;
  List<String> players = [];
  QuestionList questionList;
  TextEditingController codeController = TextEditingController();

  _SetPlayersScreenState(List<Category> selectedCategory) {
    this.selectedCategory = selectedCategory;

    FirebaseAnalytics().logEvent(
        name: 'open_screen', parameters: {'screen_name': 'setPlayersScreen'});
  }

  bool canVoteBlank = false;

  @override
  Widget build(BuildContext context) {
    final tagsTextField = TagsTextField(
      autofocus: false,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10),
      enabled: true,
      constraintSuggestion: true,
      onSubmitted: (String str) {
        setState(() {
          players.add(str);
        });
      },
      textStyle: TextStyle(
          fontFamily: "roboto",
          fontSize: Constants.smallFontSize,
          color: Constants.iWhite),
      hintTextColor: Constants.iGrey,
      hintText: "Add player...".i18n,
      inputDecoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 3.0),
      ),
    );

    final playerPills = Tags(
      key: Key("1"),
      textField: tagsTextField,
      itemCount: players.length,
      itemBuilder: (index) {
        final item = players[index];

        return GestureDetector(
          child: ItemTags(
            key: Key(index.toString()),
            index: index,
            title: item,
            textActiveColor: Constants.iDarkGrey,
            pressEnabled: false,
            activeColor: Constants.categoryColors[index % 7],
            removeButton: ItemTagsRemoveButton(
              icon: Icons.clear,
              backgroundColor: Constants.categoryColors[index % 7],
              color: Constants.iDarkGrey,
              onRemoved: () {
                setState(() {
                  players.removeAt(index);
                });
                return true;
              },
            ),
          ),
        );
      },
    );

    final createButton = Hero(
      tag: 'tobutton',
      child: Padding(
        padding: EdgeInsets.only(left: 45, right: 45),
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(26.0),
          color: Constants.colors[Constants.colorindex],
          child: MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(26.0),
            ),
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
            onPressed: () {
              if (players.length != 0 && selectedCategory.length != 0) {
                canVoteBlank ? players.add("Blank".i18n) : null;
                questionList = QuestionList(selectedCategory);

                Map<String, dynamic> map = {
                  'code': 'New group',
                  'type': 'PartyCreated',
                  'can_vote_blank': canVoteBlank,
                };

                // General game action log
                FirebaseAnalytics()
                    .logEvent(name: 'game_action', parameters: map);

                // Only logged here
                FirebaseAnalytics()
                    .logEvent(name: 'party_created', parameters: map);

                OfflineGroupData offlineGroupData =
                    OfflineGroupData(players, questionList, canVoteBlank);

                Navigator.push(
                    context,
                    SlidePageRoute(
                        fromPage: widget,
                        toPage: PartyQuestionScreen(offlineGroupData)));
              } else {
                Popup.makePopup(context, "Woops!".i18n,
                    "There should be at least one player!".i18n);
              }
            },
            child: Text("Start".i18n,
                textAlign: TextAlign.center,
                style: TextStyle(
                        fontFamily: "roboto",
                        fontSize: Constants.actionbuttonFontSize)
                    .copyWith(
                        color: Constants.iDarkGrey,
                        fontWeight: FontWeight.bold)),
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
        title: 'BlackBox',
        theme: ThemeData(scaffoldBackgroundColor: Constants.iBlack),
        home: I18n(
            child: Scaffold(
          resizeToAvoidBottomInset: false,
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
            child: Stack(fit: StackFit.expand, children: <Widget>[
              CustomPaint(
                painter: TopCurvePainter(),
              ),
              CustomPaint(
                painter: BottomCurvePainter(),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Settings'.i18n,
                        style: TextStyle(
                            fontSize: 20,
                            color: Constants.iWhite,
                            fontWeight: FontWeight.w300),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: ToggleButtonCard(
                      'Blank vote'.i18n,
                      canVoteBlank,
                      onToggle: (bool newValue) => canVoteBlank = newValue,
                      textStyle: TextStyle(
                          fontSize: Constants.smallFontSize,
                          color: Constants.iDarkGrey,
                          fontWeight: FontWeight.w300),
                      color: Constants.iWhite,
                    ),
                  ),
                  SizedBox(
                    height: 70,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Players'.i18n,
                        style: TextStyle(
                            fontSize: 20,
                            color: Constants.iWhite,
                            fontWeight: FontWeight.w300),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: playerPills,
                  ),
                  SizedBox(
                    height: 60.0,
                  ),
                ],
              ),
            ]),
          ),
        )));
  }
}
