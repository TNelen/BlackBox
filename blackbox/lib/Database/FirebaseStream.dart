import 'package:blackbox/DataContainers/GroupData.dart';
import 'package:blackbox/Exceptions/GroupNotFoundException.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class FirebaseStream {

  static String _groupID;
  static StreamController<GroupData> _groupController;
  static StreamSubscription< DocumentSnapshot > _subscription;


  /// Singleton pattern
  static final FirebaseStream _firebaseStream =  FirebaseStream._internal();

  /// Singleton constructor
  factory FirebaseStream( String groupID ) {
    
    _groupID = groupID;

    closeController();

    if (_groupController == null)
      _groupController =  StreamController<GroupData>.broadcast();

    
    FirebaseStream._internal();
    
    return _firebaseStream;
  }


  FirebaseStream._internal() {

    closeController();

    if ( _groupController == null || _groupController.isClosed )
    {
      _groupController =  StreamController<GroupData>.broadcast();
    }

    /// Subscribe to group changes and update the variable
    _subscription = Firestore.instance
        .collection('groups')
        .document( _groupID )
        .snapshots()
        .asBroadcastStream()
        .listen(_groupDataUpdated);
  }


  static void closeController(){

    if ( _subscription != null ) {
      _subscription.cancel();
    }

    if (_groupController != null) {
      _groupController.close();
    }
    
  }


  /// Getter for the GroupData Stream
  Stream<GroupData> get groupData => _groupController.stream.asBroadcastStream();



  /// Update groupData in the Stream
  void _groupDataUpdated ( DocumentSnapshot ds )
  {

    if ( _groupController == null || _groupController.isClosed)
    {
      FirebaseStream._internal();
    }
  
    try {
      if ( ds.exists)
        _groupController.add( GroupData.fromDocumentSnapshot( ds ) );
      else
        _groupController.addError( GroupNotFoundException( _groupID ).getCause());
    } catch(e) {
      print(e);
    }
  }

}