import 'package:blackbox/Interfaces/Database.dart';
import 'package:flutter/material.dart';
import '../../Constants.dart';
import '../JoinGameScreen.dart';

class JoinGameBox {
  static Widget joinGame(BuildContext context, Database database) {
    return Hero(
        tag: 'frfr',
        child: Card(
          color: Constants.iDarkGrey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: InkWell(
              borderRadius: BorderRadius.circular(16.0),
              splashColor: Constants.colors[Constants.colorindex],
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => JoinGameScreen(database),
                    ));
              },
              child: Container(
                  padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.search,
                        color: Constants.colors[Constants.colorindex],
                        size: 35,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Join Game",
                            style: TextStyle(fontSize: 30.0, color: Constants.iWhite, fontWeight: FontWeight.w400),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Join with the group code",
                            style: TextStyle(fontSize: 20.0, color: Constants.iLight, fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                    ],
                  ))),
        ));
  }
}
