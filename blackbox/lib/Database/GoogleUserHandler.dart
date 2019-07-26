import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:blackbox/DataContainers/UserData.dart';

class GoogleUserHandler {
  
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;

  Future< UserData > handleSignIn() async {
    
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    AuthCredential cred = await GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken
    );

    FirebaseUser user = await _auth.signInWithCredential(cred);

    UserData userData = new UserData(user.uid, user.displayName);
    
    return userData;
  }
}