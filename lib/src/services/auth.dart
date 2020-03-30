import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class BaseAuth {
  Future<FirebaseUser> currentUser();
  Future<FirebaseUser> signIn(String email, String password);
  Future<FirebaseUser> createUser(String email, String password);
  Future<FirebaseUser> signInWithGoogle();
  Future<FirebaseUser> signOutWithGoogle();
  Future<void> signOut();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<FirebaseUser> signIn(String email, String password) async {
    AuthResult user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return user.user;
  }

  Future<FirebaseUser> createUser(String email, String password) async {
    AuthResult user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return user.user;
  }

  Future<FirebaseUser> currentUser() async {
    final FirebaseUser currentUser = await _firebaseAuth.currentUser();
    return currentUser;
  }

  Future<void> signOut() async {
    signOutWithGoogle();
  }

  Future<FirebaseUser> signInWithGoogle() async {
    GoogleSignInAccount currentUser = _googleSignIn.currentUser;
    if (currentUser == null) {
      currentUser = await _googleSignIn.signInSilently();
    }
    if (currentUser == null) {
      currentUser = await _googleSignIn.signIn();
    }

    final GoogleSignInAuthentication googleAuth =
        await currentUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final AuthResult user =
        await _firebaseAuth.signInWithCredential(credential);
    assert(user != null);
    assert(!user.user.isAnonymous);
    return user.user;
  }

  Future<Null> signOutWithGoogle() async {
    // Sign out with firebase
    await _firebaseAuth.signOut();
    // Sign out with google
    await _googleSignIn.signOut();
  }
}
