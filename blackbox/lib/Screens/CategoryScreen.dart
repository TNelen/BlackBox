// @dart=2.9
import 'package:blackbox/Assets/questions.dart';
import 'package:blackbox/Screens/popups/HowToPopup.dart';

import 'package:blackbox/Screens/widgets/CategoryCard.dart';
import 'package:blackbox/main.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'SetPlayersScreen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import '../Constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CategoryScreen extends StatefulWidget {
  bool showHelp = false;
  bool showList;

  CategoryScreen({this.showHelp, this.showList});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  _CategoryScreenState() {
    FirebaseAnalytics.instance.logEvent(name: 'open_screen', parameters: {'screen_name': 'CategoryScreen'});
  }

  bool setScrollable = true;
  List<Category> selectedCategory = [];


  void openHelp() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return HowtoPopup();
      },
    );
  }

  @override
  void initState() {
    super.initState();
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
        splashColor: Constants.iBlue,
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => SetPlayersScreen(selectedCategory),
              ));
        },
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          height: 50,
          child: Padding(
            padding: const EdgeInsets.only(top: 3, left: 3.0, right: 3, bottom: 3),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              Text(
                'Next',
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
      ),
    );

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.transparent,
        ),
        home: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              color: Constants.black.withOpacity(0.7),
              child: ListView(
                children: [
                  SizedBox(
                    height: 45,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => SplashScreen(),
                            ));
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Icon(
                          Icons.chevron_left,
                          color: Constants.iLight,
                          size: 35,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Categories',
                          style: TextStyle(fontSize: 25, color: Constants.iWhite, fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        openHelp();
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: 25),
                        child: Icon(
                          Icons.help_outline_outlined,
                          color: Constants.iLight,
                          size: 20,
                        ),
                      ),
                    )
                  ]),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: selectedCategory.length == 0
                          ? Text("Select one or more categories...", textAlign: TextAlign.center, style: TextStyle(color: Constants.iLight, fontSize: 17, fontWeight: FontWeight.w300))
                          : selectedCategory.length == 1
                              ? Text(selectedCategory.length.toString() + " " + "category selected",
                                  textAlign: TextAlign.center, style: TextStyle(color: Constants.iLight, fontSize: 17, fontWeight: FontWeight.w300))
                              : Text(selectedCategory.length.toString() + " " + "categories selected",
                                  textAlign: TextAlign.center, style: TextStyle(color: Constants.iLight, fontSize: 17, fontWeight: FontWeight.w300))),
                  SizedBox(height: 15),
                  AnimationLimiter(
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(left: 20, right: 20),
                      scrollDirection: Axis.vertical,
                      physics: BouncingScrollPhysics(),
                      itemCount: categories.length,
                      itemBuilder: (BuildContext context, int index) => AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 500),
                          child: SlideAnimation(
                              verticalOffset: 25.0,
                              child: FadeInAnimation(
                                child: CategoryCard(
                                  selectedCategory.contains(categories[index]),
                                  categories[index],
                                  onTap: () {
                                    if (!selectedCategory.contains(categories[index])) {
                                      selectedCategory.add(categories[index]);
                                    } else if (selectedCategory.contains(categories[index])) {
                                      selectedCategory.remove(categories[index]);
                                    }
                                    setState(() {});
                                  },
                                  isNewFlag: categories[index].isNew,
                                ),
                              ))),
                    ),
                  ),
                  SizedBox(
                    height: 80,
                  ),
                ],
              )),
          floatingActionButton: selectedCategory.length != 0 ? nextButton : SizedBox(),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        ),
      ),
    );
  }
}
