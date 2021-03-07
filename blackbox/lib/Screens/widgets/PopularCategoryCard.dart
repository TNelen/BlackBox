import 'package:flutter/material.dart';
import '../../Constants.dart';

class PopularCategoryCard extends StatefulWidget {
  final bool defaultValue;
  final String categoryname;
  final String description;
  final Function() onTap;
  bool isNewFlag = false;

  PopularCategoryCard(this.defaultValue, this.categoryname, this.description,
      {this.onTap, Key key, this.isNewFlag})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PopularCategoryCardState();
  }
}

class PopularCategoryCardState extends State<PopularCategoryCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 8),
      child: Card(
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
            width: MediaQuery.of(context).size.width / 3,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 10, left: 10.0, right: 10, bottom: 5),
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
                                fontSize: Constants.actionbuttonFontSize,
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
                    SizedBox(height: 10),
                    Text(
                      widget.description,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: widget.defaultValue
                              ? Constants.iBlack
                              : Constants.iLight,
                          fontSize: Constants.smallFontSize,
                          fontWeight: FontWeight.w300),
                    ),
                    SizedBox(height: 5),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
