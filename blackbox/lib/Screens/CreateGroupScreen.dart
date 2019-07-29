import 'package:flutter/material.dart';
import '../Constants.dart';
import '../DataContainers/GroupData.dart';

class CreateGroupScreen extends StatefulWidget {
  @override
  _CreateGroupScreenState createState() => new _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  static String groupName;
  static String groupDescription;
  static String groupID = 'AC8NR27';
  static String groupAdmin = Constants.username;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final emailField = TextField(
      obscureText: false,
      style: TextStyle(fontSize: 20, color: Colors.black),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          fillColor: Colors.white,
          filled: true,
          hintText: "Group Name",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final passwordField = TextField(
      obscureText: false,
      style: TextStyle(fontSize: 20, color: Colors.black),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          fillColor: Colors.white,
          filled: true,
          hintText: "Description",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final createButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.amber,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          


        },
        child: Text("Create",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20)
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
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
                  )),
              Text(
                'Create new Group',
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
                  SizedBox(
                    height: 30.0,
                    child: Image.asset(
                      "../Assets/logoPlaceholder.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 45.0),
                  emailField,
                  SizedBox(height: 25.0),
                  passwordField,
                  SizedBox(
                    height: 35.0,
                  ),
                  createButton,
                  SizedBox(
                    height: 15.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
