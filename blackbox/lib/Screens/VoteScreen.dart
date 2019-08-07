import 'package:flutter/material.dart';
import '../main.dart';
import '../DataContainers/GroupData.dart';
import '../Constants.dart';
import 'ResultsScreen.dart';

class VoteScreen extends StatefulWidget {
  @override
  _VoteScreenState createState() => _VoteScreenState();
}

class _VoteScreenState extends State<VoteScreen> {
  Color color;
  String clickedmember;

  @override
  void initState() {
    super.initState();

    color = Colors.white;
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0))),
          title: new Text(
            "No members selected",
            style: TextStyle(color: Colors.black, fontSize: 25),
          ),
          content: new Text(
            "Please make a valid choice",
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Close",
                style: TextStyle(
                    color: Colors.amber,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    ///used to choose between different groups to get the members
    final int index = 5;

    final voteButton = Hero(
      tag: 'submit',
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(30.0),
          color: Colors.amber,
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(1.0, 15.0, 20.0, 15.0),
            onPressed: () {
              if (clickedmember != null) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => ResultScreen(),
                    ));
              } else {
                _showDialog();
              }
            },
            child: Text("Submit choice",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20).copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );

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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: GridView.count(
                crossAxisCount: 2,
                padding: EdgeInsets.all(8.0),
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
                children: Constants.groupData[index]
                    .getMembers()
                    .map((data) => Card(
                          color: data.getUserID() == clickedmember
                              ? Colors.amber
                              : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0),
                          ),
                          child: InkWell(
                            splashColor: Colors.amber.withAlpha(60),
                            onTap: () {
                              setState(() {
                                color = Colors.amber;
                                clickedmember = data.getUserID();
                              });
                            },
                            child: Container(
                              child: Center(
                                  child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  data.getUserID(),
                                  style: new TextStyle(
                                      color: Colors.black,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
            voteButton,
          ],
        ),
      ),
    );
  }
}
