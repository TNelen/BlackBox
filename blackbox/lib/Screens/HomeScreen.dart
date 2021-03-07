import 'package:shared_preferences/shared_preferences.dart';
import 'CreatePartyScreen.dart';
import 'animation/ScalePageRoute.dart';
import 'widgets/HomeScreenTopIcons.dart';
import 'widgets/home_screen_button.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/painting.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import '../Constants.dart';
import 'package:blackbox/translations/homescreen.i18n.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


class HomeScreen extends StatefulWidget {
  bool enableOnlineMode = true;
  bool loggedIn = false;

  HomeScreen() {}

  @override
  _HomeScreenState createState() =>
      _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  _HomeScreenState() {

    FirebaseAnalytics().logEvent(
        name: 'open_screen', parameters: {'screen_name': 'HomeScreen'});
  }

  ScrollController _controller = ScrollController();
  bool setScrollable = true;

  void handleOfflinePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Constants.setSoundEnabled(prefs.getBool("sounds"));
    Constants.setVibrationEnabled(prefs.getBool("vibration"));
    Constants.setNotificationsEnabled(prefs.getBool("notifications"));
  }

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (setScrollable && _controller.position.extentAfter == 0)
        setState(() {
          setScrollable = false;
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: MaterialApp(
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('en', ''), // English, no country code
            const Locale('nl', ''), // nl, no country code
          ],
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: "atarian",
            scaffoldBackgroundColor: Colors.transparent,
          ),
          home: I18n(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    stops: [0.1, 0.9],
                    colors: [
                      Constants.gradient1,
                      Constants.gradient2,
                    ],
                  ),
                ),
                //margin: EdgeInsets.only(top: 16, left: 5, right: 5),
                child: ListView(
                  //shrinkWrap: true,
                  controller: _controller,
                  physics: setScrollable
                      ? AlwaysScrollableScrollPhysics()
                      : NeverScrollableScrollPhysics(),
                  children: [
                    SizedBox(
                      height: 5.0 * MediaQuery.of(context).devicePixelRatio,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              width: MediaQuery.of(context).size.width * 0.75,
                              child: IconBar()),
                        ]),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          SizedBox(
                            height: 25,
                          ),
                          Container(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Text(
                                "Welcome to BlackBox!".i18n,
                                style: TextStyle(
                                    color:
                                        Constants.colors[Constants.colorindex],
                                    fontSize: Constants.normalFontSize,
                                    fontWeight: FontWeight.w300),
                              )),
                          SizedBox(
                            height: 25,
                          ),
                        ]),
                    SizedBox(
                      height: 13 * MediaQuery.of(context).devicePixelRatio,
                    ),
                    Container(
                        padding: EdgeInsets.only(left: 45, right: 45),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(
                                  left: 10,
                                  bottom: 10 *
                                      MediaQuery.of(context).devicePixelRatio),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Who\'s playing...'.i18n,
                                  style: TextStyle(
                                      fontSize: Constants.subtitleFontSize,
                                      color: Constants.iWhite,
                                      fontWeight: FontWeight.w300),
                                ),
                              ),
                            ),
                            Hero(
                              tag: 'partymode',
                              child: HomeScreenButton(
                                  'Party Mode',
                                  'Play with all your friends on one single device'
                                      .i18n,
                                  true,
                                  true,
                                  icon: OMIcons.peopleOutline, onTap: () {
                                Navigator.push(context,
                                    ScaleUpPageRoute(CreatePartyScreen()));
                              }),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
