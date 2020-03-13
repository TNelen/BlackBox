import 'package:flutter/material.dart';
import '../Interfaces/Database.dart';
import 'Popup.dart';
import '../Constants.dart';
import '../DataContainers/Question.dart';

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
      style: TextStyle(fontSize: 17, color: Colors.black),
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
      borderRadius: BorderRadius.circular(28.0),
      color: Constants.iWhite.withOpacity(0.5),
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

              ///Add question to database
              List<String> questions = new List<String>();
              String questionCapital = question.substring(0,1).toUpperCase()+question.substring(1);
              questions.add(questionCapital);
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
            body: Container(
              decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.blueGrey[800],Colors.cyan[800]]),
        ),
        child: Padding(
              padding: EdgeInsets.only(left: 22, right: 22),
              child:Center(
              child: Container(
                padding: EdgeInsets.all(10),
                child: ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(20.0),
                    children: [
                      SizedBox(height: 15,),
                      Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Icon(
                          Icons.arrow_back,
                          color: Constants.iWhite,
                        ),
                      ),
                      Text(
                        'Back',
                        style: TextStyle(
                          fontSize: 20,
                          color: Constants.iWhite,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
                      SizedBox(height: 40.0),
                      Text(
                        'Submit Question',
                        textAlign: TextAlign.center,
                        style: new TextStyle(
                            color: Constants.iWhite,
                            
                            fontSize: 30.0,
                            fontWeight: FontWeight.w300),
                      ),
                      SizedBox(height: 80.0),
                      Text(
                        'Have a good idea for a question?',
                        textAlign: TextAlign.center,
                        style: new TextStyle(
                            color: Constants.colors[Constants.colorindex],
                            fontSize: 17.0,
                            fontWeight: FontWeight.normal),
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        'Submit it here to get featured in the app!',
                        textAlign: TextAlign.center,
                        style: new TextStyle(
                            color: Constants.iWhite,
                            fontSize: 17.0,
                            fontWeight: FontWeight.normal),
                      ),
                      SizedBox(height: 20.0),
                      QuestionFieled,
                      SizedBox(height: 20.0),
                      SubmitButton,
                      SizedBox(height: 200,)
                    ]),
              ),
            )))));
  }
}
