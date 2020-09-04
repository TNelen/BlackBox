import 'package:blackbox/Constants.dart';
import 'package:flutter/material.dart';

class PopupReportButton extends StatefulWidget{
  
  final String label;
  final bool defaultState;
  final IconData frontIcon;
  final Function(bool) onTap;

  PopupReportButton(this.label, {this.defaultState: false, this.frontIcon: Icons.sentiment_dissatisfied,this.onTap});
  
  @override
  State<StatefulWidget> createState() {
    return _PopupReportButtonState();
  }
}

class _PopupReportButtonState extends State<PopupReportButton>{

  bool _isSelected;

  @override
  void initState()
  {
    super.initState();
    _isSelected = widget.defaultState;
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        setState(() => _isSelected = !_isSelected);
        if (widget.onTap != null)
          widget.onTap( _isSelected );
      },
      child: Row(
        children: <Widget>[
          Icon(
            widget.frontIcon, 
            color: _isSelected ? Constants.iWhite : Constants.iGrey, 
            size: 20
          ),
          SizedBox(
            width: 20,
          ),
          Text(
            widget.label,
            style: TextStyle(
              fontFamily: "atarian", 
              fontSize: Constants.smallFontSize, 
              color: _isSelected ? Constants.iWhite : Constants.iGrey,
            ),
          ),
        ],
      ),
    );
  }
}