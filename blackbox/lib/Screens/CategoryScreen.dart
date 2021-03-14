import 'package:blackbox/Assets/questions.dart';
import 'package:blackbox/Screens/widgets/CategoryCard.dart';
import 'package:blackbox/Screens/widgets/PopularCategoryCard.dart';
import 'package:blackbox/Screens/widgets/SelectedCategoryCard%20copy.dart';
import 'SetPlayersScreen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import '../Constants.dart';
import 'package:blackbox/translations/translations.i18n.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.lightBlueAccent[100].withOpacity(0.5);
    paint.style = PaintingStyle.fill; // Change this to fill

    var path = Path();

    path.moveTo(0, size.height * 0.09);
    path.quadraticBezierTo(size.width * 0.1, size.height * 0.12,
        size.width * 0.5, size.height * 0.12);
    path.quadraticBezierTo(size.width * 0.9, size.height * 0.12,
        size.width * 1.0, size.height * 0.18);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

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
        splashColor: Constants.colors[Constants.colorindex],
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    SetPlayersScreen(selectedCategory),
              ));
        },
        child: Container(
          width: MediaQuery.of(context).size.width / 9,
          height: 50,
          child: Padding(
            padding:
                const EdgeInsets.only(top: 3, left: 3.0, right: 3, bottom: 3),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                'Next '.i18n,
                style: TextStyle(
                    fontSize: Constants.miniFontSize,
                    color: Constants.iDarkGrey,
                    fontWeight: FontWeight.w500),
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
                      painter: CurvePainter(),
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
                          height: MediaQuery.of(context).size.height / 12,
                          child: Row(children: [
                            Expanded(
                              flex: 3,
                              child: selectedCategory.length == 0
                                  ? Container(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              13,
                                      padding:
                                          EdgeInsets.only(left: 20, right: 20),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'None selected'.i18n,
                                          style: TextStyle(
                                              fontSize: Constants.miniFontSize,
                                              color: Constants.iLight,
                                              fontWeight: FontWeight.w300),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              13,
                                      child: ListView.builder(
                                        padding: EdgeInsets.only(left: 20),
                                        scrollDirection: Axis.horizontal,
                                        itemCount: selectedCategory.length,
                                        itemBuilder:
                                            (BuildContext context, int index) =>
                                                SelectedCategoryCard(
                                          selectedCategory[index],
                                          onTap: () {
                                            selectedCategory.remove(
                                                selectedCategory[index]);

                                            setState(() {});
                                          },
                                          isNewFlag:
                                              selectedCategory[index].isNew,
                                        ),
                                      ),
                                    ),
                            ),
                            Expanded(
                                flex: 1,
                                child: selectedCategory.length == 0
                                    ? SizedBox()
                                    : nextButton)
                          ]),
                        ),
                        SizedBox(height: 15),
                        Container(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Popular'.i18n,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.lightBlueAccent[100]
                                      .withOpacity(0.75),
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Container(
                          height: MediaQuery.of(context).size.height / 5.5,
                          child: ListView.builder(
                            padding: EdgeInsets.only(left: 20),
                            scrollDirection: Axis.horizontal,
                            itemCount: popularcategories.length,
                            itemBuilder: (BuildContext context, int index) =>
                                PopularCategoryCard(
                              selectedCategory
                                  .contains(popularcategories[index]),
                              popularcategories[index],
                              onTap: () {
                                if (!selectedCategory
                                    .contains(popularcategories[index])) {
                                  selectedCategory
                                      .add(popularcategories[index]);
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
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Other'.i18n,
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
            ),
          )),
    );
  }
}
