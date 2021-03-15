import 'package:blackbox/Models/OfflineGroupData.dart';
import 'package:blackbox/Screens/animation/ScaleDownPageRoute.dart';
import 'package:blackbox/Screens/popups/Popup.dart';
import 'package:blackbox/Util/Curves.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:blackbox/translations/translations.i18n.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:i18n_extension/i18n_widget.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../Constants.dart';
import 'PassScreen.dart';

class EditPlayersScreen extends StatefulWidget {
  final OfflineGroupData _groupData;

  EditPlayersScreen(this._groupData);

  @override
  _EditPlayersScreenState createState() => _EditPlayersScreenState();
}

class _EditPlayersScreenState extends State<EditPlayersScreen> {
  TextEditingController codeController = TextEditingController();

  _SetPlayersScreenState() {
    FirebaseAnalytics().logEvent(
        name: 'open_screen', parameters: {'screen_name': 'editPlayersScreen'});
  }

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
          widget._groupData.players
              .add(str[0].toUpperCase() + str.substring(1));
        });
      },
      textStyle: TextStyle(
          fontFamily: "roboto",
          fontSize: Constants.smallFontSize,
          color: Constants.iWhite),
      hintTextColor: Constants.iGrey,
      hintText: "Add player...".i18n,
      inputDecoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 3.0),
      ),
    );

    final playerPills = Tags(
      key: Key("1"),
      textField: tagsTextField,
      itemCount: widget._groupData.players.length,
      itemBuilder: (index) {
        final item = widget._groupData.players[index];

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
                  widget._groupData.players.removeAt(index);
                });
                return true;
              },
            ),
          ),
        );
      },
    );

    final createButton = Card(
      elevation: 5.0,
      color: Constants.iLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0),
        // splashColor: Constants.iAccent,
        onTap: () {
          if (widget._groupData.players.length != 0) {
            Navigator.push(
                context,
                ScaleDownPageRoute(
                  fromPage: widget,
                  toPage: PassScreen(widget._groupData),
                ));
          } else {
            Popup.makePopup(context, "Woops!".i18n,
                "There should be at least one player!".i18n);
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
                    "Continue".i18n,
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
                    Expanded(
                        flex: 6,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
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
                                child: Row(children: [
                                  Text(
                                    'Blank vote'.i18n,
                                    style: TextStyle(
                                        fontSize: Constants.smallFontSize,
                                        color: Constants.iDarkGrey,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Switch(
                                    value: widget._groupData.canVoteBlank,
                                    onChanged: null,
                                    activeTrackColor: Constants.iLight,
                                    activeColor: Constants.iWhite,
                                  ),
                                ]),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 20, right: 20),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '(Can not be changed during the game)'.i18n,
                                    style: TextStyle(
                                        fontSize: Constants.miniFontSize,
                                        color: Constants.iDarkGrey,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ])),
                    Expanded(
                      flex: 11,
                      child: Column(children: [
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
                      ]),
                    ),
                    Flexible(
                        flex: 3,
                        child: Center(
                            child: Container(height: 60, child: createButton))),
                  ],
                ),
              ]),
            ),
          ),
        ));
  }
}
