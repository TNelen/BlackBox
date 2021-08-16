import 'package:blackbox/Constants.dart';
import 'package:blackbox/Screens/popups/Popup.dart';
import 'package:blackbox/Screens/widgets/pickable_rating.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:blackbox/translations/translations.i18n.dart';

class RatePopup extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RatePopupState();
  }
}

class _RatePopupState extends State<RatePopup> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Constants.iBlack,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0))),
      title: Text(
        'Rate this app'.i18n,
        style: TextStyle(
            fontFamily: 'roboto',
            color: Constants.iBlue,
            fontSize: Constants.normalFontSize),
      ),
      content: Container(
        height: 90,
        child: Column(
          children: [
            Text(
              'If you like the app, please consider giving it a rating in the play store. '
                  .i18n,
              style: TextStyle(
                  fontFamily: 'roboto',
                  color: Constants.iWhite,
                  fontSize: Constants.smallFontSize),
            ),
            PickableRating(
              size: 30.0,
              onTap: (rating) {
                Navigator.pop(context);

                FirebaseAnalytics().logEvent(
                    name: 'in_app_rating', parameters: {'score': rating});

                if (rating > 3) {
                  StoreRedirect.redirect();
                } else if (rating >= 2) {
                  Popup.makeNotSatisfiedPopup(
                    context,
                    'Hi there!'.i18n,
                    'We would like to hear how we can improve the app for you! Do not hesitate to contact us! We will do our best to provide the best possible experience for all players. '
                        .i18n,
                  );
                } else {
                  Popup.makeNotSatisfiedPopup(
                    context,
                    'Woops',
                    'We are very sorry to hear that you are not satisfied with our app. Please contact us with your issue and we will do our best to improve your experience'
                        .i18n,
                  );
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        FlatButton(
          child: Text(
            'Close'.i18n,
            style: TextStyle(
                fontFamily: 'roboto',
                color: Constants.iAccent,
                fontSize: Constants.actionbuttonFontSize,
                fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
