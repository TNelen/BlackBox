import 'package:flutter/material.dart';
import '../Constants.dart';
import '../DataContainers/GroupData.dart';
import '../Interfaces/Database.dart';
import 'GameScreen.dart';
import 'Popup.dart';
import 'GameScreen.dart';
import 'package:share/share.dart';
import '../DataContainers/Question.dart';

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
  String _groupID;
  String _groupAdmin = Constants.getUserID();

  String dropdownValue = 'Default';

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
                color: Constants.iBlack, fontSize: 25, fontWeight: FontWeight.bold),
          ),
          content: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                code,
                style: TextStyle(color:Constants.iBlack, fontSize: 25),
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
                    color: Constants.iAccent,
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
      style: TextStyle(fontSize: 20, color: Colors.black),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          fillColor: Constants.iWhite,
          filled: true,
          hintText: "Group Name",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(16.0))),
    );

    final categoryField = Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Constants.iWhite,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
              color: Colors.amber, style: BorderStyle.solid, width: 0.01),
        ),
        child: DropdownButton<String>(
          value: dropdownValue,
          onChanged: (String newValue) {
            setState(() {
              dropdownValue = newValue;
            });
          },
          items: Question.getCategoriesAsStringList()
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, ),
            );
          }).toList(),
        ));

    final createButton = Hero(
      tag: 'tobutton',
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(16.0),
        color: Constants.iDarkGrey,
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: () {
            // Create map of members
            Map<String, String> members = new Map<String, String>();
            members[Constants.getUserID()] = Constants.getUsername();
            _groupName = nameController.text;
            _groupCategory = dropdownValue;
            if (_groupName.length != 0 && _groupCategory  != null) {
              // Generate a unique ID and save the group
              _database.generateUniqueGroupCode().then((code) {
                _database.updateGroup(new GroupData(_groupName,
                    _groupCategory, code, Constants.getUserID(), members));
                _showDialog(code);
              });
            } else {
              Popup.makePopup(context, "Woops!", "Please fill in all fields!");
            }
          },
          child: Text("Create",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20)
                  .copyWith(color: Constants.iWhite, fontWeight: FontWeight.bold)),
        ),
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        scaffoldBackgroundColor: Constants.iBlack,
      ),
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          backgroundColor: Constants.iBlack,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: () => Navigator.pop(context),
                child: Row(children: [Padding(
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
        ]),),
        body: Center(
          child: Container(
            color: Constants.iBlack,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Create new game',
                    style: new TextStyle(color: Constants.iWhite, fontSize: 40.0, fontWeight: FontWeight.w300),
                  ),
                  SizedBox(height: 80.0),
                  Text(
                    'Enter game details',
                    style: new TextStyle(color: Constants.iAccent, fontSize: 25.0),
                  ),
                  SizedBox(height: 45.0),
                  nameField,
                  SizedBox(height: 25.0),
                  Text(
                    'Select a category',
                    style: new TextStyle(color: Constants.iWhite, fontSize: 20.0),
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
        ),
      ),
    );
  }
}
