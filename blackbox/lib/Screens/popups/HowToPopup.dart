import 'package:blackbox/Constants.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:blackbox/translations/translations.i18n.dart';

class HowtoPopup extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HowtoPopupState();
  }
}

class _HowtoPopupState extends State<HowtoPopup> {
  final controller = PageController(initialPage: 0, viewportFraction: 0.9);
  GlobalKey<PageContainerState> key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return DelayedDisplay(
        delay: Duration(milliseconds: 0),
        child: AlertDialog(
            backgroundColor: Constants.iDarkGrey,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24.0))),
            title: Center(
              child: Text(
                "How to play",
                style: TextStyle(color: Constants.iWhite, fontWeight: FontWeight.w300, fontSize: Constants.normalFontSize),
              ),
            ),
            content: Container(
                width: 300,
                height: 300,
                child: PageIndicatorContainer(
                    indicatorSelectorColor: Constants.iBlue,
                    indicatorColor: Constants.iWhite,
                    key: key,
                    align: IndicatorAlign.bottom,
                    length: 4,
                    indicatorSpace: 10.0,
                    child: PageView(children: <Widget>[
                      Center(
                        child: Container(
                          width: 250,
                          height: 250,
                          child: Column(children: [
                            FaIcon(
                              FontAwesomeIcons.dice,
                              size: 35,
                              color: Constants.iBlue,
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              height: 120,
                              child: Text(
                                "Select one or more question categories".i18n,
                                style: TextStyle(color: Colors.white, fontSize: 20.0),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ]),
                        ),
                      ),
                      Center(
                        child: Container(
                          width: 250,
                          height: 250,
                          child: Column(children: [
                            FaIcon(
                              FontAwesomeIcons.users,
                              size: 35,
                              color: Constants.iBlue,
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              height: 120,
                              child: Text(
                                "Add all players".i18n,
                                style: TextStyle(color: Colors.white, fontSize: 20.0),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ]),
                        ),
                      ),
                      Center(
                        child: Container(
                          width: 300,
                          height: 250,
                          child: Column(children: [
                            FaIcon(
                              FontAwesomeIcons.questionCircle,
                              size: 35,
                              color: Constants.iBlue,
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                                height: 140,
                                child: Column(children: [
                                  Text(
                                    "Start playing!".i18n,
                                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    "1. Cast your vote".i18n,
                                    style: TextStyle(color: Constants.iLight, fontSize: 15.0),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "2. Pass the phone to the next player".i18n,
                                    style: TextStyle(color: Constants.iLight, fontSize: 15.0),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "3. Show results when all players voted".i18n,
                                    style: TextStyle(color: Constants.iLight, fontSize: 15.0),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "4. Start next round".i18n,
                                    style: TextStyle(color: Constants.iLight, fontSize: 15.0),
                                    textAlign: TextAlign.center,
                                  ),
                                ])),
                          ]),
                        ),
                      ),
                      Center(
                        child: Container(
                          width: 300,
                          height: 250,
                          child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                            FaIcon(
                              FontAwesomeIcons.chevronCircleRight,
                              size: 35,
                              color: Constants.iBlue,
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            MaterialButton(
                              //elevation: 5.0,
                              minWidth: 100,
                              height: 50,
                              color: Constants.iBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "I got it!".i18n,
                                style: TextStyle(color: Constants.iWhite, fontSize: Constants.smallFontSize, fontWeight: FontWeight.w400),
                              ),
                            ),
                            SizedBox(
                              height: 25,
                            )
                          ]),
                        ),
                      )
                    ])))));
  }
}
