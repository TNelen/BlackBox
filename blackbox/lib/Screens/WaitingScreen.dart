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
      return adminScreen(context);
    else
      return userScreen(context);
  }
}



MaterialApp userScreen(BuildContext context){
  return MaterialApp(
    theme: new ThemeData(scaffoldBackgroundColor: Colors.black),
    home: Scaffold(

      appBar: AppBar(
        title: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.amber,),
          onPressed: () => Navigator.pop(context),

        ),
        backgroundColor: Colors.black,
      ),

      body: Center(

        child: Container(
          alignment: Alignment(0, 0),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: 'Waiting for people to join' ,
              style: TextStyle(color: Colors.white, fontSize: 50 ),


            ),),
        ),),),);
}

MaterialApp adminScreen(BuildContext context){
  return MaterialApp(
    theme: new ThemeData(scaffoldBackgroundColor: Colors.black),
    home: Scaffold(

      appBar: AppBar(
        title: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.amber,),
          onPressed: () => Navigator.pop(context),

        ),
        backgroundColor: Colors.black,
      ),

      body: Center(

        child: Container(
          alignment: Alignment(0, 0),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: 'You are admin' ,
              style: TextStyle(color: Colors.white, fontSize: 50 ),


            ),),
        ),),
      ),);
}