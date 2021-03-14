import 'package:blackbox/Assets/questions.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../Constants.dart';

class SelectedCategoryCard extends StatefulWidget {
  final Category category;

  final Function() onTap;
  bool isNewFlag = false;

  SelectedCategoryCard(this.category, {this.onTap, Key key, this.isNewFlag})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SelectedCategoryCardState();
  }
}

class SelectedCategoryCardState extends State<SelectedCategoryCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12.0),
      splashColor: Constants.colors[Constants.colorindex],
      onTap: () {
        setState(() {
          if (widget.onTap != null) widget.onTap();
        });
      },
      child: Padding(
        padding: EdgeInsets.only(right: 8),
        child: Stack(children: [
          Card(
            elevation: 5.0,
            color: widget.category.color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width / 9,
              child: Center(
                child: Padding(
                    padding: const EdgeInsets.only(
                        top: 3, left: 3.0, right: 3, bottom: 3),
                    child: FaIcon(
                      widget.category.icon,
                      size: 22,
                      color: Colors.black.withOpacity(0.6),
                    )),
              ),
            ),
          ),
          Positioned(
              left: MediaQuery.of(context).size.width / 11,
              child: Icon(
                Icons.remove_circle,
                color: Constants.iWhite,
                size: 15,
              )),
        ]),
      ),
    );
  }
}
