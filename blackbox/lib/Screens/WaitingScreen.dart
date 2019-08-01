import 'package:flutter/material.dart';
import '../main.dart';
import '../DataContainers/GroupData.dart';
import '../Constants.dart';
import 'ResultsScreen.dart';
import 'InstructionScreen.dart';

class WaitingScreen extends StatefulWidget {
  WaitingScreen(this.groupInfo) : super();
  final GroupData groupInfo;

  @override
  _WaitingScreenState createState() => _WaitingScreenState(groupInfo);
}

class _WaitingScreenState extends State<WaitingScreen> {
  GroupData groupInfo;

  _WaitingScreenState(GroupData groupinfo) {
    this.groupInfo = groupinfo;
  }

  @override
  Widget build(BuildContext context) {
    if (Constants.getUserID() == groupInfo.adminID)
      return adminScreen(context);
    else
      return userScreen(context);
  }
}

MaterialApp userScreen(BuildContext context) {
  return MaterialApp(
    theme: new ThemeData(scaffoldBackgroundColor: Colors.black),
    home: Scaffold(
      appBar: AppBar(
        title: Container(
          alignment: Alignment.centerRight,
          child: IconButton(
            icon: Icon(
              Icons.help_outline,
              color: Colors.amber,
              size: 35,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => InstructionScreen(),
                  ));
            },
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Container(
          alignment: Alignment(0, 0),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: 'Get Ready!\n'
                  'waiting for admin to start game',
              style: TextStyle(color: Colors.white, fontSize: 50),
            ),
          ),
        ),
      ),
    ),
  );
}

MaterialApp adminScreen(BuildContext context) {
  final playButton = Material(
    elevation: 5.0,
    borderRadius: BorderRadius.circular(30.0),
    color: Colors.amber,
    child: MaterialButton(
      minWidth: MediaQuery.of(context).size.width,
      padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => ResultScreen(),
            ));
      }, //change isplaying field in database for this group to TRUE
      child: Text("Play",
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
                  text: 'You are admin, press play if all members are ready',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
              SizedBox(height: 45.0),
              playButton,
            ],
          ),
        ),
      ),
    ),
  );
}
