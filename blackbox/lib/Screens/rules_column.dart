import 'package:blackbox/Screens/widgets/better_expansion_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:blackbox/Constants.dart';

class RulesColumn extends StatefulWidget {
  
  final List<String> titles = <String>[
    'Create Game',
    'Join Game',
    'Party Mode',
    'Game settings',
  ];

  final List<String> descriptions = <String>[
    // New game
    'Create a new game and invite your friends by sharing the group code',

    // Join game
    'Join a game with the 5 character group code',

    // Party Mode
    'Create a local game.' +
    '\n' +
    'All players vote one by one. After you have voted, pass the phone to the next player' +
    '\n' +
    'After everyone has voted, go to the results, and a new round starts.',

        // Game settings
    "The game creator can enable or disable 'blanco vote'. This is ability for the player to vote blanco" +
    '\n' +
    "The game creator can enable or disable 'vote on self'. This controls whether the player is able to cast a vote on himself" +
    '\n' +
    'These settings are set in the beginning of the game and cannot be changed during the game',


  ];
  
  @override
  State<StatefulWidget> createState() {
    return _RulesColumnState();
  }
}

class _RulesColumnState extends State<RulesColumn> {

  int _openIndex = -1;  // Keeps track of the opened tile. Will be -1 when all are closed

  List<GlobalKey<BetterExpansionTileState>> _expansionKeys = List<GlobalKey<BetterExpansionTileState>>();

  @override
  void initState()
  {
    super.initState();
    int i = 0;
    while(i < widget.titles.length && i < widget.descriptions.length)
    {
      _expansionKeys.add( GlobalKey() );
      i++;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> infoTiles = List<Widget>();
    int i = 0;
    while(i < widget.titles.length && i < widget.descriptions.length && i < _expansionKeys.length)
    {
      int index = i;
      infoTiles.add(
        BetterExpansionTile(
          key: _expansionKeys[i],
          onTap: () {
            
            setState(() {
              // Close when opened, open when closed
              _openIndex = _openIndex == index ? -1 : index;
            });

            int tileIndex = 0;
            for (GlobalKey<BetterExpansionTileState> key in _expansionKeys)
            {
              key.currentState.setIsExpanded( tileIndex == _openIndex );
              tileIndex++;
            }
          },
          title: Text(
            widget.titles[i],
            style: TextStyle(
              color: Constants.colors[Constants.colorindex],
              fontSize: Constants.normalFontSize,
            ),
          ),
          backgroundColor: Colors.transparent,
          children: [
            Column(
              children: [
                Text(
                  widget.descriptions[i],
                  style: TextStyle(
                    color: Constants.iWhite,
                    fontSize: Constants.smallFontSize,
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ],
        ),
      );
      i++;
    }

    return Column(
      children: infoTiles,
    );
  }
}
