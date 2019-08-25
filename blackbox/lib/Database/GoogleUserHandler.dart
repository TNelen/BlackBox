import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:blackbox/DataContainers/UserData.dart';

class GoogleUserHandler {
  
  static final GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future< bool > isLoggedIn()
  {
    return _googleSignIn.isSignedIn();
  }

  Future< UserData > handleSignIn() async {
    
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    AuthCredential cred = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken
    );

    FirebaseUser user = await _auth.signInWithCredential(cred);

    UserData userData = new UserData(user.uid, user.displayName);
    
    return userData;
  }
}