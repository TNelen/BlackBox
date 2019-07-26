import 'package:flutter/material.dart';
import '../main.dart';
import '../DataContainers/GroupData.dart';
import '../Constants.dart';
import 'QuestionScreen.dart';

class ResultScreen extends StatefulWidget {
  @override
  ResultScreenState createState() => ResultScreenState();
}

class ResultScreenState extends State<ResultScreen> {
  int currentpage = 2;

  final controller = PageController(
    initialPage: 0,
    keepPage: false,
    viewportFraction: 0.85,
  );

  @override
  dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final winner = Hero(
      tag: 'submit',
      child: Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 30),
      padding: EdgeInsets.only(top: height / 10, bottom: height / 10),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
        color: Colors.white,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'WINNER',
                    style: new TextStyle(
                        color: Colors.amber,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'de winnaar van deze ronde',
                    style: new TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),),
    );

    final top3 = Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 30),
      padding: EdgeInsets.only(top: height / 10, bottom: height / 10),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
        color: Colors.white,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'TOP 3',
                    style: new TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'de top 3 van deze ronde',
                    style: new TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    final alltime = Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 30),
      padding: EdgeInsets.only(top: height / 10, bottom: height / 10),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
        color: Colors.white,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'ALL TIME TOP 3',
                    style: new TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'top 3 van alle vragen',
                    style: new TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    final nextButton = Hero(
        tag: 'button',
        child:Container(
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 30),
        padding: EdgeInsets.only(top: height / 10, bottom: height / 10),
        child:Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.amber,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(20),
        onPressed: () {

          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => QuestionScreen(),
              ));

        },
        //change isplaying field in database for this group to TRUE
        child: Text("Next Question",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30)
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    ),),);

    return MaterialApp(
      theme: new ThemeData(scaffoldBackgroundColor: Colors.black),
      home: Scaffold(
        appBar: AppBar(
          title: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.amber,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          backgroundColor: Colors.black,
        ),
        body: PageView(
          controller: controller,
          children: <Widget>[
            winner,
            top3,
            alltime,
            nextButton,
          ],
        ),
      ),
    );
  }
}
