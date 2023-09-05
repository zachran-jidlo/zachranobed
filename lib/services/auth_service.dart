import 'package:firebase_auth/firebase_auth.dart';
import 'package:zachranobed/models/user_data.dart';
import 'package:zachranobed/services/canteen_service.dart';
import 'package:zachranobed/services/charity_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CanteenService _canteenService;
  final CharityService _charityService;

  AuthService(this._canteenService, this._charityService);

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

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> reauthenticateUser(String password) async {
    final credential = EmailAuthProvider.credential(
      email: _auth.currentUser!.email!,
      password: password,
    );

    await _auth.currentUser!.reauthenticateWithCredential(credential);
  }

  Future<void> changePassword(String password) async {
    await _auth.currentUser!.updatePassword(password);
  }
}
