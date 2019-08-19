import 'package:flutter/material.dart';
import 'package:blackbox/Screens/HomeScreen.dart';
import 'Constants.dart';



void main() => runApp(MyApp());

class MyApp extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        //home: YourGroups(new Firebase()));
        home: HomeScreen( Constants.database ));
  }
}






