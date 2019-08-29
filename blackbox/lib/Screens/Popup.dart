
import 'package:flutter/material.dart';
import '../Constants.dart';
import '../Interfaces/Database.dart';
import 'QuestionScreen.dart';
import '../DataContainers/GroupData.dart';

class Popup {
  static void makePopup(BuildContext context, String title, String message) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: Constants.iWhite,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0))),
          title: new Text(
            title,
            style: TextStyle(color: Constants.iBlack, fontSize: 25),
          ),
          content: new Text(
            message,
            style: TextStyle(color: Constants.iDarkGrey, fontSize: 20),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Close",
                style: TextStyle(
                    color: Constants.colors[Constants.colorindex],
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }


   static void makeReportPopup(BuildContext context, Database database, GroupData groupdata, String code) {


     Widget disturbingButton = FlatButton(
         onPressed: () {
           database.reportQuestion(groupdata.getQuestion(), ReportType.DISTURBING);
           Popup.makePopup(context, 'Thank You for your feedback!', '');

         },
         child: Row(
           children: <Widget>[
             Icon(Icons.sentiment_dissatisfied, color: Constants.iBlack, size: 20),
             SizedBox(width: 20,),

             Text(
               'Disturbing',
               style: TextStyle(fontSize: 15, color: Constants.iBlack),
             ),
           ],
         ));

     Widget grammarButton = FlatButton(
         onPressed: () {
           database.reportQuestion(groupdata.getQuestion(), ReportType.GRAMMAR);
           Navigator.pop(context);

           Popup.makePopup(context, 'Thank You for your feedback!', '');

         },
         child: Row(
           children: <Widget>[
             Icon(Icons.spellcheck, color: Constants.iBlack, size: 20),
             SizedBox(width: 20,),

             Text(
               'Grammar Mistake',
               style: TextStyle(fontSize: 15, color: Constants.iBlack),
             ),
           ],
         ));

     Widget loveButton = FlatButton(
         onPressed: () {
           database.voteOnQuestion(groupdata.getQuestion());

           Popup.makePopup(context, 'Thank You for your feedback!', '');
         },
         child: Row(
           children: <Widget>[
             Icon(Icons.favorite, color: Constants.iBlack, size: 20),
             SizedBox(width: 20,),

             Text(
               'Love it!',
               style: TextStyle(fontSize: 15, color: Constants.iBlack),
             ),
           ],
         ));

     // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: Constants.iWhite,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0))),
          title: new Text(
            'What do you think about this question?',
            style: TextStyle(color: Constants.iBlack, fontSize: 25),
          ),
          content: new Container(
            height: 200,
            child: Column(
            children: <Widget>[
              disturbingButton,
              grammarButton,
              loveButton,
            SizedBox(height: 10,),
            Text('Thank you! Via your feedback we can improve the community questions.', style: TextStyle(fontSize: 15, color: Constants.iDarkGrey, fontWeight: FontWeight.w400),)
            ],
          ),),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Close",
                style: TextStyle(
                    color: Constants.colors[Constants.colorindex],
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}