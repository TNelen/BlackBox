import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:blackbox/Assets/questions.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../Constants.dart';
import 'package:blackbox/translations/translations.i18n.dart';

class CategoryCard extends StatefulWidget {
  final bool defaultValue;
  final Category category;
  final Function() onTap;
  bool isNewFlag = false;

  CategoryCard(this.defaultValue, this.category, {required this.onTap, required this.isNewFlag , Key? key,}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CategoryCardState();
  }
}

class CategoryCardState extends State<CategoryCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.0,
      color: Constants.iDarkGrey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15.0),
        splashColor: Constants.iBlue,
        onTap: () {
          setState(() {
            if (widget.onTap != null) widget.onTap();
          });
        },
        child: Container(
          width: MediaQuery.of(context).size.width - 60,
          child: Padding(
            padding: const EdgeInsets.only(top: 8, left: 5.0, right: 5, bottom: 8),
            child: Row(children: [
              Container(
                height: 45,
                width: 45,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  color: widget.defaultValue ? widget.category.color.withOpacity(0.2) : widget.category.color,
                  child: Center(
                    child: FaIcon(
                      widget.category.icon,
                      size: 17,
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 12,
              ),
              Container(
                width: widget.isNewFlag ? MediaQuery.of(context).size.width - 200 : MediaQuery.of(context).size.width - 140,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.category.categoryName.i18n,
                      textAlign: TextAlign.start,
                      style: TextStyle(color: widget.defaultValue ? Colors.white24 : widget.category.titleColor, fontSize: Constants.smallFontSize, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 5),
                    Text(
                      widget.category.description.i18n,
                      textAlign: TextAlign.start,
                      maxLines: 2,
                      style: TextStyle(color: widget.defaultValue ? Colors.white12 : Constants.iLight, fontSize: Constants.smallFontSize - 3, fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: widget.isNewFlag ? 12 : 0,
              ),
              widget.isNewFlag
                  ? Container(
                      height: 35,
                      width: 50,
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        color: Constants.iDarkGrey,
                        child: DefaultTextStyle(
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: Constants.iWhite,
                            fontWeight: FontWeight.bold,
                          ),
                          child: Center(
                            child: AnimatedTextKit(
                              pause: Duration(milliseconds: 200),
                              repeatForever: true,
                              animatedTexts: [
                                FadeAnimatedText('NEW!'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  : SizedBox(),
            ]),
          ),
        ),
      ),
    );
  }
}
