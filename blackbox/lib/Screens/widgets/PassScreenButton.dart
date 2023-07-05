import 'package:blackbox/Screens/widgets/IconCard.dart';
import 'package:flutter/material.dart';

import '../../Constants.dart';

class PassScreenButton extends StatelessWidget {
  final VoidCallback onTap;

  final String title;
  final String subtitle;

  final TextStyle titleStyle;
  final TextStyle subtitleStyle;

  final IconCard iconCard;

  PassScreenButton(
      {this.title = "",
      this.subtitle = "",
      this.titleStyle = const TextStyle(color: Constants.iWhite, fontSize: Constants.normalFontSize, fontWeight: FontWeight.bold),
      this.subtitleStyle = const TextStyle(color: Constants.iLight, fontSize: Constants.smallFontSize, fontWeight: FontWeight.bold),
      required this.iconCard,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      color: Constants.iDarkGrey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.0),
        onTap: () {
          if (onTap != null) onTap();
        },
        child: Container(
          child: Padding(
            padding: const EdgeInsets.only(top: 5, left: 25.0, right: 10, bottom: 5),
            child: Stack(children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 35),
                  Text(
                    title,
                    style: titleStyle,
                  ),
                  SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: subtitleStyle,
                  ),
                  SizedBox(height: 10),
                ],
              ),
              Positioned(right: 0.0, top: 0.0, child: iconCard ?? Container()),
            ]),
          ),
        ),
      ),
    );
  }
}
