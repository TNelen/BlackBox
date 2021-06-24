// @dart=2.9
import 'package:blackbox/Assets/questions.dart';
import 'package:blackbox/Screens/rules_column.dart';
import 'package:blackbox/Screens/widgets/CategoryCard.dart';
import '../main.dart';
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
  final bool showHelp;

  CategoryScreen({this.showHelp});

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

    widget.showHelp
        ? WidgetsBinding.instance.addPostFrameCallback((_) async {
            await showDialog<String>(
              context: context,
              builder: (BuildContext context) => new AlertDialog(
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
                          color: Constants.iAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12.0),
                            // splashColor: Constants.iAccent,
                            onTap: () {
                              Navigator.pop(context);
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
            );
          })
        : null;
  }

  @override
  Widget build(BuildContext context) {
    final nextButton = Hero(
      tag: "actionbutton",
      child: Card(
        //elevation: 5.0,
        color: Constants.iAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12.0),
          // splashColor: Constants.iAccent,
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) =>
                      SetPlayersScreen(selectedCategory),
                ));
          },
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Container(
              width: MediaQuery.of(context).size.width / 2,
              height: 30,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Next".i18n,
                      style: TextStyle(
                          fontFamily: "roboto",
                          color: Constants.iWhite,
                          fontSize: Constants.smallFontSize,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    FaIcon(
                      FontAwesomeIcons.chevronRight,
                      color: Constants.iWhite,
                    ),
                  ]),
            ),
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

          // IconButton(
          //               icon: FaIcon(
          //                 FontAwesomeIcons.chevronLeft,
          //                 color: Constants.iLight,
          //               ),
          //               onPressed: () {
          //                 Navigator.push(
          //                     context,
          //                     MaterialPageRoute(
          //                       builder: (BuildContext context) =>
          //                           SplashScreen(),
          //                     ));
          //               })
          home: I18n(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                        leading: IconButton(
                            icon: FaIcon(
                              FontAwesomeIcons.chevronLeft,
                              color: Constants.iLight,
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        SplashScreen(),
                                  ));
                            }),
                        expandedHeight: 200.0,
                        floating: false,
                        backgroundColor: Constants.grey,
                        pinned: true,
                        flexibleSpace: FlexibleSpaceBar(
                          centerTitle: true,
                          title: Text(
                            "Categories".i18n,
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: "roboto",
                                color: Constants.iWhite,
                                fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          ),
                          background: Image.asset(
                            "images/questions.png",
                            scale: 1,
                          ),
                        )),
                  ];
                },
                body: Container(
                    color: Constants.grey,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Card(
                          elevation: 0.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35.0),
                          ),
                          color: Constants.grey,
                          child: Container(
                            width: MediaQuery.of(context).size.width - 30,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 5,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  selectedCategory.length == 0
                                      ? Text(
                                          "Please select one or more categories"
                                              .i18n,
                                          style: TextStyle(
                                              fontSize: Constants.smallFontSize,
                                              fontFamily: "roboto",
                                              color: Constants.iWhite
                                                  .withOpacity(0.8),
                                              fontWeight: FontWeight.w300),
                                          textAlign: TextAlign.center,
                                        )
                                      : Text(
                                          "${selectedCategory.length} categories selected"
                                              .i18n,
                                          style: TextStyle(
                                              fontSize: Constants.smallFontSize,
                                              fontFamily: "roboto",
                                              color: Constants.iWhite
                                                  .withOpacity(0.8),
                                              fontWeight: FontWeight.w300),
                                          textAlign: TextAlign.center,
                                        ),
                                  SizedBox(
                                    height: 25,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 550,
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 200,
                                    childAspectRatio: 10 / 7,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10),
                            shrinkWrap: true,
                            padding: EdgeInsets.only(left: 15, right: 15),
                            scrollDirection: Axis.vertical,
                            itemCount: categories.length,
                            physics: ClampingScrollPhysics(),
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
                        ),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    )),
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
