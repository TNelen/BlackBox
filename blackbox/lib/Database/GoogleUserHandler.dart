import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:blackbox/models/UserData.dart';

class GoogleUserHandler {
  static bool loggedIn = false;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static bool isLoggedIn() {
    return loggedIn;
  }

  Future<UserData> handleSignIn() async {
    loggedIn = false;

    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    AuthCredential cred = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    FirebaseUser user = (await _auth.signInWithCredential(cred)).user;

    loggedIn = true;

    UserData userData = UserData(user.uid, user.displayName);

    return userData;
  }
}
