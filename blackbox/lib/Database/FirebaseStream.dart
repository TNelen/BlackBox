import 'package:blackbox/DataContainers/GroupData.dart';
import 'package:blackbox/Exceptions/GroupNotFoundException.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class FirebaseStream {

  static String _groupID;
  static StreamController<GroupData> _groupController;
  StreamSubscription< DocumentSnapshot > _subscription;

  /// Singleton pattern
  static final FirebaseStream _firebaseStream = new FirebaseStream._internal();

  factory FirebaseStream( String groupID ) {
    
    _groupController = new StreamController<GroupData>.broadcast();

    _groupID = groupID;
    FirebaseStream._internal();
    
    return _firebaseStream;
  }

  FirebaseStream._internal() {

    if ( _groupController.isClosed )
    {
      _groupController = new StreamController<GroupData>.broadcast();
      print("Opened controller due to _internal() call");
    }

    if (_subscription != null ) {
      _subscription.cancel();
    }

    /// Subscribe to group changes and update the variable
    _subscription = Firestore.instance
        .collection('groups')
        .document( _groupID )
        .snapshots()
        .asBroadcastStream()
        .listen(_groupDataUpdated);
  }



  void closeController(){
    if ( _subscription != null ) {
      _subscription.cancel();
      _subscription = null;
    }
    _groupController.close();
  }


  /// Getter for the GroupData Stream
  Stream<GroupData> get groupData => _groupController.stream.asBroadcastStream();



  /// Update groupData in the Stream
  void _groupDataUpdated ( DocumentSnapshot ds )
  {
    if (_groupController.isClosed)
    {
      FirebaseStream._internal();
    }
  
    try {
    if ( ! ds.exists)
      throw new GroupNotFoundException( _groupID );
    else
      _groupController.add( GroupData.fromDocumentSnapshot( ds ) );
    } catch(e) {
      print(e);
    }
  }

}