import 'package:blackbox/Database/GoogleUserHandler.dart';
import 'package:flutter/material.dart';
import '../Constants.dart';
import '../Database/GoogleUserHandler.dart';
import 'CreateGameScreen.dart';
import 'JoinGameScreen.dart';
import 'Popup.dart';
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

class _HomeScreenState extends State<HomeScreen> {
  Database database;

  _HomeScreenState(Database db) {
    this.database = db;

    /// Log a user in and update variables accordingly

    if (Constants.getUserID() == "id2" || Constants.getUserID() == "") {
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
  void _test() async {
    print("Async start");

    /// Your async testing code here
    print("Async completed");
  }

  @Deprecated('Must be deleted before release!')
  void _addQuestions(List<String> questions) async {
    for (String q in questions) {
      await database.updateQuestion(new Question.addDefault(q));
    }
  }

  Widget CreateGameBox() {
    return Hero(
        tag: 'toberutton',
        child: Card(
          color: Constants.iDarkGrey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: InkWell(
              splashColor: Constants.iAccent,
              onTap: () {
                // if (GoogleUserHandler.isLoggedIn()) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          CreateGameScreen(database),
                    ));
                // } else {
                // Popup.makePopup(context, "Wait!", "You should be logged in to do that.");
                //  }
              },
              child: Container(
                padding: EdgeInsets.fromLTRB(15, 25, 15, 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.create,
                      color: Constants.iAccent,
                      size: 50,
                    ),
                    Text(
                      "Create Game",
                      style: TextStyle(fontSize: 20.0, color: Constants.iWhite),
                    ),
                  ],
                ),
              )),
        ));
  }

  Widget JoinGameBox() {
    return Hero(
        tag: 'frfr',
        child: Card(
          color: Constants.iDarkGrey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: InkWell(
              splashColor: Constants.iAccent,
              onTap: () {
                // if (GoogleUserHandler.isLoggedIn()) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          JoinGameScreen(database),
                    ));
                // } else {
                // Popup.makePopup(context, "Wait!", "You should be logged in to do that.");
                //  }
              },
              child: Container(
                padding: EdgeInsets.fromLTRB(15, 25, 15, 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.search,
                      color: Constants.iAccent,
                      size: 50,
                    ),
                    Text(
                      "Join Game",
                      style: TextStyle(fontSize: 20.0, color: Constants.iWhite),
                    ),
                  ],
                ),
              )),
        ));
  }

  Widget createCustomizationRow() {
    return Row(
      children: <Widget>[
        Card(
            color: Constants.iDarkGrey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: InkWell(
                splashColor: Constants.iAccent,
                onTap: () {
                  ///nothing yet
                },
                child: Container(
                    padding: EdgeInsets.fromLTRB(25, 25, 25, 25),
                    child: Column(
                      children: <Widget>[
                        Icon(Icons.perm_identity, color: Constants.iAccent,size: 30,),
                        Text('Profile', style: new TextStyle(fontSize: 15, color: Constants.iWhite),)
                      ],
                    )))),
        SizedBox(width: 8,),
        Card(
            color: Constants.iDarkGrey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: InkWell(
                splashColor: Constants.iAccent,
                onTap: () {
                  ///nothing yet
                },
                child: Container(
                    padding: EdgeInsets.fromLTRB(25, 25, 25, 25),
                    child: Column(
                      children: <Widget>[
                        Icon(Icons.settings, color: Constants.iAccent, size: 30,),
                        Text('Settings', style: new TextStyle(
                            fontSize: 15, color: Constants.iWhite),)
                      ],
                    )))),
        SizedBox(width: 8,),
        Card(
            color: Constants.iDarkGrey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: InkWell(
                splashColor: Constants.iAccent,
                onTap: () {
                  ///nothing yet
                },
                child: Container(
                    padding: EdgeInsets.fromLTRB(25, 25, 25, 25),
                    child: Column(
                      children: <Widget>[
                        Icon(Icons.report_problem, color: Constants.iAccent, size:  30,),
                        Text('Report Issue', style: new TextStyle(
                            fontSize: 15, color: Constants.iWhite),)
                      ],
                    )))),
      ],
    );
  }

  Widget submitQuestionRow() {
    return Row(
      children: <Widget>[

        Card(
            color: Constants.iDarkGrey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: InkWell(
                splashColor: Constants.iAccent,
                onTap: () {
                  ///nothing yet
                },
                child: Container(
                    padding: EdgeInsets.fromLTRB(50, 50, 50, 50),
                    child: Column(
                      children: <Widget>[
                        Icon(Icons.library_add, color: Constants.iAccent, size:  30,),
                        SizedBox(height: 10,),
                        Text('Submit Question', style: new TextStyle(
                            fontSize: 15, color: Constants.iWhite),)
                      ],
                    )))),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        scaffoldBackgroundColor: Constants.iBlack,
      ),
      home: Scaffold(
        backgroundColor: Constants.iBlack,
        body: Container(
          margin: EdgeInsets.only(top: 16,left: 8, right: 8),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: height / 10, left: 10, right: 10),
                alignment: Alignment.topCenter,
                child: Text(
                  'Hi ' + Constants.getUsername() + '!',
                  style: TextStyle(
                      color: Constants.iWhite,
                      fontSize: 50,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              CreateGameBox(),
              SizedBox(
                height: 20,
              ),
              JoinGameBox(),
              SizedBox(
                height: 20,
              ),
              createCustomizationRow(),
              SizedBox(
                height: 20,
              ),
              submitQuestionRow(),
            ],
          ),
        ),
      ),
    );
  }
}
