import 'package:blackbox/Models/OfflineGroupData.dart';
import 'package:blackbox/Screens/animation/ScaleDownPageRoute.dart';
import 'package:blackbox/Screens/popups/Popup.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:blackbox/translations/gameScreens.i18n.dart';

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
    String removedPlayer = "";
    int removedIndex = null;

    final playerlist = Scrollbar(
        child: ListView.separated(
            shrinkWrap: true,
            separatorBuilder: (context, index) {
              if (widget._groupData.players[index] == "Blank")
                return Container();

              return Divider(
                indent: 40,
                endIndent: 40,
                color: Constants.iLight,
              );
            },
            itemCount: widget._groupData.players.length,
            itemBuilder: (context, index) {
              if (widget._groupData.players[index] == "Blank")
                return Container();

              return Dismissible(
                  background: Container(),
                  secondaryBackground: Container(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                      child: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  key: Key(widget._groupData.players[index]),
                  child: Center(
                    child: Text(
                      widget._groupData.players[index],
                      style: TextStyle(
                        color: Constants.iWhite,
                        fontSize: Constants.normalFontSize,
                        fontWeight: FontWeight.w300,
                        fontFamily: "atarian",
                      ),
                    ),
                  ),
                  confirmDismiss: (direction) async {
                    // Check whether or not at least one player remains

                    int numPlayers = widget._groupData.players.length;
                    if (widget._groupData.canVoteBlank) numPlayers--;

                    return numPlayers >= 1;
                  },
                  onDismissed: (direction) {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(
                        'Player deleted.'.i18n,
                        style: TextStyle(
                            color: Constants.iWhite,
                            fontSize: Constants.miniFontSize,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                      duration: Duration(seconds: 3),
                      backgroundColor: Constants.iDarkGrey,
                      action: SnackBarAction(
                        label: 'Undo'.i18n,
                        textColor: Constants.colors[Constants.colorindex],
                        onPressed: () {
                          setState(() => widget._groupData.players
                              .insert(removedIndex, removedPlayer));
                        },
                      ),
                    ));
                    // Remove the item from the data source.
                    setState(() {
                      removedPlayer = widget._groupData.players[index];
                      removedIndex = index;
                      widget._groupData.players.removeAt(index);
                    });
                  });
            }));

    TextEditingController playerNameController = TextEditingController();

    final namefield = Theme(
      data: ThemeData(
        primaryColor: Constants.colors[Constants.colorindex],
        primaryColorDark: Constants.colors[Constants.colorindex],
      ),
      child: TextField(
        obscureText: false,
        keyboardType: TextInputType.text,
        autocorrect: false,
        maxLength: 15,
        maxLines: 1,
        controller: playerNameController,
        style: TextStyle(
            fontFamily: "atarian",
            fontSize: Constants.smallFontSize,
            color: Constants.iWhite),
        decoration: InputDecoration(
            focusColor: Constants.colors[Constants.colorindex],
            hoverColor: Constants.colors[Constants.colorindex],
            contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
            fillColor: Constants.iBlack,
            filled: true,
            hintText: "Start typing here...".i18n,
            hintStyle: TextStyle(
                fontFamily: "atarian",
                fontSize: Constants.smallFontSize,
                color: Constants.iGrey),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(16.0))),
      ),
    );

    final addPlayerButton = FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(26.0),
      ),
      padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              // return object of type Dialog
              return AlertDialog(
                backgroundColor: Constants.iBlack,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16.0))),
                title: Text(
                  'Player Name'.i18n,
                  style: TextStyle(
                      fontFamily: "atarian",
                      color: Constants.colors[Constants.colorindex],
                      fontSize: Constants.subtitleFontSize),
                ),
                content: Container(
                    height: 150,
                    child: Column(children: [
                      SizedBox(height: 25),
                      namefield,
                    ])),
                actions: <Widget>[
                  // usually buttons at the bottom of the dialog
                  FlatButton(
                    child: Text(
                      "Cancel".i18n,
                      style: TextStyle(
                          fontFamily: "atarian",
                          color: Constants.colors[Constants.colorindex],
                          fontSize: Constants.actionbuttonFontSize,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),

                  FlatButton(
                    child: Text(
                      "Add".i18n,
                      style: TextStyle(
                          fontFamily: "atarian",
                          color: Constants.colors[Constants.colorindex],
                          fontSize: Constants.actionbuttonFontSize,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      String name = playerNameController.text;
                      //print('-' + question+ '-');
                      if (name.length < 2) {
                        Popup.makePopup(context, 'Whoops!'.i18n,
                            'Player name is too short'.i18n);
                      } else if (widget._groupData.players.contains(
                          name[0].toUpperCase() + name.substring(1))) {
                        Popup.makePopup(context, 'Whoops!'.i18n,
                            'This player already exists'.i18n);
                      } else {
                        FirebaseAnalytics().logEvent(
                            name: 'action_performed',
                            parameters: {'action_name': 'addPlayer'});
                        Navigator.pop(context);

                        setState(() => widget._groupData.players
                            .add(name[0].toUpperCase() + name.substring(1)));
                      }
                    },
                  ),
                ],
              );
            });
      },
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          "Add player".i18n,
          style: TextStyle(
            color: Constants.colors[Constants.colorindex],
            fontSize: Constants.smallFontSize,
            fontWeight: FontWeight.w300,
            fontFamily: "atarian",
          ),
        ),
        Icon(Icons.add, color: Constants.colors[Constants.colorindex]),
      ]),
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
            child: Text("Continue".i18n,
                textAlign: TextAlign.center,
                style: TextStyle(
                        fontFamily: "atarian",
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
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Constants.iBlack,
            title:
                Row(mainAxisAlignment: MainAxisAlignment.start, children: []),
          ),
          body: Center(
            child: Container(
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
                    top: 36.0, bottom: 36, left: 63, right: 63),
                children: <Widget>[
                  Text(
                    'who\'s playing?'.i18n,
                    style: TextStyle(
                      color: Constants.iWhite,
                      fontSize: Constants.titleFontSize,
                      fontWeight: FontWeight.w300,
                      fontFamily: "atarian",
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.people_outline,
                        color: Constants.colors[Constants.colorindex],
                        size: 30,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        'Players'.i18n,
                        style: TextStyle(
                          color: Constants.colors[Constants.colorindex],
                          fontSize: Constants.normalFontSize,
                          fontFamily: "atarian",
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        '(' + widget._groupData.players.length.toString() + ')',
                        style: TextStyle(
                          color: Constants.colors[Constants.colorindex],
                          fontSize: Constants.smallFontSize,
                          fontFamily: "atarian",
                        ),
                      ),
                      SizedBox(
                        width: 25,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  LimitedBox(
                    maxHeight: 250,
                    child: playerlist,
                  ),
                  addPlayerButton,

                  //),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'swipe to remove player'.i18n,
                    style: TextStyle(
                      color: Constants.colors[Constants.colorindex],
                      fontSize: Constants.miniFontSize,
                      fontFamily: "atarian",
                    ),
                  ),
                  SizedBox(
                    height: 60.0,
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: createButton,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        )));
  }
}
