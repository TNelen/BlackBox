import 'package:flutter/material.dart';
import '../main.dart';

class ProfileScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BlackBox',
      theme: new ThemeData(scaffoldBackgroundColor: Colors.black),
      home: Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.black,
              title: Text('Your profile',
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                ),
              ),
            ),
      body: Center(
        child: RaisedButton(
            child: Text('your username:  ' +username, style: TextStyle(fontSize: 20),),
            color: Colors.amber,
            textColor: Colors.white,
            onPressed: () => Navigator.pop(context)
        ),
      ),
    ));
  }
}