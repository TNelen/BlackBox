import 'dart:async';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:progress_indicators/progress_indicators.dart';
import '../../Interfaces/Database.dart';
import '../../Database/FirebaseStream.dart';
import '../../DataContainers/GroupData.dart';
import '../../Constants.dart';
import '../QuestionScreen.dart';
import '../HomeScreen.dart';
import 'package:share/share.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:auto_size_text/auto_size_text.dart';

class CreatePartyScreen extends StatefulWidget {
  Database _database;

  CreatePartyScreen(Database db) {
    this._database = db;
  }

  @override
  _CreatePartyScreenState createState() => _CreatePartyScreenState(_database);
}

class _CreatePartyScreenState extends State<CreatePartyScreen> {
  Database _database;
  bool joined = false;

  _CreatePartyScreenState(Database db) {
    this._database = db;
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          fontFamily: "atarian",
          scaffoldBackgroundColor: Constants.iBlack,
        ),
        home: Scaffold(
          body: SizedBox()
        ));
  }



}
