import 'package:blackbox/Interfaces/Database.dart';
import 'package:flutter/material.dart';
import '../../Constants.dart';
import 'package:auto_size_text/auto_size_text.dart';

class PrevRoundTop {
  static Widget prevRoundTopThree(
      BuildContext context, Database database, List currentWinners) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        currentWinners.length >= 2
            ? Stack(alignment: Alignment.bottomCenter, children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width / 4.5,
                        height: MediaQuery.of(context).size.width / 4.5,
                        child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                color: Constants.iWhite,
                                width: 1,
                              ),
                            ),
                            child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                color: Constants.iBlack,
                                child: Column(
                                  children: <Widget>[
                                    AutoSizeText(
                                      currentWinners[1]
                                          .getUserName()
                                          .split(' ')[0],
                                      style: new TextStyle(
                                          color: Constants
                                              .colors[Constants.colorindex],
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w600),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                    ),
                                    Text(
                                      currentWinners[1]
                                              .getNumVotes()
                                              .toString() +
                                          (currentWinners[1]
                                                      .getNumVotes()
                                                      .toString() ==
                                                  '1'
                                              ? ' vote'
                                              : ' votes'),
                                      style: new TextStyle(
                                          color: Constants.iWhite,
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.w400),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      height: 12,
                                    )
                                  ],
                                ))))),
                Card(
                    color: Constants.iWhite,
                    child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                        child: Text(
                          '2',
                          style:
                              TextStyle(fontSize: 17, color: Constants.iBlack),
                        )))
              ])
            : SizedBox(
                width: MediaQuery.of(context).size.width / 4.5,
              ),
        SizedBox(
          width: 5,
        ),
        Stack(alignment: Alignment.bottomCenter, children: <Widget>[
          Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: SizedBox(
                  width: MediaQuery.of(context).size.width / 3.8,
                  height: MediaQuery.of(context).size.width / 3.8,
                  child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          color: Constants.iWhite,
                          width: 1,
                        ),
                      ),
                      child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          color: Constants.iBlack,
                          child: Column(
                            children: <Widget>[
                              AutoSizeText(
                                currentWinners[0].getUserName().split(' ')[0],
                                style: new TextStyle(
                                    color:
                                        Constants.colors[Constants.colorindex],
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w600),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                              ),
                              Text(
                                currentWinners[0].getNumVotes().toString() +
                                    (currentWinners[0]
                                                .getNumVotes()
                                                .toString() ==
                                            '1'
                                        ? ' vote'
                                        : ' votes'),
                                style: new TextStyle(
                                    color: Constants.iWhite,
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w400),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 14,
                              )
                            ],
                          ))))),
          Card(
              color: Constants.colors[Constants.colorindex],
              child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 11),
                  child: Text(
                    '1',
                    style: TextStyle(fontSize: 17, color: Constants.iBlack),
                  )))
        ]),
        SizedBox(
          width: 5,
        ),
        currentWinners.length >= 3
            ? Stack(alignment: Alignment.bottomCenter, children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: SizedBox(
                        height: MediaQuery.of(context).size.width / 4.5,
                        width: MediaQuery.of(context).size.width / 4.5,
                        child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                color: Constants.iWhite,
                                width: 1,
                              ),
                            ),
                            child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                color: Constants.iBlack,
                                child: Column(
                                  children: <Widget>[
                                    AutoSizeText(
                                      currentWinners[2]
                                          .getUserName()
                                          .split(' ')[0],
                                      style: new TextStyle(
                                          color: Constants
                                              .colors[Constants.colorindex],
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w600),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                    ),
                                    Text(
                                      currentWinners[2]
                                              .getNumVotes()
                                              .toString() +
                                          (currentWinners[2]
                                                      .getNumVotes()
                                                      .toString() ==
                                                  '1'
                                              ? ' vote'
                                              : ' votes'),
                                      style: new TextStyle(
                                          color: Constants.iWhite,
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.w400),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      height: 12,
                                    )
                                  ],
                                ))))),
                Card(
                    color: Constants.iWhite,
                    child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                        child: Text(
                          '3',
                          style:
                              TextStyle(fontSize: 17, color: Constants.iBlack),
                        )))
              ])
            : SizedBox(
                width: MediaQuery.of(context).size.width / 4.5,
              ),
      ],
    );
  }

  static Widget prevRoundTopAfterThree(BuildContext context, Database database,
      List currentWinners, bool showMoreCurrent) {
    return currentWinners.length > 3
        ? ListView.separated(
            physics: new NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => Divider(
              color: Colors.white,
            ),
            shrinkWrap: true,
            itemCount: !showMoreCurrent
                ? (currentWinners.length >= 3 ? 0 : currentWinners.length - 3)
                : currentWinners.length - 3,
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
                                    (index + 4).toString() + 'th',
                                    style: new TextStyle(
                                        color: Constants.iWhite,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w400),
                                    textAlign: TextAlign.start,
                                  ),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Text(
                                    currentWinners[index + 3]
                                        .getUserName()
                                        .split(' ')[0],
                                    style: new TextStyle(
                                        color: Constants.iWhite,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w300),
                                    textAlign: TextAlign.start,
                                  ),
                                ]),
                            Text(
                              currentWinners[index + 3]
                                  .getNumVotes()
                                  .toString(),
                              style: new TextStyle(
                                  color: Constants.iWhite,
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.w600),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        )),
                  ));
            },
          )
        : SizedBox(
            height: 25,
          );
  }
}
