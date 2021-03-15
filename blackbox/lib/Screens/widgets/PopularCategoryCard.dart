import 'package:blackbox/Assets/questions.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../Constants.dart';

class PopularCategoryCard extends StatefulWidget {
  final bool defaultValue;
  final Category category;
  final Function() onTap;
  bool isNewFlag = false;

  PopularCategoryCard(this.defaultValue, this.category,
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
        child: Stack(children: [
          Card(
            elevation: 5.0,
            color: Constants.iDarkGrey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12.0),
              splashColor: Constants.iAccent,
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
                        top: 5, left: 5.0, right: 5, bottom: 5),
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 3,
                          height: 40,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            color: widget.category.color,
                            child: Center(
                              child: FaIcon(
                                widget.category.icon,
                                size: 17,
                                color: Colors.black.withOpacity(0.6),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  widget.category.categoryName,
                                  style: TextStyle(
                                      color: widget.defaultValue
                                          ? Colors.white24
                                          : Constants.iWhite,
                                      fontSize: Constants.smallFontSize - 3,
                                      fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ]),
                        SizedBox(height: 10),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(width: 5),
                              Flexible(
                                child: Text(
                                  widget.category.description,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: widget.defaultValue
                                          ? Colors.white12
                                          : Constants.iLight,
                                      fontSize: Constants.miniFontSize,
                                      fontWeight: FontWeight.w300),
                                ),
                              ),
                            ]),
                        SizedBox(height: 5),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: MediaQuery.of(context).size.width / 4,
            child: widget.isNewFlag
                ? Card(
                    color: Constants.iWhite,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(3),
                      child: Text(
                        "New!",
                        style: TextStyle(
                            fontSize: Constants.miniFontSize,
                            color: Constants.iBlack,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  )
                : SizedBox(
                    width: 1,
                  ),
          )
        ]));
  }
}
