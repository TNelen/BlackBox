import 'package:blackbox/Constants.dart';
import 'package:blackbox/DataContainers/GroupData.dart';
import 'package:blackbox/Interfaces/Database.dart';
import 'package:blackbox/Screens/QuestionScreen.dart';
import 'package:blackbox/Screens/popups/buttons/popup_report_button.dart';
import 'package:flutter/material.dart';

class ReportPopup extends StatefulWidget {
  final Database _database;
  final GroupData groupData;
  final String code;

  @override
  ReportPopup(this._database, this.groupData, this.code);

  _ReportPopupState createState() => _ReportPopupState(_database, groupData, code);
}

class _ReportPopupState extends State<ReportPopup> {
  Database database;
  GroupData groupdata;
  String code;

  _ReportPopupState(Database db, GroupData groupData, String code) {
    this.database = db;
    this.groupdata = groupData;
    this.code = code;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context2) {

    // return object of type Dialog

    return AlertDialog(
      backgroundColor: Constants.iBlack,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
      title: new Text(
        'What do you think about this question?',
        style: TextStyle(fontFamily: "atarian", color: Constants.colors[Constants.colorindex], fontSize: Constants.normalFontSize),
      ),
      content: new Container(
        height: 200,
        child: Column(
          children: <Widget>[
            PopupReportButton(
              'Disturbing',
              defaultState: reportMap[ReportType.DISTURBING],
              onTap: (newValue) => reportMap[ReportType.DISTURBING] = newValue,
            ),
            PopupReportButton(
              'Grammar Mistake',
              defaultState: reportMap[ReportType.GRAMMAR],
              onTap: (newValue) => reportMap[ReportType.GRAMMAR] = newValue,
            ),
            PopupReportButton(
              'Love it!',
              frontIcon: Icons.sentiment_very_satisfied,
              defaultState: reportMap[ReportType.LOVE],
              onTap: (newValue) => reportMap[ReportType.LOVE] = newValue,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Thank you! Via your feedback we can improve the questions.',
              style: TextStyle(fontFamily: "atarian", fontSize: Constants.smallFontSize, color: Constants.iWhite, fontWeight: FontWeight.w400),
            )
          ],
        ),
      ),
      actions: <Widget>[
        // usually buttons at the bottom of the dialog
        new FlatButton(
          child: new Text(
            "Close",
            style: TextStyle(fontFamily: "atarian", color: Constants.colors[Constants.colorindex], fontSize: Constants.actionbuttonFontSize, fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}