import 'package:flutter/material.dart';
import '../main.dart';
import '../Constants.dart';

class ProfileScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BlackBox',
      theme: new ThemeData(scaffoldBackgroundColor: Colors.black),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: const Icon(Icons.arrow_back_ios,color: Colors.amber,),)),
              Text(
                'Your profile',
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      body: Center(
        child: RaisedButton(
            child: Text('your username:  ' +Constants.username, style: TextStyle(fontSize: 20),),
            color: Colors.amber,
            textColor: Colors.white,
            onPressed: () => Navigator.pop(context)
        ),
      ),
    ));
  }
}