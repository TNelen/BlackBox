// @dart=2.9

import 'package:blackbox/Models/OfflineGroupData.dart';
import 'package:blackbox/Screens/PartyVoteScreen.dart';
import 'package:blackbox/Screens/animation/SlidePageRoute.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Constants.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';

class PartyQuestionScreen extends StatefulWidget {
  final OfflineGroupData offlineGroupData;

  @override
  PartyQuestionScreen(this.offlineGroupData) {}

  _PartyQuestionScreenState createState() => _PartyQuestionScreenState(offlineGroupData);
}

class _PartyQuestionScreenState extends State<PartyQuestionScreen> with WidgetsBindingObserver {
  Color color;
  String selectedPlayer;
  OfflineGroupData offlineGroupData;

  TextEditingController questionController = TextEditingController();

  _PartyQuestionScreenState(OfflineGroupData offlineGroupData) {
    this.offlineGroupData = offlineGroupData;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final nextButton = MaterialButton(
      elevation: 5.0,
      color: Constants.iBlue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      splashColor: Constants.iBlue,
      onPressed: () {
        //TODO
        Navigator.push(context, SlidePageRoute(fromPage: widget, toPage: PartyVoteScreen(offlineGroupData)));
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 2,
        height: 50,
        child: Padding(
          padding: const EdgeInsets.only(top: 3, left: 3.0, right: 3, bottom: 3),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Text(
              "Start Round",
              style: TextStyle(fontFamily: "roboto", fontSize: Constants.smallFontSize, color: Constants.iWhite, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              width: 5,
            ),
            FaIcon(
              FontAwesomeIcons.chevronRight,
              size: 18,
              color: Constants.iWhite,
            )
          ]),
        ),
      ),
    );

    final skipButton = InkWell(
      borderRadius: BorderRadius.circular(12.0),
      splashColor: Constants.iBlue,
      onTap: () {
        offlineGroupData.nextRound();
        Navigator.push(context, SlidePageRoute(fromPage: widget, toPage: PartyQuestionScreen(offlineGroupData)));
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 2,
        height: 50,
        child: Padding(
          padding: const EdgeInsets.only(top: 3, left: 3.0, right: 3, bottom: 3),
          child: Text(
            "Skip question",
            style: TextStyle(fontFamily: "roboto", fontSize: Constants.smallFontSize, color: Constants.iLight, fontWeight: FontWeight.w400),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "roboto",
        scaffoldBackgroundColor: Constants.iBlack,
      ),
      home: Scaffold(
        body: Builder(
            // Create an inner BuildContext so that the onPressed methods
            // can refer to the Scaffold with Scaffold.of().
            builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.only(bottom: 30, top: 70),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  DelayedDisplay(
                    delay: Duration(milliseconds: 0),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: 80,
                            ),
                            Text(
                              offlineGroupData.getCurrentQuestion().getQuestion(),
                              style: TextStyle(color: Constants.iWhite, fontSize: Constants.normalFontSize, fontWeight: FontWeight.w300),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: 220.0,
                                  child: Text(
                                    '- ' + offlineGroupData.getCurrentQuestion().getCategory() + ' -',
                                    style: TextStyle(color: Constants.iLight, fontSize: Constants.smallFontSize, fontWeight: FontWeight.w500),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      nextButton,
                      SizedBox(
                        height: 15,
                      ),
                      offlineGroupData.isGameEnded() ? SizedBox() : skipButton,
                    ],
                  )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
