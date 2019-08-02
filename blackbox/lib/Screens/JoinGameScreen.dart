import 'package:flutter/material.dart';

class JoinGameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final joinButton = Hero(
      tag: 'tobutton',
      child: Padding(
        padding: const EdgeInsets.all(36),
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(30.0),
          color: Colors.amber,
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(1.0, 15.0, 20.0, 15.0),
            onPressed: () {
              ///to groupscreen
            },
            child: Text("Join Group",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20).copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );

    final codeField = TextField(
      obscureText: false,
      style: TextStyle(fontSize: 20, color: Colors.black),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          fillColor: Colors.white,
          filled: true,
          hintText: "Game code",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    return MaterialApp(
        title: 'BlackBox',
        theme: new ThemeData(scaffoldBackgroundColor: Colors.black),
        home: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.amber,
                        ),
                      )),
                  Text(
                    'Join game',
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    color: Colors.black,
                    child: Padding(
                      padding: const EdgeInsets.all(36.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Enter group code below',
                            style: new TextStyle(
                                color: Colors.amber, fontSize: 25.0),
                          ),
                          SizedBox(height: 25.0),
                          codeField,
                        ],
                      ),
                    ),
                  ),
                ),
                joinButton,
              ],
            )));
  }
}