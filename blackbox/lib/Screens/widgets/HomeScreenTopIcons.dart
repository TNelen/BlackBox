import 'package:blackbox/Constants.dart';
import 'package:blackbox/Interfaces/Database.dart';
import 'package:blackbox/Screens/widgets/IconCard.dart';
import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

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
            onTap: null,
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
            onTap: null,
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
            onTap: null,
          ),
        ),
      ],
    );
  }
}
