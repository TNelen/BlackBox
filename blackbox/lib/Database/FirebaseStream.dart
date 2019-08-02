import 'package:blackbox/DataContainers/GroupData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class FirebaseStream {

  final StreamController<GroupData> _groupController = StreamController<GroupData>();

  /// Listen to changes of group with ID groupID
  FirebaseStream ( String groupID )
  {
    // Subscribe to group changes and update the variable
    Firestore.instance
        .collection('groups')
        .document( groupID )
        .snapshots()
        .listen(_statsUpdated);
  }

  /// Getter for the GroupData Stream
  Stream<GroupData> get groupData => _groupController.stream;

  /// Update groupData in the Stream
  void _statsUpdated ( DocumentSnapshot ds )
  {
    _groupController.add( GroupData.fromDocumentSnapshot( ds ) );
  }

}