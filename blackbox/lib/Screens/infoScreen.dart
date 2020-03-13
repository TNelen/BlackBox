ListView(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(25.0),
                        children: [
                          Text(
                            'Start Game',
                            style: new TextStyle(
                              color: Constants.colors[Constants.colorindex],
                              fontSize: 25.0,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Press the ready button to ready up.' +
                                '\n' +
                                'When all players are ready, the button on the bottom becomes the start button, press start to begin the game.',
                            style: new TextStyle(
                              color: Constants.iWhite,
                              fontSize: 18.0,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Voting',
                            style: new TextStyle(
                              color: Constants.colors[Constants.colorindex],
                              fontSize: 25.0,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Vote on a group member.' +
                                '\n' +
                                'Once a vote is submitted, it can not be changed.' +
                                '\n' +
                                'You have 2 minutes to vote for a question.' +
                                '\n' +
                                '\n' +
                                'Due to database issues, 2 members voting at exact the same time can cause a vote to be lost.',
                            style: new TextStyle(
                              color: Constants.iWhite,
                              fontSize: 18.0,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Collecting results',
                            style: new TextStyle(
                              color: Constants.colors[Constants.colorindex],
                              fontSize: 25.0,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'After you have voted you will enter a collecting results waiting screen.' +
                                '\n' +
                                'It shows the number of people that still have to vote.' +
                                '\n' +
                                'The admin wil see a countdown timer. It shows the time there is left for the members to vote.' +
                                '\n' +
                                'When this time is elapsed the players go to the results screen, no matter how many people still have to vote.' +
                                '\n' +
                                '',
                            style: new TextStyle(
                              color: Constants.iWhite,
                              fontSize: 18.0,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Questions',
                            style: new TextStyle(
                              color: Constants.colors[Constants.colorindex],
                              fontSize: 25.0,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Questions are generated in a random order.' +
                                '\n' +
                                'The category of the questions is chosen on group creation.',
                            style: new TextStyle(
                              color: Constants.iWhite,
                              fontSize: 18.0,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Leave',
                            style: new TextStyle(
                              color: Constants.colors[Constants.colorindex],
                              fontSize: 25.0,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Leave a running game by clicking on the leave in the top right corner.' +
                                '\n' +
                                'Please do not close the app before leaving an active game.',
                            style: new TextStyle(
                              color: Constants.iWhite,
                              fontSize: 18.0,
                            ),
                          ),
                          Text(
                            'If there are no more players in a group, the group is deleted',
                            style: new TextStyle(
                              color: Constants.iWhite,
                              fontSize: 18.0,
                            ),
                          ),
                          SizedBox(height: 80),
                        ],
                      )