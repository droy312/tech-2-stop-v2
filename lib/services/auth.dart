import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  UserModel userFromFirebaseUser(User user) {
    return user != null ? UserModel(uid: user.uid, email: user.email) : null;
  }

  Stream<UserModel> get user {
    return auth.authStateChanges()
        .map((User user) => userFromFirebaseUser(user));
  }

  // sign in with google
  Future<UserModel> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken,
    );

    final UserCredential result = await auth.signInWithCredential(credential);
    final User user = result.user;

    assert(!user.isAnonymous);
    assert(user.getIdToken() != null);

    final User currentUser = auth.currentUser;
    assert(user.uid == currentUser.uid);

    return userFromFirebaseUser(user);
  }

  // sign out
  Future signOut() async {
    try {
      auth.signOut();
      return await googleSignIn.signOut();
    } catch (e) {
      print('ERROR: ' + e.toString());
      return null;
    }
  }
}
