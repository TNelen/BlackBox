import 'package:blackbox/Assets/questions.dart';
import 'package:blackbox/Repositories/gameStateRepository.dart';
import 'package:blackbox/Screens/CategoryScreen.dart';
import 'package:blackbox/Screens/PartyQuestionScreen.dart';
import 'package:blackbox/Screens/animation/SlidePageRoute.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../main.dart';
import 'animation/ScaleDownPageRoute.dart';
import 'popups/Popup.dart';
import '../Constants.dart';
import 'package:blackbox/translations/translations.i18n.dart';

class SetPlayersScreen extends StatefulWidget {
  List<Category> selectedCategory = [];

  SetPlayersScreen(List<Category> selectedCategory) {
    this.selectedCategory = selectedCategory;
  }

  @override
  _SetPlayersScreenState createState() => _SetPlayersScreenState(selectedCategory);
}

class _SetPlayersScreenState extends State<SetPlayersScreen> {
  List<Category> selectedCategory = List.empty(growable: true);
  List<String> players = List.empty(growable: true);
  TextEditingController nameController = TextEditingController();

  _SetPlayersScreenState(List<Category> selectedCategory) {
    this.selectedCategory = selectedCategory;

    FirebaseAnalytics.instance.logEvent(name: 'open_screen', parameters: {'screen_name': 'setPlayersScreen'});
  }

  bool canVoteBlank = false;

  final GameStateRepository gameStateRepo = getIt.get<GameStateRepository>();

  @override
  Widget build(BuildContext context) {
    final tagsTextField = TextField(
      controller: nameController,
      textAlign: TextAlign.center,
      onSubmitted: (String str) {
        setState(() {
          if (!players.contains(str[0].toUpperCase() + str.substring(1))) {
            players.add(str[0].toUpperCase() + str.substring(1));
            nameController.clear();
          }
        });
      },
      decoration: InputDecoration(
        hintStyle: TextStyle(color: Constants.iLight),
        hintText: "Click to add player...".i18n,
        border: InputBorder.none,
        counterStyle: TextStyle(color: Constants.iLight),
        contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 3.0),
      ),
      style: TextStyle(fontFamily: "atarian", fontSize: Constants.smallFontSize, color: Constants.iWhite),
      maxLength: 20,
    );

    final playerPills = Tags(
      itemCount: players.length,
      itemBuilder: (index) {
        return GestureDetector(
          child: ItemTags(
            borderRadius: BorderRadius.circular(15),
            padding: EdgeInsets.all(8),
            // key: Key(index.toString()),
            index: index,
            title: players[index],
            textStyle: TextStyle(color: Constants.black, fontSize: 20),
            textActiveColor: Constants.iDarkGrey,
            pressEnabled: false,
            activeColor: Constants.categoryColors[index % 7],
            removeButton: ItemTagsRemoveButton(
              icon: Icons.clear,
              size: 12,
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

    final createButton = MaterialButton(
        elevation: 5.0,
        color: Constants.iBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        onPressed: () {
          if (players.length > 1 && selectedCategory.length != 0) {
            canVoteBlank ? players.add("Blank") : null;
            QuestionList questionList = QuestionList(selectedCategory);

            Map<String, dynamic> map = {
              'code': 'New group',
              'type': 'PartyCreated',
              'can_vote_blank': canVoteBlank,
            };

            // General game action log
            FirebaseAnalytics.instance.logEvent(name: 'game_action', parameters: map);

            // Only logged here
            FirebaseAnalytics.instance.logEvent(name: 'party_created', parameters: map);

            gameStateRepo.startGame(players: players, questionList: questionList, canVoteBlank: canVoteBlank);

            Navigator.push(context, SlidePageRoute(fromPage: widget, toPage: PartyQuestionScreen()));
          } else {
            Popup.makePopup(context, "Woops!".i18n, "There should be at least two players!".i18n);
          }
        },
        child: Container(
            width: MediaQuery.of(context).size.width / 2.5,
            height: 50,
            child: Padding(
              padding: const EdgeInsets.only(top: 3, left: 3.0, right: 3, bottom: 3),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                Text(
                  'Start'.i18n,
                  style: TextStyle(fontFamily: "atarian", fontSize: Constants.smallFontSize, color: Constants.iWhite, fontWeight: FontWeight.w500),
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
            )));

    final bool showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;

    return Scaffold(
      backgroundColor: Constants.black.withOpacity(0.7),
      //resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        //padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            DelayedDisplay(
                delay: Duration(milliseconds: 200),
                slidingBeginOffset: const Offset(0.0, -0.1),
                child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                  SizedBox(
                    height: 45,
                  ),
                  Row(children: [
                    Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                ScaleDownPageRoute(
                                  fromPage: widget,
                                  toPage: CategoryScreen(
                                    showHelp: false,
                                    showList: true,
                                  ),
                                ));
                          },
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Icon(
                                  Icons.chevron_left,
                                  color: Constants.iLight,
                                  size: 35,
                                ),
                              ),
                            ],
                          ),
                        ),
                        flex: 1),
                    Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Settings'.i18n,
                          style: TextStyle(fontSize: 25, color: Constants.iWhite, fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                    Expanded(child: SizedBox(), flex: 1),
                  ]),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Row(children: [
                      MaterialButton(
                        splashColor: Colors.transparent,
                        onPressed: () {
                          setState(() {
                            canVoteBlank = !canVoteBlank;
                          });
                        },
                        child: Text(
                          'Blank vote'.i18n,
                          style: TextStyle(fontSize: Constants.smallFontSize, color: Constants.iLight, fontWeight: FontWeight.w400),
                        ),
                      ),
                      Switch(
                        value: canVoteBlank,
                        onChanged: (bool newValue) {
                          setState(() {
                            canVoteBlank = newValue;
                          });
                        },
                        activeTrackColor: Constants.iBlue,
                        activeColor: Constants.iWhite,
                        inactiveTrackColor: Constants.grey,
                      ),
                    ]),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                ])),
            DelayedDisplay(
              delay: Duration(milliseconds: 100),
              slidingBeginOffset: const Offset(0.0, -0.05),
              child: Container(
                height: MediaQuery.of(context).size.height - 120,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40.0),
                      topRight: Radius.circular(40.0),
                      bottomLeft: Radius.zero,
                      bottomRight: Radius.zero,
                    ),
                  ),
                  color: Constants.iDarkGrey,
                  child: Column(children: [
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Players'.i18n,
                          style: TextStyle(fontSize: 25, color: Constants.iWhite, fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: playerPills,
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: tagsTextField,
                    ),
                    SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                  ]),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: showFab ? createButton : SizedBox.shrink(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
