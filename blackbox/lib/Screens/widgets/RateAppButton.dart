import 'package:blackbox/Interfaces/Database.dart';
import 'package:blackbox/Screens/popups/rate_popup.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import '../../Constants.dart';

class RateAppButton {
  static Widget rateAppButton(BuildContext context, Database database) {
    return FlatButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "rate this app",
              style: TextStyle(color: Constants.colors[Constants.colorindex], fontSize: Constants.smallFontSize, fontWeight: FontWeight.w300),
            ),
            SizedBox(
              width: 10,
            ),
            Icon(
              Icons.star,
              color: Constants.colors[Constants.colorindex],
              size: 15,
            ),
          ],
        ),
        onPressed: () {
          FirebaseAnalytics().logEvent(name: 'button_pressed', parameters: {'button_name': 'RateAppButton'});

          showDialog(
            context: context,
            child: RatePopup(),
          );

        });
  }
}
