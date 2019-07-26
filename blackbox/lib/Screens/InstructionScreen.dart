import 'package:flutter/material.dart';
import '../main.dart';
import '../DataContainers/GroupData.dart';
import '../Constants.dart';

class InstructionScreen extends StatefulWidget {
  @override
  InstructionScreenState createState() => InstructionScreenState();
}

class InstructionScreenState extends State<InstructionScreen> {
  @override
  Widget build(BuildContext context) {
      return instructions(context);
  }
}


MaterialApp instructions(BuildContext context) {
  final understoodButton = Material(
    elevation: 5.0,
    borderRadius: BorderRadius.circular(30.0),
    color: Colors.amber,
    child: MaterialButton(
      minWidth: MediaQuery.of(context).size.width,
      padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
      onPressed: () {}, //change isplaying field in database for this group to TRUE
      child: Text("Understood",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20)
              .copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
    ),
  );

  return MaterialApp(
    theme: new ThemeData(scaffoldBackgroundColor: Colors.black),
    home: Scaffold(
      appBar: AppBar(
        title: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.amber,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(10),
          alignment: Alignment(0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Vote for a member'
                  'The person with the most votes is the winner',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
              SizedBox(height: 45.0),
              understoodButton,
            ],
          ),
        ),
      ),
    ),
  );
}
