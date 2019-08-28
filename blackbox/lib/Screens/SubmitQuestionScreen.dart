import 'package:flutter/material.dart';
import 'GameScreen.dart';
import '../Interfaces/Database.dart';
import 'HomeScreen.dart';
import 'Popup.dart';
import '../Constants.dart';
import '../DataContainers/Question.dart';
import 'Popup.dart';

class SubmitQuestionScreen extends StatefulWidget {
  Database _database;

  SubmitQuestionScreen(Database db) {
    this._database = db;
  }

  @override
  _SubmitQuestionScreenState createState() =>
      new _SubmitQuestionScreenState(_database);
}

class _SubmitQuestionScreenState extends State<SubmitQuestionScreen> {
  Database _database;
  TextEditingController questionController = new TextEditingController();

  _SubmitQuestionScreenState(Database db) {
    this._database = db;
  }

  void _addQuestions(List<String> questions) async {
    for (String q in questions) {
      await _database
          .updateQuestion(new Question.addFromUser(q, Constants.userData));
    }
  }

  @override
  Widget build(BuildContext context) {
    final QuestionFieled = TextField(
      obscureText: false,
      keyboardType: TextInputType.multiline,
      autocorrect: false,
      maxLength: 100,
      maxLines: 2,
      controller: questionController,
      style: TextStyle(fontSize: 20, color: Colors.black),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 40.0),
          fillColor: Constants.iWhite,
          filled: true,
          hintText: "Start typing here...",
          counterText: questionController.text.length.toString(),
          counterStyle: TextStyle(color: Constants.iBlack),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(16.0))),
    );

    final SubmitButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(16.0),
      color: Constants.iDarkGrey,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          String question = questionController.text;
          //print('-' + question+ '-');
          if (question.length == 0) {
            Popup.makePopup(
                context, 'Whoops!', 'You cannot submit an empty question');
          } else if (question.length >= 20) {
            if (question.endsWith('?')) {
              print('----' + question + '---- Added to database');

              ///Add question to database
              List<String> questions = new List<String>();
              questions.add(question);
              _addQuestions(questions);
              Navigator.pop(context);
            } else
              Popup.makePopup(context, 'Whoops',
                  'Please end your question with a question mark');
          } else
            Popup.makePopup(
                context, 'Whoops!', 'You cannot submit a question shorter than 20 characters');
        },
        child: Text("Submit",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20).copyWith(
                color: Constants.iWhite, fontWeight: FontWeight.bold)),
      ),
    );

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BlackBox',
        theme: new ThemeData(scaffoldBackgroundColor: Constants.iBlack),
        home: Scaffold(
            appBar: AppBar(
              backgroundColor: Constants.iBlack,
              title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Constants.iAccent,
                        ),
                      ),
                      Text(
                        'Back',
                        style: TextStyle(
                          fontSize: 20,
                          color: Constants.iAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
            body: Center(
              child: Container(
                padding: EdgeInsets.all(10),
                color: Constants.iBlack,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 40.0),
                      Text(
                        'Submit Question',
                        style: new TextStyle(
                            color: Constants.iWhite,
                            fontSize: 40.0,
                            fontWeight: FontWeight.w300),
                      ),
                      SizedBox(height: 80.0),
                      Text(
                        'Have an good idea for a question?',
                        textAlign: TextAlign.center,
                        style: new TextStyle(
                            color: Constants.iAccent,
                            fontSize: 25.0,
                            fontWeight: FontWeight.normal),
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        'Submit it here to get featured in the app!',
                        textAlign: TextAlign.center,
                        style: new TextStyle(
                            color: Constants.iWhite,
                            fontSize: 20.0,
                            fontWeight: FontWeight.normal),
                      ),
                      SizedBox(height: 20.0),
                      QuestionFieled,
                      SizedBox(height: 20.0),
                      SubmitButton,
                    ]),
              ),
            )));
  }
}
