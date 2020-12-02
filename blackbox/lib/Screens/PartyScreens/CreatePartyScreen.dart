import 'dart:math';

import 'package:blackbox/DataContainers/QuestionCategory.dart';
import 'package:blackbox/Database/QuestionListGetter.dart';
import 'package:blackbox/Screens/popups/GroupCodePopup.dart';
import 'package:blackbox/Screens/widgets/CategoryCard.dart';
import 'package:blackbox/Screens/widgets/toggle_button_card.dart';
import 'package:flutter/material.dart';
import '../../Constants.dart';
import '../../DataContainers/GroupData.dart';
import '../../Interfaces/Database.dart';
import '../popups/Popup.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'SetPlayersScreen.dart';

class CreatePartyScreen extends StatefulWidget {
  Database _database;

  CreatePartyScreen(Database db) {
    this._database = db;
  }

  @override
  _CreatePartyScreenState createState() => new _CreatePartyScreenState(_database);
}

class _CreatePartyScreenState extends State<CreatePartyScreen> {
  Database _database;

  _CreatePartyScreenState(Database db) {
    this._database = db;

    FirebaseAnalytics().logEvent(name: 'open_screen', parameters: {'screen_name': 'CreatePartyScreen'});
  }

  List<String> selectedCategory = [];
  String _groupName;
  bool _canVoteBlank = false;
  Color color = Constants.iDarkGrey;

  @override
  Widget build(BuildContext context) {
    final nextButton = Hero(
        tag: 'tobutton',
        child: Padding(
          padding: EdgeInsets.only(left: 45, right: 45),
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(26.0),
            color: Constants.colors[Constants.colorindex],
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(26.0),
              ),
              minWidth: MediaQuery
                  .of(context)
                  .size
                  .width,
              padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
              onPressed: () {
                if (selectedCategory.length != 0) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => SetPlayersScreen(_database, selectedCategory, _canVoteBlank),
                      ));
                }
                else {
                  Popup.makePopup(context, "Woops!", "Please select one or more categories!");
                }
              },
              child: Text("Create", textAlign: TextAlign.center, style: TextStyle(fontSize: Constants.actionbuttonFontSize).copyWith(color: Constants.iDarkGrey, fontWeight: FontWeight.bold)),
            ),
          ),
        ));

    final QuestionListGetter questionListGetter = QuestionListGetter.instance;


    final categoryField = FutureBuilder<List<QuestionCategory>>(
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.none && projectSnap.hasData == null || projectSnap.data == null) {
          //print('project snapshot data is: ${projectSnap.data}');
          return Container();
        }

        return ListView.builder(
          shrinkWrap: true,
          // physics: ClampingScrollPhysics(),
          physics: NeverScrollableScrollPhysics(),
          itemCount: projectSnap.data.length,
          itemBuilder: (context, index) {
            int amount = projectSnap.data[index].amount;
            String description = projectSnap.data[index].description;
            String categoryname = projectSnap.data[index].name;

            return Column(children: [
              CategoryCard(
                selectedCategory.contains(categoryname),
                categoryname,
                description,
                amount,
                onTap: () {
                  if (!selectedCategory.contains(categoryname)) {
                    selectedCategory.add(categoryname);
                  } else if (selectedCategory.contains(categoryname)) {
                    selectedCategory.remove(categoryname);
                  }
                  setState(() {});
                },
              ),
              SizedBox(height: 5,)
            ]);
          },
        );
      },
      future: questionListGetter.getCategories(),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        fontFamily: "atarian",
        scaffoldBackgroundColor: Constants.iBlack,
      ),
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          elevation: 0,

          backgroundColor: Colors.transparent,
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
                      fontSize: Constants.actionbuttonFontSize,
                      color: Constants.colors[Constants.colorindex],
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
        body: Center(
          child: Container(
            //color: Constants.iBlack,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomLeft,
                stops: [0.1, 1.0],
                colors: [
                  Constants.gradient1,
                  Constants.gradient2,


                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 1),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return ListView(
                    padding: const EdgeInsets.only(left: 50, right: 50, top: 20, bottom: 20),

                    shrinkWrap: true,
                    children: <Widget>[
                      Hero(
                        tag: "PartHeader",
                        child: AutoSizeText(
                        "Create a new Party",
                        style: new TextStyle(color: Constants.iWhite, fontSize: Constants.titleFontSize, fontWeight: FontWeight.w300),
                        maxLines: 1,
                      ),),
                      SizedBox(height: 30.0),
                      Text(
                        'Game settings',
                        style: new TextStyle(color: Constants.colors[Constants.colorindex], fontSize: Constants.normalFontSize),
                      ),
                      SizedBox(height: 20.0),
                      ToggleButtonCard(
                        'Blank vote',
                        _canVoteBlank,
                        onToggle: (bool newValue) => _canVoteBlank = newValue,
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        'Choose categories',
                        style: TextStyle(
                          color: Constants.colors[Constants.colorindex],
                          fontSize: Constants.normalFontSize,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      categoryField,
                      SizedBox(height: 75.0),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
        floatingActionButton: nextButton,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
