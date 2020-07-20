import 'package:flutter/material.dart';
import '../Constants.dart';
import '../DataContainers/GroupData.dart';
import '../DataContainers/Question.dart';
import '../Interfaces/Database.dart';
import 'GameScreen.dart';
import 'Popup.dart';
import 'package:share/share.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../Database/FirebaseGetters.dart';

class CreateGameScreen extends StatefulWidget {
  Database _database;

  CreateGameScreen(Database db) {
    this._database = db;
  }

  @override
  _CreateGameScreenState createState() => new _CreateGameScreenState(_database);
}

class _CreateGameScreenState extends State<CreateGameScreen> {
  Database _database;

  _CreateGameScreenState(Database db) {
    this._database = db;
  }

  String selectedCategory;
  String _groupName;
  String _groupCategory;
  bool _canVoteBlank = false;
  bool _canVoteOnSelf = true;
  Color color = Constants.iDarkGrey;

  void _showDialog(String code) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0))),
          title: new Text(
            "Group Code",
            style: TextStyle(
                fontFamily: "atarian",
                color: Constants.iBlack,
                fontSize: 40,
                fontWeight: FontWeight.bold),
          ),
          content: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                code,
                style: TextStyle(
                    fontFamily: "atarian",
                    color: Constants.iBlack,
                    fontSize: 25),
              ),
              IconButton(
                  icon: Icon(
                    Icons.share,
                    color: Constants.iBlack,
                  ),
                  onPressed: () {
                    final RenderBox box = context.findRenderObject();
                    Share.share(code,
                        sharePositionOrigin:
                            box.localToGlobal(Offset.zero) & box.size);
                  }),
            ],
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Start",
                style: TextStyle(
                    fontFamily: "atarian",
                    color: Constants.colors[Constants.colorindex],
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            GameScreen(_database, code)));
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final createButton = Hero(
        tag: 'tobutton',
        child: Padding(
          padding: EdgeInsets.only(left: 45, right: 45),
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(26.0),
            color: Constants.colors[Constants.colorindex],
            child: MaterialButton(
              minWidth: MediaQuery.of(context).size.width,
              padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
              onPressed: () {
                // Create map of members
                Map<String, String> members = new Map<String, String>();
                members[Constants.getUserID()] = Constants.getUsername();
                _groupName = "default";
                _groupCategory = selectedCategory;
                if (_groupName.length != 0 && _groupCategory != null) {
                  // Generate a unique ID and save the group
                  _database.generateUniqueGroupCode().then((code) {
                    _database
                        .createQuestionList(_groupCategory)
                        .then((questionlist) {
                      GroupData groupdata = new GroupData(
                          _groupName,
                          _groupCategory,
                          _canVoteBlank,
                          _canVoteOnSelf,
                          code,
                          Constants.getUserID(),
                          members,
                          questionlist);
                      _database.updateGroup(groupdata);
                      _showDialog(code);
                    });
                  });
                } else {
                  Popup.makePopup(
                      context, "Woops!", "Please fill in all fields!");
                }
              },
              child: Text("Create",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30).copyWith(
                      color: Constants.iDarkGrey, fontWeight: FontWeight.bold)),
            ),
          ),
        ));

    final categoryField = FutureBuilder(
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.none &&
            projectSnap.hasData == null) {
          //print('project snapshot data is: ${projectSnap.data}');
          return Container();
        }
        return ListView.builder(
          shrinkWrap: true,
          itemCount: projectSnap.data[0].length,
          itemBuilder: (context, index) {
            int amount = projectSnap.data[2][index];
            String description = projectSnap.data[1][index];
            String categoryname = projectSnap.data[0][index];
            return Flexible(
                child: Card(
                    color: categoryname == selectedCategory
                        ? Constants.iLight
                        : Constants.iDarkGrey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: InkResponse(
                      splashColor: Constants.colors[Constants.colorindex],
                      radius: 50,
                      onTap: () {
                        setState(() {
                          color = Constants.colors[Constants.colorindex];
                          selectedCategory = categoryname;
                        });
                      },
                      child: Container(
                        child: Center(
                          child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 5, left: 10.0, right: 10, bottom: 5),
                              child: Column(children: [
                                Text(
                                  categoryname,
                                  style: new TextStyle(
                                      color: categoryname == selectedCategory
                                          ? Constants.iDarkGrey
                                          : Constants.iWhite,
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  description,
                                  textAlign: TextAlign.center,
                                  style: new TextStyle(
                                      color: categoryname == selectedCategory
                                          ? Constants.iBlack
                                          : Constants.iLight,
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  amount.toString() + '  questions',
                                  textAlign: TextAlign.center,
                                  style: new TextStyle(
                                      color: categoryname == selectedCategory
                                          ? Constants.iBlack
                                          : Constants.iLight,
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 3),
                              ])),
                        ),
                      ),
                    )));
          },
        );
      },
      future: FirebaseGetters.getQuestionCategories(),
    );

    final voteOnSelfSwitch = Container(
        child: Card(
      color: Constants.iDarkGrey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: <Widget>[
              SizedBox(
                width: 10,
              ),
              Text(
                'Vote on yourself',
                style: TextStyle(fontSize: 25.0, color: Constants.iWhite),
              ),
            ]),
            Switch(
              value: _canVoteOnSelf,
              onChanged: (value) {
                _canVoteOnSelf = value;
                setState(() {});
              },
              activeTrackColor: Constants.colors[Constants.colorindex],
              activeColor: Constants.iWhite,
            ),
          ],
        ),
      ),
    ));

    final voteBlancoSwitch = Container(
        child: Card(
      color: Constants.iDarkGrey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: <Widget>[
              SizedBox(
                width: 10,
              ),
              Text(
                'Blank vote',
                style: TextStyle(fontSize: 25.0, color: Constants.iWhite),
              ),
            ]),
            Switch(
              value: _canVoteBlank,
              onChanged: (value) {
                _canVoteBlank = value;
                setState(() {});
              },
              activeTrackColor: Constants.colors[Constants.colorindex],
              activeColor: Constants.iWhite,
            ),
          ],
        ),
      ),
    ));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        fontFamily: "atarian",
        scaffoldBackgroundColor: Constants.iBlack,
      ),
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
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
                      fontSize: 30,
                      color: Constants.colors[Constants.colorindex],
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
        body: Padding(
            padding: EdgeInsets.only(left: 22, right: 22, bottom: 0),
            child: Center(
              child: Container(
                color: Constants.iBlack,
                child: Padding(
                  padding: const EdgeInsets.only(left: 22, right: 22),
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      AutoSizeText(
                        "Create new Game",
                        style: new TextStyle(
                            color: Constants.iWhite,
                            fontSize: 50.0,
                            fontWeight: FontWeight.w300),
                        maxLines: 1,
                      ),
                      SizedBox(height: 30.0),
                      Text(
                        'Game settings',
                        style: new TextStyle(
                            color: Constants.colors[Constants.colorindex],
                            fontSize: 30.0),
                      ),
                      SizedBox(height: 20.0),
                      voteBlancoSwitch,
                      voteOnSelfSwitch,
                      SizedBox(height: 20.0),
                      Text(
                        'Choose a category',
                        style: new TextStyle(
                            color: Constants.colors[Constants.colorindex],
                            fontSize: 30.0),
                      ),
                      SizedBox(height: 20.0),
                      categoryField,
                      SizedBox(height: 20.0),
                      createButton,
                      SizedBox(height: 15.0),
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
