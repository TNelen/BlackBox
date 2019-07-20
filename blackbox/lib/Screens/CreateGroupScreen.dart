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
    // Build a Form widget using the _formKey created above.
    return MaterialApp(
     home: Scaffold(
      body: Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return 'Enter some text';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false
                // otherwise.
                if (_formKey.currentState.validate()) {
                  // If the form is valid, display a Snackbar.
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text('Processing Data')));
                }
              },
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    ),),);
  }



}
/*
showDialog(
context: context,
child: new AlertDialog(
title: new Text("Details"),
//content: new Text("Hello World"),
content: new SingleChildScrollView(
child: new ListBody(
children: <Widget>[
new Text("Name : " + groupName),
new Text("Description : " + groupDescription),
new Text("Admin : " + groupAdmin),
new Text("ID : " + groupID),
],
),
),
actions: <Widget>[
new FlatButton(
child: new Text('OK', style: TextStyle(color: Colors.black),),
onPressed: () {
Navigator.of(context).pop();
},
),
],
));*/