import 'package:blackbox/DataContainers/GroupData.dart';
import 'package:blackbox/Interfaces/Database.dart';
import 'package:flutter/material.dart';
import '../../Constants.dart';
import '../Popup.dart';

class WaitScreen {
  static waitScreen(BuildContext context, Database database,
      GroupData groupData, int _timeleft) {
    int remainingVotes = groupData.getNumPlaying() - groupData.getNumVotes();

    String remainingVotesText = ' person';

    if (remainingVotes != 1) {
      remainingVotesText += 's';
    }
    remainingVotesText += ' remaining';

    int remainingQuestions = groupData.getQuestionList().length + 1;

    String remainingQuestionsText = ' question';

    if (remainingQuestions != 1) {
      remainingQuestionsText += 's';
    }

    remainingQuestionsText += ' remaining';

    final submitquestionbutton = FlatButton(
      onPressed: () {
        Popup.submitQuestionIngamePopup(context, database, groupData);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.library_add,
            color: Constants.iWhite,
            size: 20,
          ),
          SizedBox(
            width: 10,
          ),
          Text("Submit Question",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15).copyWith(
                color: Constants.iWhite,
              )),
        ],
      ),
    );

    final endGameButton = FlatButton(
        color: Constants.iBlack,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28.0),
        ),
        onPressed: () {
          Popup.confirmEndGame(context, database, groupData);
        },
        splashColor: Constants.colors[Constants.colorindex],
        child: Container(
            child: Row(children: [
          Text(
            "End Game",
            style: TextStyle(
                color: Constants.colors[Constants.colorindex],
                fontSize: 20,
                fontWeight: FontWeight.w400),
          ),
          SizedBox(
            width: 5,
          ),
          Icon(Icons.exit_to_app,
              size: 20, color: Constants.colors[Constants.colorindex])
        ])));

    return new WillPopScope(
        onWillPop: () async => false,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: new ThemeData(scaffoldBackgroundColor: Constants.iBlack),
          home: Scaffold(
            appBar: AppBar(
                backgroundColor: Constants.iBlack,
                title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      groupData.getAdminID() == Constants.getUserID()
                          ? endGameButton
                          : SizedBox(
                              height: 0.1,
                            ),
                    ])),
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: 'Collecting votes...',
                      style: TextStyle(
                          color: Constants.iWhite,
                          fontSize: 35,
                          fontWeight: FontWeight.w300),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    remainingVotes.toString() + remainingVotesText,
                    style: TextStyle(
                        fontSize: 25,
                        color: Constants.colors[Constants.colorindex]),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    remainingQuestions.toString() + remainingQuestionsText,
                    style: TextStyle(fontSize: 20, color: Constants.iWhite),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  groupData.getAdminID() == Constants.getUserID()
                      ? Text(
                          'Time left for voting',
                          style:
                              TextStyle(fontSize: 25, color: Constants.iWhite),
                        )
                      : SizedBox(
                          height: 0.1,
                        ),
                  SizedBox(
                    height: 12,
                  ),
                  groupData.getAdminID() == Constants.getUserID()
                      ? Text(
                          _timeleft > 69
                              ? '1:' + (_timeleft - 60).toString()
                              : _timeleft > 60
                                  ? '1:0' + (_timeleft - 60).toString()
                                  : _timeleft.toString() + 's',
                          style: TextStyle(
                              fontSize: 25,
                              color: Constants.colors[Constants.colorindex]),
                        )
                      : SizedBox(
                          height: 0.1,
                        ),
                  submitquestionbutton,
                ])),
          ),
        ));
  }
}
