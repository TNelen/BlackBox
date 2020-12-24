import 'package:firebase_auth/firebase_auth.dart' as fbauth;
import 'package:google_sign_in/google_sign_in.dart';

import 'package:blackbox/models/UserData.dart';

class GoogleUserHandler {
  static bool loggedIn = false;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();
  static final fbauth.FirebaseAuth _auth = fbauth.FirebaseAuth.instance;

  static bool isLoggedIn() {
    return loggedIn;
  }

  Future<UserData> handleSignIn() async {
    loggedIn = false;

    // Trigger the authentication flow
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    // Obtain the auth details from the request
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    fbauth.AuthCredential cred = fbauth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    fbauth.User user =
        (await fbauth.FirebaseAuth.instance.signInWithCredential(cred)).user;

    loggedIn = true;

    UserData userData = UserData(user.uid, user.displayName);

    return userData;
  }
}
