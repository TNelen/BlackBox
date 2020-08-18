import 'package:blackbox/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:blackbox/Constants.dart';

class RulesList {
  static Widget getRules() {
    return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExpansionTile(
          title: Text(
            "New Game",
            style: new TextStyle(
              color: Constants.colors[Constants.colorindex],
              fontSize: 30.0,
            ),
          ),
          backgroundColor: Constants.iBlack,
          children: [
            Column(
              children: [
                Text(
                  'Create a new game and invite your friends by sharing the group code.' + '\n' + 'Or join a game by entering the group code.',
                  style: new TextStyle(
                    color: Constants.iWhite,
                    fontSize: 25.0,
                  ),
                ),
                SizedBox(height: 10),
              ],
            )
          ],
        ),
        ExpansionTile(
          title: Text(
            "Game settings",
            style: new TextStyle(
              color: Constants.colors[Constants.colorindex],
              fontSize: 30.0,
            ),
          ),
          backgroundColor: Constants.iBlack,
          children: [
            Column(
              children: [
                Text(
                  "Game creator can enable or disable 'blanco vote'. The ability for the player to vote blanco" +
                      '\n' +
                      "Game creator can enable or diasble 'vote on self', this controls whether the player is able to cast a vote on himself" +
                      '\n' +
                      'These settings are set in the beginning of the game and cannot be changed during the game',
                  style: new TextStyle(
                    color: Constants.iWhite,
                    fontSize: 25.0,
                  ),
                ),
                SizedBox(height: 10),
              ],
            )
          ],
        ),
        ExpansionTile(
          title: Text(
            "Start Game",
            style: new TextStyle(
              color: Constants.colors[Constants.colorindex],
              fontSize: 30.0,
            ),
          ),
          backgroundColor: Constants.iBlack,
          children: [
            Column(
              children: [
                Text(
                  'When you join or create a game you enter the game lobby.' +
                      '\n' +
                      'Press the ready button to ready up.' +
                      '\n' +
                      'When all players are ready, the ready button on the bottom becomes the start button, press start to begin the game.' +
                      '\n' +
                      'Each player name has an indicator, indicating whether the layer is ready or not.',
                  style: new TextStyle(
                    color: Constants.iWhite,
                    fontSize: 25.0,
                  ),
                ),
                SizedBox(height: 10),
              ],
            )
          ],
        ),
        ExpansionTile(
          title: Text(
            "Voting",
            style: new TextStyle(
              color: Constants.colors[Constants.colorindex],
              fontSize: 30.0,
            ),
          ),
          backgroundColor: Constants.iBlack,
          children: [
            Column(
              children: [
                Text(
                  'Vote on a group member.' + '\n' + 'Once a vote is submitted, it can not be changed.',
                  style: new TextStyle(
                    color: Constants.iWhite,
                    fontSize: 25.0,
                  ),
                ),
                SizedBox(height: 10),
              ],
            )
          ],
        ),
        ExpansionTile(
          title: Text(
            "Collecting results",
            style: new TextStyle(
              color: Constants.colors[Constants.colorindex],
              fontSize: 30.0,
            ),
          ),
          backgroundColor: Constants.iBlack,
          children: [
            Column(
              children: [
                Text(
                  'After you have voted you will enter a collecting results waiting screen.' +
                      '\n' +
                      'It shows the number of people that still have to vote.' +
                      '\n' +
                      'The group creator wil see a countdown timer. It shows the time there is left for the members to vote.' +
                      '\n' +
                      'When this time is elapsed the players go to the results screen, no matter how many people still have to vote.' +
                      '\n' +
                      '',
                  style: new TextStyle(
                    color: Constants.iWhite,
                    fontSize: 25.0,
                  ),
                ),
                SizedBox(height: 10),
              ],
            )
          ],
        ),
        ExpansionTile(
          title: Text(
            "Questions",
            style: new TextStyle(
              color: Constants.colors[Constants.colorindex],
              fontSize: 30.0,
            ),
          ),
          backgroundColor: Constants.iBlack,
          children: [
            Column(
              children: [
                Text(
                  'Questions are generated in a random order.' +
                      '\n' +
                      'You can submit own question ideas ingame. These will be inserted in the queue of questions.' +
                      '\n' +
                      'All players have the ability to rate the questions, giving us feedback about the questions helps us inproving the game.',
                  style: new TextStyle(
                    color: Constants.iWhite,
                    fontSize: 25.0,
                  ),
                ),
                SizedBox(height: 10),
              ],
            )
          ],
        ),
        ExpansionTile(
          title: Text(
            "Leave",
            style: new TextStyle(
              color: Constants.colors[Constants.colorindex],
              fontSize: 30.0,
            ),
          ),
          backgroundColor: Constants.iBlack,
          children: [
            Column(
              children: [
                Text(
                  'Leave a running game by clicking on the leave in the top right corner.' + '\n' + 'Please do not close the app before leaving an active game.',
                  style: new TextStyle(
                    color: Constants.iWhite,
                    fontSize: 25.0,
                  ),
                ),
                Text(
                  'If there are no more players in a group, the group is deleted',
                  style: new TextStyle(
                    color: Constants.iWhite,
                    fontSize: 25.0,
                  ),
                ),
                SizedBox(height: 10),
              ],
            )
          ],
        ),
        ExpansionTile(
          title: Text(
            "End game",
            style: new TextStyle(
              color: Constants.colors[Constants.colorindex],
              fontSize: 30.0,
            ),
          ),
          backgroundColor: Constants.iBlack,
          children: [
            Column(
              children: [
                Text(
                  'When all questions are played the game ends and a overview of all questions and results is shown.' +
                      '\n' +
                      'The group leader has the ability to end the game prematurely, after the next questions the results are shown.',
                  style: new TextStyle(
                    color: Constants.iWhite,
                    fontSize: 25.0,
                  ),
                ),
                SizedBox(height: 10),
              ],
            )
          ],
        ),
      ],
    ));
  }
}
