// @dart=2.9

import 'package:auto_size_text/auto_size_text.dart';
import 'package:blackbox/Constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreenButton extends StatelessWidget {
  final String _title;
  final String _description;
  final IconData icon;
  final VoidCallback onTap;
  final bool wifi;
  final bool loggedIn;

  HomeScreenButton(this._title, this._description, this.wifi, this.loggedIn,
      {this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Constants.iDarkGrey,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.0),
        splashColor: Constants.iAccent,
        onTap: () {
          if (wifi && loggedIn) {
            if (onTap != null) onTap();
          }
        },
        child: Container(
          padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                this.icon,
                color:
                    (wifi && loggedIn) ? Constants.iAccent : Constants.iLight,
                size: 35,
              ),
              SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                      //mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          this._title,
                          style: TextStyle(
                              fontSize: Constants.normalFontSize,
                              color: (wifi && loggedIn)
                                  ? Constants.iWhite
                                  : Constants.iLight,
                              fontWeight: FontWeight.w400),
                        ),
                        this._title == "Party Mode"
                            ? Card(
                                color: Constants.iAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(3),
                                  child: Text(
                                    "New!",
                                    style: TextStyle(
                                        fontSize: Constants.smallFontSize,
                                        color: Constants.iBlack,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              )
                            : SizedBox()
                      ]),
                  SizedBox(height: 5),
                  Container(
                    width: 210,
                    child: AutoSizeText(
                      wifi
                          ? (loggedIn ? this._description : "Login to enable")
                          : "Internet required",
                      style: TextStyle(
                          fontSize: Constants.smallFontSize,
                          color: Constants.iLight,
                          fontWeight: FontWeight.w300),
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
