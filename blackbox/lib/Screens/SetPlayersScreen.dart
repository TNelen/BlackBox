import 'package:blackbox/Assets/questions.dart';
import 'package:blackbox/Models/OfflineGroupData.dart';
import 'package:blackbox/Screens/PartyQuestionScreen.dart';
import 'package:blackbox/Screens/animation/SlidePageRoute.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'CategoryScreen.dart';
import 'animation/ScaleDownPageRoute.dart';
import 'popups/Popup.dart';
import '../Constants.dart';
import 'package:blackbox/translations/translations.i18n.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
  List<Category> selectedCategory = [];
  List<String> players = [];
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
          players.add(str[0].toUpperCase() + str.substring(1));
        });
      },
      textStyle: TextStyle(
          fontFamily: "roboto",
          fontSize: Constants.smallFontSize,
          color: Constants.iLight),
      hintTextColor: Constants.iLight,
      hintText: "Start typing here...".i18n,
      inputDecoration: InputDecoration(
        border: InputBorder.none,
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
            padding: EdgeInsets.all(10),
            textActiveColor: Constants.iWhite,
            pressEnabled: false,
            activeColor: Constants.grey,
            removeButton: ItemTagsRemoveButton(
              icon: Icons.clear,
              size: 15,
              backgroundColor: Constants.iWhite.withOpacity(0.5),
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
        tag: "actionbutton",
        child: Card(
          elevation: 5.0,
          color: Constants.iAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12.0),
            // splashColor: Constants.iAccent,
            onTap: () {
              if (players.length != 0 && selectedCategory.length != 0) {
                canVoteBlank ? players.add("Blank".i18n) : null;
                QuestionList questionList = QuestionList(selectedCategory);

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
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Container(
                width: MediaQuery.of(context).size.width / 2,
                height: 30,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Start',
                        style: TextStyle(
                            fontFamily: "roboto",
                            fontSize: Constants.smallFontSize,
                            color: Constants.iWhite,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      FaIcon(
                        FontAwesomeIcons.chevronRight,
                        color: Constants.iWhite,
                      )
                    ]),
              ),
            ),
          ),
        ));

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
            // decoration: BoxDecoration(
            //   gradient: LinearGradient(
            //     begin: Alignment.topCenter,
            //     end: Alignment.bottomLeft,
            //     stops: [0.1, 1.0],
            //     colors: [
            //       Constants.gradient1,
            //       Constants.gradient2,
            //     ],
            //   ),
            // ),
            color: Constants.grey,

            child: Column(
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 25,
                ),
                Expanded(
                  flex: 3,
                  child: Card(
                    //elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35.0),
                    ),
                    color: Constants.iAccent.withOpacity(0.7),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 4,
                      width: MediaQuery.of(context).size.width - 30,
                      child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25),
                          child: Column(
                            children: [
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: IconButton(
                                      icon: FaIcon(
                                        FontAwesomeIcons.chevronLeft,
                                        color: Constants.iLight,
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            ScaleDownPageRoute(
                                              fromPage: widget,
                                              toPage: CategoryScreen(
                                                showHelp: false,
                                              ),
                                            ));
                                      })),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Settings'.i18n,
                                  style: TextStyle(
                                      fontSize: 30,
                                      color: Constants.iWhite,
                                      fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),

                              Text(
                                'Blank vote'.i18n,
                                style: TextStyle(
                                    fontSize: Constants.smallFontSize,
                                    color: Constants.iWhite,
                                    fontWeight: FontWeight.w300),
                              ),
                              SizedBox(
                                height: 15,
                              ),

                              // Here, default theme colors are used for activeBgColor, activeFgColor, inactiveBgColor and inactiveFgColor
                              ToggleSwitch(
                                initialLabelIndex: 0,
                                totalSwitches: 2,
                                minWidth: 100.0,
                                minHeight: 40.0,
                                fontSize: 16.0,
                                activeBgColor: [
                                  Constants.iWhite.withOpacity(0.8)
                                ],
                                activeFgColor: Constants.black,
                                inactiveBgColor:
                                    Constants.black.withOpacity(0.2),
                                inactiveFgColor:
                                    Constants.black.withOpacity(0.6),
                                labels: [
                                  'Enable',
                                  'Disable',
                                ],
                                onToggle: (index) {
                                  print('switched to: $index');
                                  canVoteBlank = index == 0;
                                },
                              ),
                            ],
                          )),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 20,
                ),
                Expanded(
                  flex: 5,
                  child: Card(
                    //elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35.0),
                    ),
                    color: Constants.black.withOpacity(0.7),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 4,
                      width: MediaQuery.of(context).size.width - 30,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            FaIcon(
                              FontAwesomeIcons.users,
                              color: Constants.grey,
                              size: 60,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Players'.i18n,
                                style: TextStyle(
                                    fontSize: 30,
                                    color: Constants.iWhite,
                                    fontWeight: FontWeight.w500),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              child: playerPills,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 120,
                ),
              ],
            ),
          ),
          floatingActionButton: createButton,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        )));
  }
}
