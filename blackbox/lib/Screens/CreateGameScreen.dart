import 'package:flutter/material.dart';
import '../Constants.dart';
import '../DataContainers/GroupData.dart';
import '../Interfaces/Database.dart';

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

  static String groupName = "ExampleName";
  static String groupDescription = "Example Description";
  static String groupID = 'AC8NR27';
  static String groupAdmin = Constants.getUserID();

  final _formKey = GlobalKey<FormState>();

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
            // Create list of members
            Map<String, String> members = new Map<String, String>();
            members[Constants.getUserID()] = Constants.getUsername();
            groupName = nameController.text;
            groupDescription = descController.text;
            if(groupName.length != 0 && groupDescription.length != 0) {
              // Generate a unique ID and save the group
              _database.generateUniqueGroupCode().then((code) {
                _database.updateGroup(new GroupData(groupName, groupDescription,
                    code, Constants.getUserID(), members));
              });
            };
          },
          child: Text("Create",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20)
                  .copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );

    return MaterialApp(
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
                'Create new Game',
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.white,
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
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
