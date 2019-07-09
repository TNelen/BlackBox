import 'package:flutter/material.dart';
import './groupList.dart';
import './ProfileScreen.dart';
import './HomeScreen.dart';


void main() => runApp(MyApp());


class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: HomeScreen());
  }
}






