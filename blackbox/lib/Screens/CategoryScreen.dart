// @dart=2.9
import 'package:blackbox/Assets/questions.dart';
import 'package:blackbox/Screens/rules_column.dart';
import 'package:blackbox/Screens/widgets/CategoryCard.dart';
import 'package:blackbox/Util/Curves.dart';
import 'package:blackbox/main.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'SetPlayersScreen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import '../Constants.dart';
import 'package:blackbox/translations/translations.i18n.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'animation/ScaleDownPageRoute.dart';

class CategoryScreen extends StatefulWidget {
  final bool showHelp;
  bool showList;

  CategoryScreen({this.showHelp, this.showList});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  _CategoryScreenState() {
    FirebaseAnalytics().logEvent(
        name: 'open_screen', parameters: {'screen_name': 'CategoryScreen'});
  }

  bool setScrollable = true;
  List<Category> selectedCategory = [];

  bool showList = false;

  @override
  void initState() {
    super.initState();

    widget.showHelp
        ? WidgetsBinding.instance.addPostFrameCallback((_) async {
            await showDialog<String>(
              context: context,
              builder: (BuildContext context) => DelayedDisplay(
                delay: Duration(milliseconds: 0),
                child: AlertDialog(
                  backgroundColor: Constants.iDarkGrey,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(24.0))),
                  title: Center(
                    child: Text(
                      "How to play".i18n,
                      style: TextStyle(
                          fontFamily: "roboto",
                          color: Constants.iWhite,
                          fontWeight: FontWeight.w300,
                          fontSize: Constants.normalFontSize),
                    ),
                  ),
                  content: Container(
                      height: 400,
                      child: Column(
                        children: [
                          RulesColumn(),
                          Card(
                            //elevation: 5.0,
                            color: Constants.iBlue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12.0),
                              // splashColor: Constants.iAccent,
                              onTap: () {
                                Navigator.pop(context);
                                setState(() {
                                  widget.showList = true;
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 2,
                                  height: 30,
                                  child: Center(
                                    child: Text(
                                      "I got it!".i18n,
                                      style: TextStyle(
                                          fontFamily: "roboto",
                                          color: Constants.iWhite,
                                          fontSize: Constants.smallFontSize,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
              ),
            ).then((val) {
              setState(() {
                widget.showList = true;
              });
            });
          })
        : null;
  }

  @override
  Widget build(BuildContext context) {
    final nextButton = Card(
      elevation: 5.0,
      color: Constants.iBlue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0),
        splashColor: Constants.iAccent,
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    SetPlayersScreen(selectedCategory),
              ));
        },
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          height: 50,
          child: Padding(
            padding:
                const EdgeInsets.only(top: 3, left: 3.0, right: 3, bottom: 3),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Next'.i18n,
                    style: TextStyle(
                        fontFamily: "roboto",
                        fontSize: Constants.smallFontSize,
                        color: Constants.iWhite,
                        fontWeight: FontWeight.w500),
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
      ),
    );

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
            scaffoldBackgroundColor: Colors.transparent,
          ),
          home: I18n(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
              color: Constants.black.withOpacity(0.7),
                  child: Column(
                    //shrinkWrap: true,

                    children: [
                      SizedBox(
                        height: 45,
                      ),
                      Row(children: [
                        Expanded(
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    ScaleDownPageRoute(
                                      fromPage: CategoryScreen(
                                        showHelp: false,
                                      ),
                                      toPage: SplashScreen(),
                                    ));
                              },
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(right: 10),
                                    child: Icon(
                                      Icons.chevron_left,
                                      color: Constants.iLight,
                                      size: 35,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            flex: 1),
                        Container(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Categories'.i18n,
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Constants.iWhite,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                        Expanded(child: SizedBox(), flex: 1),
                      ]),
                      SizedBox(
                        height: 20,
                      ),
                      widget.showList
                          ? Container(
                              padding: EdgeInsets.only(left: 5, right: 5),
                              child: selectedCategory.length == 0
                                  ? Text(
                                      "Select one or more categories...".i18n,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Constants.iLight,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w300))
                                  : selectedCategory.length == 1
                                      ? Text(
                                          selectedCategory.length.toString() +
                                              " " +
                                              "category selected".i18n,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Constants.iLight,
                                              fontSize: 17,
                                              fontWeight: FontWeight.w300))
                                      : Text(
                                          selectedCategory.length.toString() +
                                              " " +
                                              "categories selected".i18n,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Constants.iLight,
                                              fontSize: 17,
                                              fontWeight: FontWeight.w300)))
                          : SizedBox(),
                      SizedBox(height: 15),
                      widget.showList
                          ? AnimationLimiter(
                              child: ListView.builder(
                                shrinkWrap: true,
                                padding: EdgeInsets.only(left: 20, right: 20),
                                scrollDirection: Axis.vertical,
                                itemCount: categories.length,
                                itemBuilder: (BuildContext context,
                                        int index) =>
                                    AnimationConfiguration.staggeredList(
                                        position: index,
                                        duration:
                                            const Duration(milliseconds: 500),
                                        child: SlideAnimation(
                                            verticalOffset: 25.0,
                                            child: FadeInAnimation(
                                              child: CategoryCard(
                                                selectedCategory.contains(
                                                    categories[index]),
                                                categories[index],
                                                onTap: () {
                                                  if (!selectedCategory
                                                      .contains(
                                                          categories[index])) {
                                                    selectedCategory
                                                        .add(categories[index]);
                                                  } else if (selectedCategory
                                                      .contains(
                                                          categories[index])) {
                                                    selectedCategory.remove(
                                                        categories[index]);
                                                  }
                                                  setState(() {});
                                                },
                                                isNewFlag:
                                                    categories[index].isNew,
                                              ),
                                            ))),
                              ),
                            )
                          : SizedBox(),
                      SizedBox(
                        height: 50,
                      ),
                    ],
                  )),
              floatingActionButton:
                  selectedCategory.length != 0 ? nextButton : SizedBox(),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
            ),
          )),
    );
  }
}
