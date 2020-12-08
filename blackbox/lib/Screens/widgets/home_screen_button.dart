import 'package:auto_size_text/auto_size_text.dart';
import 'package:blackbox/Constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreenButton extends StatelessWidget {
  final String _title;
  final String _description;
  final IconData icon;
  final VoidCallback onTap;
  final bool enable;

  HomeScreenButton(this._title, this._description, this.enable,
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
        splashColor: Constants.colors[Constants.colorindex],
        onTap: () {
          if (onTap != null) onTap();
        },
        child: Container(
          padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                this.icon,
                color: enable
                    ? Constants.colors[Constants.colorindex]
                    : Constants.iLight,
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
                              color:
                                  enable ? Constants.iWhite : Constants.iLight,
                              fontWeight: FontWeight.w400),
                        ),
                        this._title == "Party Mode"
                            ? Card(
                                color: Constants.colors[Constants.colorindex],
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
                    width: 230,
                    child: AutoSizeText(
                      enable ? this._description : "Login to enable",
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
