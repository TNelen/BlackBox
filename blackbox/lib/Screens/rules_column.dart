import 'package:blackbox/Screens/widgets/better_expansion_tile.dart';
import 'package:blackbox/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:blackbox/Constants.dart';

class RulesColumn extends StatefulWidget {
  
  final List<String> titles = <String>[
    'New game',
    'Game settings',
    'Start game',
    'Voting',
    'Collecting results',
    'Questions',
    'Leave',
    'End game'
  ];

  final List<String> descriptions = <String>[
    // New game
    'Create a new game and invite your friends by sharing the group code.' + '\n' + 'Or join a game by entering the group code.',

    // Game settings
    "The game creator can enable or disable 'blanco vote'. This is ability for the player to vote blanco" +
    '\n' +
    "The game creator can enable or disable 'vote on self'. This controls whether the player is able to cast a vote on himself" +
    '\n' +
    'These settings are set in the beginning of the game and cannot be changed during the game',

    // Start game
    'When you join or create a game you enter the game lobby.' +
    '\n' +
    'Press the ready button to ready up.' +
    '\n' +
    'When all players are ready, the ready button on the bottom becomes the start button, press start to begin the game.' +
    '\n' +
    'Each player name has an indicator, indicating whether the player is ready or not.',

    // Voting
    'Vote on a group member.' + '\n' + 'Once a vote is submitted, it can not be changed.',

    // Collecting results
    'After you have voted you will enter a waiting screen.' +
    '\n' +
    'It shows the number of people that still have to vote.' +
    '\n' +
    'The group creator wil see a countdown timer. It shows the time there is left for the members to vote.' +
    '\n' +
    'When this time is elapsed the players go to the results screen, no matter how many people still have to vote.' +
    '\n' +
    '',

    // Questions
    'Questions are generated in a random order.' +
    '\n' +
    'You can submit own question ideas ingame. These will be inserted in the queue of questions.' +
    '\n' +
    'All players have the ability to rate the questions, giving us feedback about the questions helps us inproving the game.',

    // Leave
    'Leave a running game by clicking on the leave in the top right corner.' + '\n' + 'Please do not close the app before leaving an active game.',

    // End game
    'When all questions are played the game ends and a overview of all questions and results is shown.' +
    '\n' +
    'The group leader has the ability to end the game prematurely, after the next questions the results are shown.'
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
      _expansionKeys.add( new GlobalKey() );
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
            style: new TextStyle(
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
                  style: new TextStyle(
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
