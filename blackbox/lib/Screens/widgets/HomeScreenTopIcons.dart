import 'package:blackbox/Constants.dart';
import 'package:blackbox/Interfaces/Database.dart';
import 'package:blackbox/Screens/widgets/IconCard.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

import '../ProfileScreen.dart';
import '../RulesScreen.dart';
import '../SettingsScreen.dart';

class IconBar extends StatelessWidget {
  final Database database;

  IconBar(this.database);

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
              OMIcons.accountCircle,
              Constants.iDarkGrey,
              Constants.iWhite,
              25,
            ),
            onTap: () {
              FirebaseAnalytics()
                  .logEvent(name: 'ProfileScreenOpened', parameters: null);

              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => ProfileScreen(database),
                  ));
            },
          ),
        ),
        SizedBox(
          width: 5,
        ),
        Container(
          width: 60,
          height: 60,
          child: InkWell(
            child: IconCard(
              OMIcons.helpOutline,
              Constants.iDarkGrey,
              Constants.iWhite,
              25,
            ),
            onTap: () {
              FirebaseAnalytics()
                  .logEvent(name: 'HelpScreenOpened', parameters: null);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => RuleScreen(database),
                  ));
            },
          ),
        ),
        Container(
          width: 60,
          height: 60,
          child: InkWell(
            child: IconCard(
              OMIcons.settings,
              Constants.iDarkGrey,
              Constants.iWhite,
              25,
            ),
            onTap: () {
              FirebaseAnalytics()
                  .logEvent(name: 'SettingsScreenOpened', parameters: null);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => SettingsScreen(database),
                  ));
            },
          ),
        ),
      ],
    );
  }
}
