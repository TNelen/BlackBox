import 'package:blackbox/Constants.dart';
import 'package:flutter/material.dart';

class ToggleButtonCard extends StatefulWidget{
  
  final String text;
  final bool defaultValue;
  final Function(bool) onToggle;

  ToggleButtonCard(this.text, this.defaultValue, {this.onToggle});

  @override
  State<StatefulWidget> createState() {
    return _ToggleButtonCardState();
  }

}

class _ToggleButtonCardState extends State<ToggleButtonCard>{
  
  bool _currentValue;

  @override
  void initState()
  {
    super.initState();
    _currentValue = widget.defaultValue ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
      color: Constants.iDarkGrey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: <Widget>[
              SizedBox(
                width: 10,
              ),
              Text(
                widget.text,
                style: TextStyle(fontSize: 25.0, color: Constants.iWhite),
              ),
            ]),
            Switch(
              value: _currentValue,
              onChanged: (value) {
                _currentValue = value;

                if (widget.onToggle != null)
                  widget.onToggle( value );

                setState(() {});
              },
              activeTrackColor: Constants.colors[Constants.colorindex],
              activeColor: Constants.iWhite,
            ),
          ],
        ),
      ),
    ));
  }

}