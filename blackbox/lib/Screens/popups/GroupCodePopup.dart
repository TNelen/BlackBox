import 'package:flutter/material.dart';
import '../../Interfaces/Database.dart';
import '../../Constants.dart';
import '../OnlineScreens/GameScreen.dart';
import 'package:share/share.dart';

class GroupCodePopup {
  static bool _isNumeric(String str) {
    if (str == null) {
      return false;
    }
    return double.tryParse(str) != null;
  }

  static void groupCodePopup(
      String groupCode, BuildContext context, Database database) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: Constants.iDarkGrey,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0))),
          title: Text(
            "Group Code",
            style: TextStyle(
                fontFamily: "atarian",
                color: Constants.iWhite,
                fontSize: Constants.subtitleFontSize,
                fontWeight: FontWeight.bold),
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              RichText(
                text: TextSpan(
                    // set the default style for the children TextSpans
                    style: TextStyle(
                        fontFamily: "atarian",
                        color: Constants.iBlack,
                        fontSize: Constants.normalFontSize),
                    children: [
                      TextSpan(
                          text: groupCode[0],
                          style: !_isNumeric(groupCode[0])
                              ? TextStyle(color: Constants.iWhite)
                              : TextStyle(
                                  color:
                                      Constants.colors[Constants.colorindex])),
                      TextSpan(
                          text: groupCode[1],
                          style: !_isNumeric(groupCode[1])
                              ? TextStyle(color: Constants.iWhite)
                              : TextStyle(
                                  color:
                                      Constants.colors[Constants.colorindex])),
                      TextSpan(
                          text: groupCode[2],
                          style: !_isNumeric(groupCode[2])
                              ? TextStyle(color: Constants.iWhite)
                              : TextStyle(
                                  color:
                                      Constants.colors[Constants.colorindex])),
                      TextSpan(
                          text: groupCode[3],
                          style: !_isNumeric(groupCode[3])
                              ? TextStyle(color: Constants.iWhite)
                              : TextStyle(
                                  color:
                                      Constants.colors[Constants.colorindex])),
                      TextSpan(
                          text: groupCode[4],
                          style: !_isNumeric(groupCode[4])
                              ? TextStyle(color: Constants.iWhite)
                              : TextStyle(
                                  color:
                                      Constants.colors[Constants.colorindex])),
                    ]),
              ),
              IconButton(
                  icon: Icon(
                    Icons.share,
                    color: Constants.iWhite,
                  ),
                  onPressed: () {
                    final RenderBox box =
                        context.findRenderObject() as RenderBox;
                    String shareText = "Join a game with this code:\n\n" +
                        groupCode +
                        "\n\n\nDownload BlackBox on Google Play \nhttps://play.google.com/store/apps/details?id=be.dezijwegel.blackbox ";
                    Share.share(shareText,
                        sharePositionOrigin:
                            box.localToGlobal(Offset.zero) & box.size);
                  }),
            ],
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text(
                "Start",
                style: TextStyle(
                    fontFamily: "atarian",
                    color: Constants.colors[Constants.colorindex],
                    fontSize: Constants.actionbuttonFontSize,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            GameScreen(database, groupCode)));
              },
            ),
          ],
        );
      },
    );
  }
}
