import 'package:firebase_auth/firebase_auth.dart';
import 'package:zachranobed/models/user_data.dart';
import 'package:zachranobed/services/canteen_service.dart';
import 'package:zachranobed/services/charity_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CanteenService _canteenService;
  final CharityService _charityService;

  AuthService(this._canteenService, this._charityService);

  /// Returns data about currently signed in user.
  ///
  /// Retrieves the claims of the currently signed in user and, based on
  /// whether they contain the `canteen` or `charity` attribute, retrieves
  /// data from the appropriate Firestore collection.
  Future<UserData?> getUserData() async {
    final token = await _auth.currentUser!.getIdTokenResult(false);
    final claims = token.claims;

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
