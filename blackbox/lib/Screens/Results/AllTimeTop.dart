import 'package:blackbox/Interfaces/Database.dart';
import 'package:flutter/material.dart';
import '../../Constants.dart';

class AllTimeTop {
  static Widget alltimetopThree(BuildContext context, Database database,
      List alltimeWinners, bool showMoreAll) {
    return ListView.separated(
      physics: new NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) => Divider(
        color: Colors.white,
      ),
      shrinkWrap: true,
      itemCount: !showMoreAll
          ? (alltimeWinners.length >= 3 ? 3 : alltimeWinners.length)
          : alltimeWinners.length,
      itemBuilder: (context, index) {
        return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            color: Constants.iBlack,
            child: Center(
              child: Padding(
                  padding: const EdgeInsets.only(
                      top: 1.0, bottom: 1, left: 15, right: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              (index + 1).toString() +
                                  (index == 0
                                      ? 'st'
                                      : index == 1
                                          ? 'nd'
                                          : index == 2 ? 'rd' : 'th'),
                              style: new TextStyle(
                                  color: index == 0
                                      ? Constants.colors[Constants.colorindex]
                                      : Constants.iWhite,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w400),
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Text(
                              alltimeWinners[index].getUserName().split(' ')[0],
                              style: new TextStyle(
                                  color: index == 0
                                      ? Constants.colors[Constants.colorindex]
                                      : Constants.iWhite,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w300),
                              textAlign: TextAlign.start,
                            ),
                          ]),
                      Text(
                        alltimeWinners[index].getNumVotes().toString(),
                        style: new TextStyle(
                            color: index == 0
                                ? Constants.colors[Constants.colorindex]
                                : Constants.iWhite,
                            fontSize: 25.0,
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  )),
            ));
      },
    );
  }
}
