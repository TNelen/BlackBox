// @dart=2.9
import 'package:blackbox/Assets/questions.dart';
import 'package:blackbox/Screens/widgets/CategoryCard.dart';
import 'package:blackbox/Util/Curves.dart';
import 'SetPlayersScreen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import '../Constants.dart';
import 'package:blackbox/translations/translations.i18n.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CategoryScreen extends StatefulWidget {
  CategoryScreen() {}

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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final nextButton = Card(
      elevation: 5.0,
      color: Constants.iLight,
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
                        color: Constants.iDarkGrey,
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  FaIcon(
                    FontAwesomeIcons.chevronCircleRight,
                    size: 22,
                    color: Constants.iDarkGrey,
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
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    CustomPaint(
                      painter: CategoryTopCurvePainter(),
                    ),
                    Column(
                      //shrinkWrap: true,

                      children: [
                        SizedBox(
                          height: 45,
                        ),
                        Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: Text("Select one or more categories...".i18n,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Constants.iWhite,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w300))),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(height: 15),
                        Container(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Categories'.i18n,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.lightBlueAccent[100]
                                      .withOpacity(0.75),
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.only(left: 30, right: 30),
                          scrollDirection: Axis.vertical,
                          itemCount: categories.length,
                          itemBuilder: (BuildContext context, int index) =>
                              CategoryCard(
                            selectedCategory.contains(categories[index]),
                            categories[index],
                            onTap: () {
                              if (!selectedCategory
                                  .contains(categories[index])) {
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
                    )
                  ],
                ),
              ),
              floatingActionButton:
                  selectedCategory.length != 0 ? nextButton : SizedBox(),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
            ),
          )),
    );
  }
}
