import 'package:flutter/material.dart';
import '../main.dart';
import '../DataContainers/GroupData.dart';
import '../Constants.dart';



class WaitingScreen extends StatefulWidget {

  WaitingScreen(this.groupInfo) : super();
  final GroupData groupInfo;

  @override
  _WaitingScreenState createState() => _WaitingScreenState( groupInfo );

}

class _WaitingScreenState extends State<WaitingScreen> {

  GroupData groupInfo;

  String username = Constants.username;

  _WaitingScreenState(GroupData groupinfo)
  {
    this.groupInfo = groupinfo;
  }


  @override

  Widget build(BuildContext context) {
    if(Constants.username == groupInfo.adminID )
      return adminScreen();
    else
      return userScreen();
  }
}



MaterialApp userScreen(){
  return MaterialApp(
    theme: new ThemeData(scaffoldBackgroundColor: Colors.black),
    home: Scaffold(

      body: Center(

        child: Container(
          alignment: Alignment(0, 0),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: 'Waiting for people to join' ,
              style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white, fontSize: 50 ),


            ),),
        ),),),);
}

MaterialApp adminScreen(){
  return MaterialApp(
    theme: new ThemeData(scaffoldBackgroundColor: Colors.black),
    home: Scaffold(

      body: Center(

        child: Container(
          alignment: Alignment(0, 0),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: 'You are admin' ,
              style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white, fontSize: 50 ),


            ),),
        ),),),);
}