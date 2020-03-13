import 'package:flutter/material.dart';
import '../Constants.dart';
import '../DataContainers/GroupData.dart';
import '../Interfaces/Database.dart';
import 'GameScreen.dart';
import 'Popup.dart';
import 'package:share/share.dart';
import '../DataContainers/Question.dart';
import 'package:auto_size_text/auto_size_text.dart';

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

  String _groupName;
  String _groupCategory;
  //String _groupID;
  //String _groupAdmin = Constants.getUserID();

  String selectedCategory;
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
                color: Constants.iBlack,
                fontSize: 25,
                fontWeight: FontWeight.bold),
          ),
          content: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                code,
                style: TextStyle(color: Constants.iBlack, fontSize: 25),
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
                    color: Constants.colors[Constants.colorindex],
                    fontSize: 20,
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
      style: TextStyle(fontSize: 17, color: Colors.black),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          fillColor: Constants.iWhite,
          filled: true,
          hintText: "Group Name",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(16.0))),
    );

    final categoryField = Flexible(
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
        childAspectRatio: (3 / 1),
        children: Question.getCategoriesAsStringList()
            .map((data) => Card(
                color: data == selectedCategory
                    ? Constants.iLight.withOpacity(0.5)
                    : Constants.iDarkGrey.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28.0),
                ),
                child: InkResponse(
                  splashColor: Constants.colors[Constants.colorindex],
                  radius: 50, 
                  onTap: () {
                    setState(() {
                      color = Constants.colors[Constants.colorindex];
                      selectedCategory = data;
                    });
                  },
                  child: Container(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10),
                        child: Text(
                          data,
                          style: new TextStyle(
                              color: data == selectedCategory
                                  ? Constants.iWhite
                                  : Constants.iWhite,
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                )))
            .toList(),
      ),
    );

    final createButton = Hero(
      tag: 'tobutton',
      child: Padding(
        padding: EdgeInsets.only(left: 45, right: 45),
        child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(28.0),
        color: Constants.iWhite.withOpacity(0.5),
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
                _database.createQuestionList(_groupCategory).then((questionlist) {
                GroupData groupdata = new GroupData(_groupName, _groupCategory,
                    code, Constants.getUserID(), members, questionlist);
                  _database.updateGroup(groupdata);
                  _showDialog(code);
                });
              });
            } else {
              Popup.makePopup(context, "Woops!", "Please fill in all fields!");
            }
          },
          child: Text("Create",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20).copyWith(
                  color: Constants.iWhite, fontWeight: FontWeight.bold)),
        ),
      ),
    ));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        scaffoldBackgroundColor: Constants.iBlack,
      ),
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Container(
              decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.blueGrey[800],Colors.cyan[800]]),
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 22, right: 22, bottom: 40),
          child: Center(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
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
                      fontWeight: FontWeight.w600
                    ),
                  ),
                ],
              ),
            ),
          ]),
          SizedBox(height: 25,),
                  AutoSizeText(
                    "Create new Game",
                    style: new TextStyle(
                        color: Constants.iWhite,
                        fontSize: 30.0,
                        fontWeight: FontWeight.w300),
                    maxLines: 1,
                  ),
                  SizedBox(height: 60.0),
                  Text(
                    'Enter game details',
                    style: new TextStyle(
                        color: Constants.colors[Constants.colorindex],
                        fontSize: 20.0),
                  ),
                  SizedBox(height: 45.0),
                  nameField,
                  SizedBox(height: 25.0),
                  Text(
                    'Select a category',
                    style:
                        new TextStyle(color: Constants.iWhite, fontSize: 20.0),
                  ),
                  SizedBox(height: 15.0),
                  categoryField,
                  SizedBox(height: 35.0),
                  createButton,
                  SizedBox(height: 15.0),
                ],
              ),
            ),
          ),
        )),
      )),
    );
  }
}
