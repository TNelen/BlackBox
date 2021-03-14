import 'package:blackbox/Constants.dart';
import 'package:blackbox/Screens/animation/ScalePageRoute.dart';
import 'package:blackbox/Screens/widgets/IconCard.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../RulesScreen.dart';
import '../SettingsScreen.dart';

class IconBar extends StatelessWidget {
  IconBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 25,
        ),
        Container(
          width: 60,
          height: 60,
          child: InkWell(
            child: IconCard(
              FontAwesomeIcons.cog,
              Constants.iDarkGrey,
              Colors.lightBlueAccent[100],
              25,
            ),
            onTap: () {
              FirebaseAnalytics()
                  .logEvent(name: 'SettingsScreenOpened', parameters: null);
              Navigator.push(context, ScaleUpPageRoute(SettingsScreen()));
            },
          ),
        ),
        Container(
          width: 60,
          height: 60,
          child: InkWell(
            child: IconCard(
              FontAwesomeIcons.solidQuestionCircle,
              Constants.iDarkGrey,
              Colors.lightBlueAccent[100],
              25,
            ),
            onTap: () {
              FirebaseAnalytics()
                  .logEvent(name: 'HelpScreenOpened', parameters: null);
              Navigator.push(
                  context,
                  ScaleUpPageRoute(
                    RuleScreen(),
                  ));
            },
          ),
        ),
      ],
    );
  }
}
