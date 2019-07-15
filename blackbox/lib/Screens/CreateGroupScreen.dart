import 'package:flutter/material.dart';

class CreateGroupScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'BlackBox',
        theme: new ThemeData(scaffoldBackgroundColor: Colors.black),
        home: Scaffold(

          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  'Create',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
              ),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'enter group code',
                ),
              )
            ],
          ),

        )

    );

  }
}