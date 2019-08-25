import 'package:blackbox/Database/GoogleUserHandler.dart';
import 'package:flutter/material.dart';
import '../Constants.dart';
import 'CreateGameScreen.dart';
import 'JoinGameScreen.dart';
import '../Interfaces/Database.dart';
import 'package:blackbox/DataContainers/UserData.dart';
import 'package:blackbox/DataContainers/GroupData.dart';
import 'package:blackbox/DataContainers/Question.dart';

class HomeScreen extends StatefulWidget {
  Database database;

  HomeScreen(Database db) {
    database = db;
    db.openConnection();
  }

  @override
  _HomeScreenState createState() => _HomeScreenState(database);

  HomePage(Database db) {
    this.database = db;
  }
}

enum PopupNew { create, join }

class _HomeScreenState extends State<HomeScreen> {
  Database database;

  _HomeScreenState(Database db) {
    this.database = db;

    /// Log a user in and update variables accordingly

    if (Constants.getUserID() == "id2" || Constants.getUserID() == "" ) {
      ///check if user isn't loged in via google already when returning to homescreen
      try {
        GoogleUserHandler guh = new GoogleUserHandler();
        guh.handleSignIn().then((user) {
          /// Log the retreived user in and update the data in the database
          Constants.setUserData(user);
          database.updateUser(user);

          _test();

        });
      } catch (e) {
        print(e.toString());
      }
    }


    /* Example on how to add questions
    /// Duplicates cannot be added so running this code twice is not a problem
    List<String> questions = new List<String>();
    questions.add("Who will be the first person to have a hangover (again)?");
    questions.add("Who is the biggest beer fan?");
    _addQuestions( questions );
    */
  }


  @Deprecated('For async testing only. Must be deleted before release!')
  void _test() async
  {
    await database.updateQuestion( new Question.add("Who would eat anything?", Category.Community) );
  }


  @Deprecated('Must be deleted before release!')
  void _addQuestions( List<String> questions ) async
  {
    for (String q in questions)
    {
        await database.updateQuestion( new Question.addDefault(q) );
    }
  }

  Widget _buildBottomCard(double width, double height) {
    return Hero(
      tag: 'tobutton',
      child: Container(
        width: width,
        height: height / 2,
        padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
        decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(32), topLeft: Radius.circular(32))),
        child: _buildBottomCardChildren(),
      ),
    );
  }

  Widget _buildBottomCardChildren() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              CreateGameScreen(database),
                        ));
                  },
                  icon: Icon(
                    Icons.create,
                    size: 40,
                  ),
                  padding: EdgeInsets.all(2),
                ),
                Text(
                  'Create Game',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ]),
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => JoinGameScreen(database),
                        ));
                  },
                  icon: Icon(
                    Icons.search,
                    size: 40,
                  ),
                  padding: EdgeInsets.all(2),
                ),
                Text(
                  'Join Game',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ]),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return MaterialApp(
debugShowCheckedModeBanner: false,

      theme: new ThemeData(
        scaffoldBackgroundColor: Colors.black,
      ),
      home: Scaffold(
        backgroundColor: Colors.grey[300],
        body: Container(
          margin: EdgeInsets.only(top: 16),
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: height / 10),
                alignment: Alignment.topCenter,
                child: Text(
                  'Hi ' + Constants.getUsername() + '!',
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                ),
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: _buildBottomCard(width, height)),
              //_buildCardsList(),
            ],
          ),
        ),
      ),
    );
  }
}
