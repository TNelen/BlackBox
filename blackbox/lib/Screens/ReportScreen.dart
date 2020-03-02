import 'package:flutter/material.dart';
import '../Interfaces/Database.dart';
import '../DataContainers/Issue.dart';
import '../Constants.dart';
import 'Popup.dart';

class ReportScreen extends StatefulWidget {
  Database _database;

  ReportScreen(Database db) {
    this._database = db;
  }

  @override
  _ReportScreenState createState() => new _ReportScreenState(_database);
}

class _ReportScreenState extends State<ReportScreen> {
  Database _database;
  TextEditingController problemController = new TextEditingController();
  String categoryValue = 'Bug';
  String locationValue = 'Home page';
  Issue newIssue = new Issue();

  _ReportScreenState(Database db) {
    this._database = db;
  }

  @override
  Widget build(BuildContext context) {
    final IssueField = TextField(
      obscureText: false,
      keyboardType: TextInputType.multiline,
      controller: problemController,
      style: TextStyle(fontSize: 20, color: Constants.iBlack),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 40.0),
          fillColor: Constants.iWhite,
          filled: true,
          hintText: "Start typing here...",
          hintStyle: TextStyle(fontSize: 17, color: Constants.iDarkGrey),
          counterText: problemController.text.length.toString(),
          counterStyle: TextStyle(color: Constants.iGrey),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(16.0))),
    );

    final SubmitButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(28.0),
      color: Constants.colors[Constants.colorindex],
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          Issue issue = new Issue();
          issue.category = categoryValue.toString();
          issue.location = locationValue.toString();
          issue.description = problemController.text.toString();
          issue.version = '1.0.5';
          _database.submitIssue(issue);
          Navigator.pop(context);
          Popup.makePopup(context, 'Thank You!', 'Your issue is submitted successfully! We will look into it as soon as possible.');
        },
        child: Text("Submit",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20).copyWith(
                color: Constants.iDarkGrey, fontWeight: FontWeight.bold)),
      ),
    );

    Widget categoryField = Container(
        height: 50,
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Constants.iWhite,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
              color: Constants.iDarkGrey,
              style: BorderStyle.solid,
              width: 0.01),
        ),
        child: DropdownButton<String>(
          value: categoryValue,
          style: TextStyle(fontSize: 17, color: Constants.iDarkGrey),
          onChanged: (String newValue) {
            setState(() {
              categoryValue = newValue;
            });
          },
          items: [
            'Bug',
            'App crashes',
            'App is not responding',
            'Vote is not submitted',
            'Problem creating group ',
            'Problem joining group',
            'Problem Starting game',
            'Other (Describe below)'
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
              ),
            );
          }).toList(),
        ));

    Widget locationFiled = Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        height: 50,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Constants.iWhite,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
              color: Constants.iDarkGrey,
              style: BorderStyle.solid,
              width: 0.01),
        ),
        child: DropdownButton<String>(
          value: locationValue,
          style: TextStyle(fontSize: 17, color: Constants.iDarkGrey),
          onChanged: (String newValue) {
            setState(() {
              locationValue = newValue;
            });
          },
          items: [
            'Home page',
            'ProfileScreen',
            'Settings Screen',
            'Game Lobby',
            'Vote Screen',
            'Question Card',
            'Results',
            'Collecting results',
            'Other  (Describe below)'
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
              ),
            );
          }).toList(),
        ));

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
                        child: Icon(
                          Icons.arrow_back,
                          color: Constants.colors[Constants.colorindex],
                        ),
                      ),
                      Text(
                        'Back',
                        style: TextStyle(
                          fontSize: 20,
                          color: Constants.colors[Constants.colorindex],
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
            body: Padding(
              padding: EdgeInsets.only(left: 22, right: 22),
              child:Center(
              child: Container(
                padding: EdgeInsets.all(10),
                color: Constants.iBlack,
                child: ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(20.0),
                    children: [
                      SizedBox(height: 20.0),
                      Hero(
                          tag: 'topicon3',
                          child: Icon(
                                Icons.report_problem,
                                size: 75,
                                color: Constants.colors[Constants.colorindex],
                              )),
                      SizedBox(height: 20.0),

                      Container(height: 1.5, color: Constants.iWhite,),
                      SizedBox(height: 40.0),
                      Text(
                        'Ran into an issue?',
                        textAlign: TextAlign.center,
                        style: new TextStyle(
                            color: Constants.iWhite,
                            fontSize: 25.0,
                            fontWeight: FontWeight.w300),
                      ),
                      SizedBox(height: 40.0),
                      Text(
                        'Sorry to hear that...  ',
                        textAlign: TextAlign.center,
                        style: new TextStyle(
                            color: Constants.colors[Constants.colorindex],
                            fontSize: 17.0,
                            fontWeight: FontWeight.normal),
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        'Please fill in this form so we can locate and solve this problem as fast as possible',
                        textAlign: TextAlign.center,
                        style: new TextStyle(
                            color: Constants.iWhite,
                            fontSize: 17.0,
                            fontWeight: FontWeight.w300),
                      ),
                      SizedBox(height: 30.0),
                      Text(
                        'What is the type of issue?',
                        textAlign: TextAlign.left,
                        style: new TextStyle(
                            color: Constants.iWhite,
                            fontSize: 15.0,
                            fontWeight: FontWeight.normal),
                      ),
                      SizedBox(height: 10.0),
                      categoryField,
                      SizedBox(height: 20.0),
                      Text(
                        'Where is the issue located?',
                        textAlign: TextAlign.left,
                        style: new TextStyle(
                            color: Constants.iWhite,
                            fontSize: 15.0,
                            fontWeight: FontWeight.normal),
                      ),
                      SizedBox(height: 10.0),
                      locationFiled,
                      SizedBox(height: 20.0),
                      Text(
                        'Describe the issue as precise as possible.',
                        textAlign: TextAlign.left,
                        style: new TextStyle(
                            color: Constants.iWhite,
                            fontSize: 15.0,
                            fontWeight: FontWeight.normal),
                      ),
                      SizedBox(height: 10.0),
                      IssueField,
                      SizedBox(height: 20.0),
                      SubmitButton,
                    ]),
              ),
            ))));
  }
}
