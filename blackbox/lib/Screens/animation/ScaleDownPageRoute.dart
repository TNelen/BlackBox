import 'package:flutter/material.dart';

class ScaleDownPageRoute extends PageRouteBuilder {

  final Widget fromPage;
  final Widget toPage;

  ScaleDownPageRoute({this.fromPage, this.toPage}) : super(
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) =>
    toPage,
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) =>
        Stack(
          children: <Widget>[
            ScaleTransition(
              scale: Tween<double>(
                begin: 1.0,
                end: 1.0,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeIn,
                ),
              ),
              child: toPage,
            ),
            ScaleTransition(
              scale: Tween<double>(
                begin: 1.0,
                end: 0.0,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeIn,
                ),
              ),
              child: fromPage,
            ),
          ],
        ),
  );
}