import 'package:blackbox/Interfaces/Database.dart';
import 'package:flutter/material.dart';
import '../../Constants.dart';
import '../CreateGameScreen.dart';

class CreateGameBox {
  static Widget createGame(BuildContext context, Database database) {
    return Hero(
        tag: 'toberutton',
        child: Card(
          color: Constants.iDarkGrey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: InkWell(
              borderRadius: BorderRadius.circular(16.0),
              splashColor: Constants.colors[Constants.colorindex],
              onTap: () {
                // if (GoogleUserHandler.isLoggedIn()) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          CreateGameScreen(database),
                    ));
                // } else {
                //Popup.makePopup(context, "Wait!", "You should be logged in to do that.");
                //}
              },
              child: Container(
                  padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.edit,
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
                            "Create Game",
                            style: TextStyle(
                                fontSize: 30.0,
                                color: Constants.iWhite,
                                fontWeight: FontWeight.w400),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Invite friends to a new game",
                            style: TextStyle(
                                fontSize: 20.0,
                                color: Constants.iLight,
                                fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                    ],
                  ))),
        ));
  }
}
