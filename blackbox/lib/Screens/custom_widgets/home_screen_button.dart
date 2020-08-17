import 'package:blackbox/Constants.dart';
import 'package:flutter/material.dart';

class HomeScreenButton extends StatelessWidget {
  
  final String _title;
  final String _description;
  final IconData icon;
  final VoidCallback onTap;

  HomeScreenButton(this._title, this._description, {this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Constants.iDarkGrey,
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
                    this._title,
                    style: TextStyle(
                      fontSize: 30.0,
                      color: Constants.iWhite,
                      fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: 5),
                  Text(
                    this._description,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Constants.iLight,
                      fontWeight: FontWeight.w300
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