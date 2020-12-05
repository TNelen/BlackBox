import 'package:flutter/material.dart';

class IconCard extends StatefulWidget {
  final IconData icon;
  final Color color;
  final Color iconcolor;
  final double iconSize;

  IconCard(this.icon, this.color, this.iconcolor, this.iconSize, {Key key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return IconCardState();
  }
}

class IconCardState extends State<IconCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 0.0,
        color: widget.color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(7.5),
            child: Icon(
          widget.icon,
          color: widget.iconcolor,
          size: widget.iconSize,
        )));
  }
}
