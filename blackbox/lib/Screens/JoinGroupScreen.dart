import 'package:flutter/material.dart';

class JoinGroupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                  'Join group',
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  padding: const EdgeInsets.all(30.0),
                  color: Colors.black,
                  child: new Container(
                    child: new Center(
                        child: new Column(children: [
                      new Padding(padding: EdgeInsets.only(top: 140.0)),
                      new Text(
                        'Enter group code below',
                        style:
                            new TextStyle(color: Colors.amber, fontSize: 25.0),
                      ),
                      new Padding(padding: EdgeInsets.only(top: 20.0)),
                      new TextField(
                        style: new TextStyle(color: Colors.white),
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: "Code",
                          hintStyle: TextStyle(color: Colors.white),
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                        //fillColor: Colors.green
                      ),
                    ])),
                  ))
            ],
          ),
        ));
  }
}