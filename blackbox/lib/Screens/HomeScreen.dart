import 'package:blackbox/Assets/questions.dart';
import 'package:blackbox/Screens/popups/Popup.dart';
import 'package:blackbox/Screens/widgets/CategoryCard.dart';
import 'package:blackbox/Screens/widgets/PopularCategoryCard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'SetPlayersScreen.dart';
import 'animation/SlidePageRoute.dart';
import 'widgets/HomeScreenTopIcons.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import '../Constants.dart';
import 'package:blackbox/translations/translations.i18n.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen() {}

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  _HomeScreenState() {
    FirebaseAnalytics().logEvent(
        name: 'open_screen', parameters: {'screen_name': 'HomeScreen'});
  }

  bool setScrollable = true;
  List<Category> selectedCategory = [];

  void handleOfflinePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Constants.setSoundEnabled(prefs.getBool("sounds"));
    Constants.setVibrationEnabled(prefs.getBool("vibration"));
    Constants.setNotificationsEnabled(prefs.getBool("notifications"));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final nextButton = Hero(
        tag: 'tobutton',
        child: Padding(
          padding: EdgeInsets.only(left: 45, right: 45),
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(26.0),
            color: Constants.colors[Constants.colorindex],
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(26.0),
              ),
              minWidth: MediaQuery.of(context).size.width,
              padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
              onPressed: () {
                if (selectedCategory.length != 0) {
                  Navigator.push(
                      context,
                      SlidePageRoute(
                          fromPage: widget,
                          toPage: SetPlayersScreen(selectedCategory)));
                } else {
                  Popup.makePopup(context, "Woops!".i18n,
                      "Please select one or more categories!".i18n);
                }
              },
              child: Text("Next".i18n,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: Constants.actionbuttonFontSize)
                      .copyWith(
                          color: Constants.iDarkGrey,
                          fontWeight: FontWeight.bold)),
            ),
          ),
        ));

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
                  child: Column(
                    //shrinkWrap: true,

                    children: [
                      SizedBox(
                        height: 25,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                width: MediaQuery.of(context).size.width * 0.75,
                                child: IconBar()),
                          ]),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                          padding: EdgeInsets.only(left: 30, right: 30),
                          child: Text("Select one or more categories...".i18n,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Constants.colors[Constants.colorindex],
                                  fontSize: Constants.normalFontSize,
                                  fontWeight: FontWeight.w300))),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 30, right: 30),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Popular'.i18n,
                            style: TextStyle(
                                fontSize: Constants.normalFontSize,
                                color: Constants.iWhite,
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(
                        height: MediaQuery.of(context).size.height / 5.5,
                        child: ListView.builder(
                          padding: EdgeInsets.only(left: 30),
                          scrollDirection: Axis.horizontal,
                          itemCount: popularcategories.length,
                          itemBuilder: (BuildContext context, int index) =>
                              PopularCategoryCard(
                            selectedCategory.contains(popularcategories[index]),
                            popularcategories[index].categoryName.i18n,
                            popularcategories[index].description.i18n,
                            onTap: () {
                              if (!selectedCategory
                                  .contains(popularcategories[index])) {
                                selectedCategory.add(popularcategories[index]);
                              } else if (selectedCategory
                                  .contains(popularcategories[index])) {
                                selectedCategory
                                    .remove(popularcategories[index]);
                              }
                              setState(() {});
                            },
                            isNewFlag: popularcategories[index].isNew,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.only(left: 30, right: 30),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Other'.i18n,
                            style: TextStyle(
                                fontSize: Constants.normalFontSize,
                                color: Constants.iWhite,
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.only(left: 45, right: 45),
                        scrollDirection: Axis.vertical,
                        itemCount: categories.length,
                        itemBuilder: (BuildContext context, int index) =>
                            CategoryCard(
                          selectedCategory.contains(categories[index]),
                          categories[index].categoryName.i18n,
                          categories[index].description.i18n,
                          onTap: () {
                            if (!selectedCategory.contains(categories[index])) {
                              selectedCategory.add(categories[index]);
                            } else if (selectedCategory
                                .contains(categories[index])) {
                              selectedCategory.remove(categories[index]);
                            }
                            setState(() {});
                          },
                          isNewFlag: categories[index].isNew,
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                    ],
                  )),
              floatingActionButton: nextButton,
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
            ),
          )),
    );
  }
}
