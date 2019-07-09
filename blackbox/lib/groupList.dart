import 'package:flutter/material.dart';

List<String> groups = ["groep1","groep2","groep3","groep4","groep5","groep2","groep3","groep4","groep5","groep3","groep4","groep5","groep3","groep4","groep5"];
List<String> groups2 = ["groep1","groep2","groep3"];


class GroupList extends StatelessWidget {


  Widget buildGroupItem(BuildContext context, int index) {
    return new Container(
        //height: 50,
        color: Colors.white,
        child:ListTile(
          title: Text(
            groups[index],
            style: TextStyle(
              fontSize: 17,
              color: Colors.black,
            ),
          ),
          trailing:
          Icon(Icons.more_vert, size: 25, color: Colors.amber,),
    ),);
  }

  @override
  Widget build(BuildContext context) {
    return new ListView.separated(
      scrollDirection:  Axis.vertical,
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.all(8.0),
      itemCount: groups.length,
      itemBuilder: buildGroupItem,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }
}