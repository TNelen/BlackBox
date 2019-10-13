import 'package:flutter/material.dart';
import 'package:blackbox/Screens/HomeScreen.dart';
import 'Constants.dart';



void main() {
  try {
    runApp(MyApp());
  } catch(exception) {}
}

class MyApp extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        //home: YourGroups(new Firebase()));
        debugShowCheckedModeBanner: false,

        home: HomeScreen( Constants.database ));
  }
}






