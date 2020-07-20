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
  TextEditingController nameController = new TextEditingController();
  TextEditingController descController = new TextEditingController();

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
    final nameField = TextField(
      obscureText: false,
      controller: nameController,
      style: TextStyle(fontSize: 20, color: Colors.black),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          fillColor: Constants.iWhite,
          filled: true,
          hintText: "Group Name",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(16.0))),
    );

    final createButton = Hero(
        tag: 'tobutton',
        child: Padding(
          padding: EdgeInsets.only(left: 45, right: 45),
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(28.0),
            color: Constants.colors[Constants.colorindex],
            child: MaterialButton(
              minWidth: MediaQuery.of(context).size.width,
              padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
              onPressed: () {
                // Create map of members
                Map<String, String> members = new Map<String, String>();
                members[Constants.getUserID()] = Constants.getUsername();
                _groupName = nameController.text;
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
          itemCount: 5,
          itemBuilder: (context, index) {
            print(projectSnap.data);
            String description = projectSnap.data[0][index];
            String categoryname = projectSnap.data[1][index];
            print(description);
            print(categoryname);
            return Flexible(
                child: Card(
                    color: categoryname == selectedCategory
                        ? Constants.iLight
                        : Constants.iDarkGrey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28.0),
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
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10),
                            child: Text(
                              categoryname,
                              style: new TextStyle(
                                  color: categoryname == selectedCategory
                                      ? Constants.iDarkGrey
                                      : Constants.iWhite,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    )));
          },
        );
      },
      future: FirebaseGetters.getQuestionCategories(),
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
            padding: EdgeInsets.only(left: 22, right: 22, bottom: 40),
            child: Center(
              child: Container(
                color: Constants.iBlack,
                child: Padding(
                  padding: const EdgeInsets.all(36.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      AutoSizeText(
                        "Create new Game",
                        style: new TextStyle(
                            color: Constants.iWhite,
                            fontSize: 50.0,
                            fontWeight: FontWeight.w300),
                        maxLines: 1,
                      ),
                      SizedBox(height: 60.0),
                      Text(
                        'Enter game details',
                        style: new TextStyle(
                            color: Constants.colors[Constants.colorindex],
                            fontSize: 30.0),
                      ),
                      SizedBox(height: 45.0),
                      nameField,
                      SizedBox(height: 45.0),
                      categoryField,
                      SizedBox(height: 100.0),
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
