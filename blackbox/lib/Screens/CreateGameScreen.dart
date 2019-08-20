import 'package:flutter/material.dart';
import '../Constants.dart';
import '../DataContainers/GroupData.dart';
import '../Interfaces/Database.dart';
import 'GameScreen.dart';
import 'package:flutter/services.dart';
import 'GameScreen.dart';
import 'package:share/share.dart';

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
  String _groupDescription;
  String _groupID;
  String _groupAdmin = Constants.getUserID();

  void _showDialog(String code) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0))),
          title: new Text(
            "Group Code",
            style: TextStyle(
                color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
          ),
          content: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                code,
                style: TextStyle(color: Colors.black, fontSize: 25),
              ),
              IconButton(
                  icon: Icon(
                    Icons.share,
                    color: Colors.black,
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
                    color: Colors.amber,
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
          fillColor: Colors.white,
          filled: true,
          hintText: "Group Name",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final descrField = TextField(
      obscureText: false,
      controller: descController,
      style: TextStyle(fontSize: 20, color: Colors.black),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          fillColor: Colors.white,
          filled: true,
          hintText: "Description",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final createButton = Hero(
      tag: 'tobutton',
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(32.0),
        color: Colors.amber,
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: () {
            // Create map of members
            Map<String, String> members = new Map<String, String>();
            members[Constants.getUserID()] = Constants.getUsername();
            _groupName = nameController.text;
            _groupDescription = descController.text;
            if (_groupName.length != 0 && _groupDescription.length != 0) {
              // Generate a unique ID and save the group
              _database.generateUniqueGroupCode().then((code) {
                _database.updateGroup(new GroupData(_groupName,
                    _groupDescription, code, Constants.getUserID(), members));
                _showDialog(code);
              });
            }
          },
          child: Text("Create",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20)
                  .copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: new ThemeData(
        scaffoldBackgroundColor: Colors.black,
      ),
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: () => Navigator.pop(context),
                child: Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.amber,
                  ),
                ),
              ),
              Text(
                'Back',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.amber,
                ),
              ),
            ],
          ),
        ),
        body: Center(
          child: Container(
            color: Colors.black,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Create new game',
                    style: new TextStyle(color: Colors.white, fontSize: 40.0),
                  ),
                  SizedBox(height: 80.0),

                  Text(
                    'Enter game details',
                    style: new TextStyle(color: Colors.amber, fontSize: 25.0),
                  ),
                  SizedBox(height: 45.0),
                  nameField,
                  SizedBox(height: 25.0),
                  descrField,
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
