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
      elevation: 0.0,
      //color: Colors.grey.shade800,

      color: Constants.black.withOpacity(0.7),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(30.0),
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
                const EdgeInsets.only(top: 5, left: 5.0, right: 5, bottom: 5),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 4,
                  ),
                  FaIcon(
                    widget.category.icon,
                    size: 20,
                    color: widget.defaultValue
                        ? widget.category.color.withOpacity(0.1)
                        : widget.category.color,
                  ),
                  SizedBox(
                    height: 4,
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
                                  ? Constants.iWhite.withOpacity(0.3)
                                  : Constants.iWhite,
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
                                  ? Constants.iWhite.withOpacity(0.4)
                                  : Constants.iWhite.withOpacity(0.8),
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
