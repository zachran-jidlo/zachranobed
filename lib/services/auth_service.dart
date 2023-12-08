import 'package:firebase_auth/firebase_auth.dart';
import 'package:zachranobed/common/firebase/firebase_helper.dart';
import 'package:zachranobed/models/user_data.dart';
import 'package:zachranobed/services/canteen_service.dart';
import 'package:zachranobed/services/charity_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CanteenService _canteenService;
  final CharityService _charityService;

  AuthService(this._canteenService, this._charityService);

  /// Gets the current user's token and extracts claims to determine the user's
  /// role. Depending on the role (`canteen` or `charity`), it fetches and
  /// returns the corresponding user data from the respective services.
  ///
  /// Returns a [Future] that completes with [UserData] for the authenticated
  /// user if the role is either `canteen` or `charity` and `null` if the
  /// user's role is not recognized.
  Future<UserData?> getUserData() async {
    final token = await _auth.currentUser!.getIdTokenResult(false);
    final claims = token.claims;

    FirebaseHelper.setUserIdentifier(_auth.currentUser?.uid);

    if (claims?["canteen"] == true) {
      return await _canteenService.getCanteenByEmail(_auth.currentUser!.email!);
    }
    if (claims?["charity"] == true) {
      return await _charityService.getCharityByEmail(_auth.currentUser!.email!);
    }
    return null;
  }

  /// Attempts to sign user to the app with given [email] and [password].
  ///
  /// If successful returns a [Future] that completes with a [User] object and
  /// `null` if there is an error during the sign-in process.
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException {
      return null;
    }
  }

  /// Signs out the current user.
  Future<void> signOut() async {
    await _auth.signOut();
    FirebaseHelper.setUserIdentifier(null);
  }

  /// Re-authenticates user with a given [password].
  Future<void> reauthenticateUser(String password) async {
    final credential = EmailAuthProvider.credential(
      email: _auth.currentUser!.email!,
      password: password,
    );

    await _auth.currentUser!.reauthenticateWithCredential(credential);
  }

  /// Updates the user's password with the new provided [password].
  Future<void> changePassword(String password) async {
    await _auth.currentUser!.updatePassword(password);
  }

  /// Sends a password reset email to the provided [email] address.
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
