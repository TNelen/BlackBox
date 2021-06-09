// @dart=2.9

import 'package:blackbox/Assets/questions.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../Constants.dart';

class CategoryCard extends StatefulWidget {
  final bool defaultValue;
  final Category category;
  final Function() onTap;
  bool isNewFlag = false;

  CategoryCard(this.defaultValue, this.category,
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
      color: widget.defaultValue
          ? widget.category.color.withOpacity(0.2)
          : widget.category.color,
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
          width: MediaQuery.of(context).size.width - 60,
          child: Padding(
            padding:
                const EdgeInsets.only(top: 8, left: 10.0, right: 10, bottom: 8),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 7,
                  ),
                  FaIcon(
                    widget.category.icon,
                    size: 25,
                    color: Colors.black.withOpacity(0.6),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 140,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          widget.category.categoryName,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: widget.defaultValue
                                  ? Constants.iDarkGrey.withOpacity(0.5)
                                  : Constants.iDarkGrey,
                              fontSize: Constants.smallFontSize,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 5),
                        Text(
                          widget.category.description,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: TextStyle(
                              color: widget.defaultValue
                                  ? Constants.iDarkGrey.withOpacity(0.5)
                                  : Constants.iDarkGrey,
                              fontSize: Constants.smallFontSize - 3,
                              fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
