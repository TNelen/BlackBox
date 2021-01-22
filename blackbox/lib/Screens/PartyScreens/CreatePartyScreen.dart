import 'package:blackbox/Assets/questions.dart';
import 'package:blackbox/Screens/widgets/CategoryCard.dart';
import 'package:blackbox/Screens/widgets/toggle_button_card.dart';
import 'package:flutter/material.dart';
import '../../Constants.dart';
import '../popups/Popup.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'SetPlayersScreen.dart';
import 'package:blackbox/translations/gameScreens.i18n.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
class CreatePartyScreen extends StatefulWidget {

  CreatePartyScreen() {
  }

  @override
  _CreatePartyScreenState createState() => _CreatePartyScreenState();
}

class _CreatePartyScreenState extends State<CreatePartyScreen> {

  _CreatePartyScreenState() {

    FirebaseAnalytics().logEvent(name: 'open_screen', parameters: {'screen_name': 'CreatePartyScreen'});
  }

  List<Category> selectedCategory = [];
  bool _canVoteBlank = false;
  Color color = Constants.iDarkGrey;

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
                      MaterialPageRoute(
                        builder: (BuildContext context) => SetPlayersScreen(selectedCategory, _canVoteBlank),
                      ));
                } else {
                  Popup.makePopup(context, "Woops!".i18n, "Please select one or more categories!".i18n);
                }
              },
              child: Text("Create".i18n, textAlign: TextAlign.center, style: TextStyle(fontSize: Constants.actionbuttonFontSize).copyWith(color: Constants.iDarkGrey, fontWeight: FontWeight.bold)),
            ),
          ),
        ));

    final categoryField = ListView.builder(
          shrinkWrap: true,
          // physics: ClampingScrollPhysics(),
          physics: NeverScrollableScrollPhysics(),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            String description = categories[index].getDescription();
            String categoryname =  categories[index].getCategoryName();
            return Column(children: [
              CategoryCard(
                selectedCategory.contains(categories[index]),
                categoryname,
                description,
                onTap: () {
                  if (!selectedCategory.contains(categories[index])) {
                    selectedCategory.add(categories[index]);
                  } else if (selectedCategory.contains(categories[index])) {
                    selectedCategory.remove(categories[index]);

                  }
                  setState(() {});
                },
              ),
              SizedBox(
                height: 5,
              )
            ]);
          },
        );

    return MaterialApp(
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
        scaffoldBackgroundColor: Constants.iBlack,
      ),
      home: I18n(child:Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            InkWell(
              onTap: () => Navigator.pop(context),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: Icon(
                      Icons.arrow_back,
                      color: Constants.colors[Constants.colorindex],
                    ),
                  ),
                  Text(
                    'Back'.i18n,
                    style: TextStyle(
                      fontSize: Constants.actionbuttonFontSize,
                      color: Constants.colors[Constants.colorindex],
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
        body: Center(
          child: Container(
            //color: Constants.iBlack,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomLeft,
                stops: [0.1, 1.0],
                colors: [
                  Constants.gradient1,
                  Constants.gradient2,
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 1),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return ListView(
                    padding: const EdgeInsets.only(left: 50, right: 50, top: 20, bottom: 20),
                    shrinkWrap: true,
                    children: <Widget>[
                      Hero(
                        tag: "PartHeader",
                        child: AutoSizeText(
                          "Create a new Party".i18n,
                          style: TextStyle(color: Constants.iWhite, fontSize: Constants.titleFontSize, fontWeight: FontWeight.w300),
                          maxLines: 1,
                        ),
                      ),
                      SizedBox(height: 30.0),
                      Text(
                        'Game settings'.i18n,
                        style: TextStyle(color: Constants.colors[Constants.colorindex], fontSize: Constants.normalFontSize),
                      ),
                      SizedBox(height: 20.0),
                      ToggleButtonCard(
                        'Blank vote'.i18n,
                        _canVoteBlank,
                        onToggle: (bool newValue) => _canVoteBlank = newValue,
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        'Choose categories'.i18n,
                        style: TextStyle(
                          color: Constants.colors[Constants.colorindex],
                          fontSize: Constants.normalFontSize,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      categoryField,
                      SizedBox(height: 75.0),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
        floatingActionButton: nextButton,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
      ),
    );
  }
}
