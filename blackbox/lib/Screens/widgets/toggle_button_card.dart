import 'package:blackbox/Constants.dart';
import 'package:flutter/material.dart';

class ToggleButtonCard extends StatefulWidget {
  final String text;
  final TextStyle textStyle;
  final bool defaultValue;
  final Function(bool) onToggle;
  final Icon icon;
  final Color splashColor;

  ToggleButtonCard(
    this.text, this.defaultValue, 
    { 
      this.onToggle, 
      this.textStyle: 
        const TextStyle(
          fontSize: Constants.actionbuttonFontSize,
          color: Constants.iWhite,
        ), 
      this.icon,
      this.splashColor,
      Key key
    }
  ) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ToggleButtonCardState();
  }
}

class ToggleButtonCardState extends State<ToggleButtonCard> {
  bool _currentValue;

  set currentValue(bool value) {
    setState(() => _currentValue = value);
  }

  bool get currentValue => _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.defaultValue ?? false;
  }

  void _setValue( bool value )
  {
    _currentValue = value;

    if (widget.onToggle != null) widget.onToggle( value );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        color: Constants.iDarkGrey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16.0),
          splashColor: widget.splashColor ?? Constants.colors[Constants.colorindex],
          onTap: () => _setValue( !_currentValue ),
          child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
          ),
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: <Widget>[
                  (widget.icon != null)
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: widget.icon,
                        )
                      : SizedBox(),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    widget.text,
                    style: widget.textStyle,
                  ),
                ]),
                Switch(
                  value: _currentValue,
                  onChanged: (value) => _setValue( value ),
                  activeTrackColor: Constants.colors[Constants.colorindex],
                  activeColor: Constants.iWhite,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
