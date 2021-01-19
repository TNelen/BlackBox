import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:blackbox/Constants.dart';
import 'package:blackbox/translations/rules_column.i18n.dart';

class RulesColumn extends StatefulWidget {
  
  final List<String> titles = <String>[
    'Party Mode'.i18n,
    'Create Game'.i18n,
    'Join Game'.i18n,
    'Game settings'.i18n,
  ];

  final List<String> descriptions = <String>[
    // Party Mode
    'Create a local game.'.i18n +
        '\n' +
        'All players vote one by one. After you have voted, pass the phone to the next player'.i18n +
        '\n' +
        'After everyone has voted, go to the results, and a new round starts.'.i18n,

    // New game
    'Create a new game and invite your friends by sharing the group code'.i18n,

    // Join game
    'Join a game with the 5 character group code'.i18n,

        // Game settings
    "The game creator can enable or disable 'blanco vote'. This is ability for the player to vote blanco".i18n +
    '\n' +
    "The game creator can enable or disable 'vote on self'. This controls whether the player is able to cast a vote on himself".i18n +
    '\n' +
    'These settings are set in the beginning of the game and cannot be changed during the game'.i18n


  ];
  
  @override
  State<StatefulWidget> createState() {
    return _RulesColumnState();
  }
}

class _RulesColumnState extends State<RulesColumn> {

  int _openIndex = -1;  // Keeps track of the opened tile. Will be -1 when all are closed


  @override
  Widget build(BuildContext context) {
    List<Widget> infoTiles = List<Widget>();
    int i = 0;
    while(i < widget.titles.length && i < widget.descriptions.length)
    {
      int index = i;
      infoTiles.add(Column(
        mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
        Text(
            widget.titles[i],
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Constants.colors[Constants.colorindex],
              fontSize: Constants.actionbuttonFontSize,
            ),
          ),

                Text(
                  widget.descriptions[i],
                  style: TextStyle(
                    color: Constants.iWhite,
                    fontSize: Constants.smallFontSize,
                  ),
                ),
                SizedBox(height: 15),
              ])
            );

      i++;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: infoTiles,
    );
  }
}
