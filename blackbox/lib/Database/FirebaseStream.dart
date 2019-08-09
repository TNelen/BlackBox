import 'package:blackbox/DataContainers/GroupData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class FirebaseStream {

  static String _groupID;
  final StreamController<GroupData> _groupController = StreamController<GroupData>.broadcast();

  /// Singleton pattern
  static final FirebaseStream _firebaseStream = new FirebaseStream._internal();

  factory FirebaseStream( String groupID ) {
    
    _groupID = groupID;

    return _firebaseStream;
  }

  FirebaseStream._internal() {
  /// Subscribe to group changes and update the variable
    Firestore.instance
        .collection('groups')
        .document( _groupID )
        .snapshots()
        .asBroadcastStream()
        .listen(_groupDataUpdated);
  }


  /// Getter for the GroupData Stream
  Stream<GroupData> get groupData => _groupController.stream.asBroadcastStream();



  /// Update groupData in the Stream
  void _groupDataUpdated ( DocumentSnapshot ds )
  {
    _groupController.add( GroupData.fromDocumentSnapshot( ds ) );
  }

}