import 'package:flutter/material.dart';
import '../main.dart';
import '../DataContainers/GroupData.dart';
import '../Constants.dart';
import 'QuestionScreen.dart';
import '../Interfaces/Database.dart';
import '../Database/FirebaseStream.dart';
import '../DataContainers/Question.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'GameScreen.dart';

class ResultScreen extends StatefulWidget {
  Database _database;
  GroupData groupData;
  String code;
  String currentQuestion;
  String currentQuestionString;

  ResultScreen(Database db, GroupData groupData, String code,
      String currentQuestion, String currentQuestionString) {
    this._database = db;
    this.groupData = groupData;
    this.code = code;
    this.currentQuestion = currentQuestion;
    this.currentQuestionString = currentQuestionString;
  }

  @override
  ResultScreenState createState() => ResultScreenState(
      _database, groupData, code, currentQuestion, currentQuestionString);
}

class ResultScreenState extends State<ResultScreen> {
  Database _database;
  GroupData groupData;
  String code;
  String currentQuestion;
  String currentQuestionString;
  FirebaseStream stream;
  bool joined = false;
  bool _loadingInProgress;

  ResultScreenState(Database db, GroupData groupData, String code,
      String currentQuestion, String currentQuestionString) {
    this._database = db;
    this.groupData = groupData;
    this.code = code;
    this.currentQuestion = currentQuestion;
    this.currentQuestionString = currentQuestionString;
    this.stream = new FirebaseStream(code);
  }

  int currentpage = 2;

  final controller = PageController(
    initialPage: 0,
    keepPage: false,
    viewportFraction: 0.85,
  );

