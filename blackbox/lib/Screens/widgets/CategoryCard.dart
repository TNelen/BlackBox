import 'package:flutter/material.dart';
import '../../Constants.dart';

class CategoryCard extends StatefulWidget {
  final bool defaultValue;
  final String categoryname;
  final String description;
  final Function() onTap;
  bool isNewFlag = false;

  CategoryCard(this.defaultValue, this.categoryname, this.description,
      {this.onTap, Key key, this.isNewFlag})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CategoryCardState();
  }
}

class CategoryCardState extends State<CategoryCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      color: widget.defaultValue ? Constants.iLight : Constants.iDarkGrey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.0),
        splashColor: Constants.colors[Constants.colorindex],
        onTap: () {
          setState(() {
            if (widget.onTap != null) widget.onTap();
          });
        },
        child: Container(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 5, left: 10.0, right: 10, bottom: 5),
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          widget.categoryname,
                          style: TextStyle(
                              color: widget.defaultValue
                                  ? Constants.iDarkGrey
                                  : Constants.iWhite,
                              fontSize: Constants.normalFontSize,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        widget.isNewFlag
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
                            : SizedBox(
                                width: 1,
                              ),
                      ]),
                  SizedBox(height: 5),
                  Text(
                    widget.description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: widget.defaultValue
                            ? Constants.iBlack
                            : Constants.iLight,
                        fontSize: Constants.smallFontSize,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
