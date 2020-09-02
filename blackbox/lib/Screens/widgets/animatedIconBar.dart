import 'package:blackbox/Constants.dart';
import 'package:flutter/material.dart';
import '../ProfileScreen.dart';
import '../SettingsScreen.dart';
import '../RulesScreen.dart';
import '../../Interfaces/Database.dart';

import 'package:firebase_analytics/firebase_analytics.dart';

class FancyFab extends StatefulWidget {
  final Function() onPressed;
  final String tooltip;
  final IconData icon;
  Database database;

  FancyFab({this.onPressed, this.tooltip, this.icon, this.database});

  @override
  _FancyFabState createState() => _FancyFabState(database);
}

class _FancyFabState extends State<FancyFab> with SingleTickerProviderStateMixin {
  Database database;
  bool isOpened = false;
  AnimationController _animationController;
  Animation<Color> _buttonColor;
  Animation<double> _animateIcon;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  double _fabHeight = 0.0;

  _FancyFabState(Database db) {
    this.database = db;
  }

  @override
  initState() {
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500))
      ..addListener(() {
        setState(() {});
      });
    _animateIcon = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _buttonColor = ColorTween(
      begin: Constants.iDarkGrey,
      end: Constants.colors[Constants.colorindex],
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));
    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -65,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  Widget add() {
    return Container(
      child: FloatingActionButton(
        heroTag: "add",
        backgroundColor: Constants.iDarkGrey,
        elevation: 0.0,
        onPressed: () {
          FirebaseAnalytics().logEvent(name: 'ProfileScreenOpened', parameters: null);

          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => ProfileScreen(database),
              ));
        },
        tooltip: 'Add',
        child: Icon(Icons.account_circle),
      ),
    );
  }

  Widget image() {
    return Container(
      child: FloatingActionButton(
        heroTag: "image",
        backgroundColor: Constants.iDarkGrey,
        elevation: 0.0,
        onPressed: () {
          FirebaseAnalytics().logEvent(name: 'HelpScreenOpened', parameters: null);
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => RuleScreen(database),
              ));
        },
        tooltip: 'Image',
        child: Icon(Icons.help),
      ),
    );
  }

  Widget inbox() {
    return Container(
      child: FloatingActionButton(
        heroTag: "inbox",
        elevation: 0.0,
        backgroundColor: Constants.iDarkGrey,
        onPressed: () {
          FirebaseAnalytics().logEvent(name: 'SettingsScreenOpened', parameters: null);
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => SettingsScreen(database),
              ));
        },
        tooltip: 'Inbox',
        child: Icon(Icons.settings),
      ),
    );
  }

  Widget toggle() {
    return Container(
      child: FloatingActionButton(
        backgroundColor: _buttonColor.value,
        elevation: 0.0,
        onPressed: animate,
        tooltip: 'Toggle',
        child: AnimatedIcon(
          icon: AnimatedIcons.menu_close,
          color: isOpened ? Constants.iBlack : Constants.iWhite,
          progress: _animateIcon,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
    padding: EdgeInsets.only(left: 20),
      child:Stack(

      //mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Transform(
          transform: Matrix4.translationValues(
            -_translateButton.value * 1.0,
            0.0,
            0.0,
          ),
          child: add(),
        ),
        Transform(
          transform: Matrix4.translationValues(
            -_translateButton.value * 2.0,
            0.0,
            0.0,
          ),
          child: image(),
        ),
        Transform(
          transform: Matrix4.translationValues(
            -_translateButton.value * 3.0,
            0.0,
            0.0,
          ),
          child: inbox(),
        ),
        toggle(),
      ],
    ));
  }
}
