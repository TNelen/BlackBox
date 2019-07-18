import 'package:flutter/material.dart';
import '../Interfaces/Database.dart';

import '../DataContainers/GroupData.dart';









class GroupScreen extends StatelessWidget {
  GroupScreen(this.groupInfo) : super();
  final GroupData groupInfo;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: new ThemeData(scaffoldBackgroundColor: Colors.black,
      ),
      home: Scaffold(
          body: DefaultTabController(
              length: 3,
              child: Scaffold(

                appBar: AppBar(

                  title: Text(groupInfo.groupName,
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: Colors.black,
                  bottom: TabBar(
                    indicatorColor: Colors.amber,
                    indicatorSize: TabBarIndicatorSize.label,

                    tabs: [
                      new Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          new Icon(
                            Icons.info_outline,
                            color: Colors.white,
                            //size: 25,

                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            child: Text(
                              'Info',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      new Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.people_outline,
                            color: Colors.white,
                            //size: 25,

                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            child: Text(
                              'Members',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      new Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.settings,
                            color: Colors.white,
                            //size: 25,

                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            child: Text(
                              'Settings',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                ),
                body: TabBarView(children: [

                  //tab 1
                  new Text('Info',
                  style: new TextStyle(color: Colors.white, fontSize: 20.0),),

                  //tab 2
                  GridView.count(
                  crossAxisCount: 2,
                  padding: EdgeInsets.all(8.0),
                  crossAxisSpacing: 12.0,
                  mainAxisSpacing: 12.0,
                  children: groupInfo.members
                      .map((data) => Card(
                    color: data == groupInfo.adminID  ? Colors.amber : Colors.white
                    ,
                    child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child:data == groupInfo.adminID  ?

                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                            Text(data,
                              style: new TextStyle(color: Colors.black, fontSize: 20.0,fontWeight: FontWeight.bold),),
                            Text('Admin',
                              style: new TextStyle(color: Colors.black, fontSize: 15.0,fontWeight: FontWeight.bold),),],),) :

                          Text(data,
                            style: new TextStyle(color: Colors.black, fontSize: 20.0,fontWeight: FontWeight.bold),)


                              ,
                        )),
                  ))
                      .toList(),
                ),

                //tab 3
                  new Text('settings',
                    style: new TextStyle(color: Colors.white, fontSize: 20.0),),

                ],

          )
              ),
      ),
        bottomNavigationBar:
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,

            children: [
              RaisedButton(
                onPressed: () => Navigator.pop(context),

                color: Colors.amber,
                child: Text('Back', style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                )
                ),

              ),
              RaisedButton(
                onPressed: () {//NOTHING YET
                },
                color: Colors.amber,
                child: Text('Start', style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                )
                ),

              )
            ],
          ),
        )
    ),
    );
  }


}