  @override
  dispose() {
    controller.dispose();
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  @override
  void initState() {
    groupData = null;
    super.initState();
    _loadingInProgress = true;
    FirebaseStream(code).groupData.listen((_onGroupDataUpdate) {}, onDone: () {
      print("Task Done");
      _loadingInProgress = false;
    }, onError: (error) {
      print("Some Error");
    });

    BackButtonInterceptor.add(myInterceptor);
  }

  bool myInterceptor(bool stopDefaultButtonEvent) {
    print("BACK BUTTON!"); // Do some stuff.
    return true;
  }

  void getRandomNexQuestion() async {
    groupData.setNextQuestion(
        await _database.getRandomQuestion(groupData, Category.Any),
        Constants.getUserData());
  }

  @override
  Widget _buildBody(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return StreamBuilder(
        stream: stream.groupData,
        builder: (BuildContext context, AsyncSnapshot<GroupData> snapshot) {
          groupData = snapshot.data;
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          if (!snapshot.hasData) {
            return new Center(child: new CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            print(groupData.getNumVotes());

            if (currentQuestion == groupData.getQuestionID()) {
              if (groupData.getAdminID() == Constants.getUserID()) {
                if (groupData.getNumVotes() == groupData.getNumPlaying()) {
                  getRandomNexQuestion();
                  print('admin set next question');
                  print(groupData.getQuestionID());

                  print('currentQuestion ID = ' + currentQuestion);
                }
              }
              return new WillPopScope(
                  onWillPop: () async => false,
                  child: MaterialApp(
                    debugShowCheckedModeBanner: false,
                    theme: new ThemeData(scaffoldBackgroundColor: Constants.iBlack),
                    home: Scaffold(
                      body: Center(
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: 'Collecting votes...',
                            style: TextStyle(color: Constants.iWhite, fontSize: 30),
                          ),
                        ),
                      ),
                    ),
                  ));
            }
          }

          final winner = Hero(
            tag: 'submit',
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 30),
              padding: EdgeInsets.only(top: height / 10, bottom: height / 10),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                color: Constants.iDarkGrey,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            currentQuestionString,
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                                color: Constants.iAccent,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 30),
                          Text(
                            'WINNER',
                            style: new TextStyle(
                                color: Constants.iWhite,
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 25),
                          Text(
                            groupData.getWinner(),
                            style: new TextStyle(
                                color: Constants.iWhite,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );

          final top3 = Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 30),
            padding: EdgeInsets.only(top: height / 10, bottom: height / 10),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              color: Constants.iDarkGrey,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'TOP 3',
                          style: new TextStyle(
                              color: Constants.iAccent,
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 40),

                        Text(
                          '1. ' +
                              groupData.getTopThree('previous')[0] +
                              '   ' +
                              groupData.getTopThree('previous')[3],
                          style: new TextStyle(
                              color: Constants.iWhite,
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),

                        Text(
                          '2. ' +
                              groupData.getTopThree('previous')[1] +
                              '   ' +
                              groupData.getTopThree('previous')[4],
                          style: new TextStyle(
                              color: Constants.iWhite,
                              fontSize: 20.0,
                              fontWeight: FontWeight.normal),
                        ),
                        SizedBox(height: 5),

                        Text(
                          '3. ' +
                              groupData.getTopThree('previous')[2] +
                              '   ' +
                              groupData.getTopThree('previous')[5],
                          style: new TextStyle(
                              color: Constants.iWhite,
                              fontSize: 20.0,
                              fontWeight: FontWeight.normal),
                        ),
                        SizedBox(height: 20),

                      ],
                    ),
                  ),
                ),
              ),
            ),
          );

          final alltime = Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 30),
            padding: EdgeInsets.only(top: height / 10, bottom: height / 10),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              color: Constants.iDarkGrey,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Alltime TOP 3',
                          style: new TextStyle(
                              color: Constants.iAccent,
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 40),

                        Text(
                          '1. ' +
                              groupData.getTopThree('alltime')[0] +
                              '   ' +
                              groupData.getTopThree('alltime')[3],
                          style: new TextStyle(
                              color: Constants.iWhite,
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),

                        Text(
                          '2. ' +
                              groupData.getTopThree('alltime')[1] +
                              '   ' +
                              groupData.getTopThree('alltime')[4],
                          style: new TextStyle(
                              color: Constants.iWhite,
                              fontSize: 20.0,
                              fontWeight: FontWeight.normal),
                        ),
                        SizedBox(height: 5),

                        Text(
                          '3. ' +
                              groupData.getTopThree('alltime')[2] +
                              '   ' +
                              groupData.getTopThree('alltime')[5],
                          style: new TextStyle(
                              color: Constants.iWhite,
                              fontSize: 20.0,
                              fontWeight: FontWeight.normal),
                        ),
                        SizedBox(height: 20),

                      ],
                    ),
                  ),
                ),
              ),
            ),
          );

          final nextButton = Hero(
            tag: 'button',
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 30),
              padding: EdgeInsets.only(top: height / 9.6, bottom: height / 9.6),
              child: Material(
                elevation: 0.0,
                borderRadius: BorderRadius.circular(16.0),
                color: Constants.iAccent,
                child: MaterialButton(
                  minWidth: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(20),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              QuestionScreen(_database, groupData, code),
                        ));
                  },
                  //change isplaying field in database for this group to TRUE
                  child: Text("Next Question",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 30).copyWith(
                          color: Constants.iWhite, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          );

          return MaterialApp(
            theme: new ThemeData(scaffoldBackgroundColor: Colors.black),
            home: Scaffold(
              appBar: AppBar(
                backgroundColor: Constants.iBlack,
                title: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  FlatButton(
                    onPressed: () {
                      groupData.removePlayingUser(Constants.getUserData());
                      _database.updateGroup(groupData);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                GameScreen(_database, code),
                          ));
                    },
                    child: Text(
                      "Leave",
                      style: TextStyle(fontSize: 20.0, color: Constants.iAccent),
                    ),
                  )
                ]),
              ),
              body: PageView(
                controller: controller,
                children: <Widget>[
                  winner,
                  top3,
                  alltime,
                  nextButton,
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: new ThemeData(
          scaffoldBackgroundColor: Constants.iBlack,
        ),
        home: Scaffold(
          body: _buildBody(context),
        ));
  }
}
