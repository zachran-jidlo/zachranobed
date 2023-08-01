import 'package:firebase_auth/firebase_auth.dart';
import 'package:zachranobed/models/user_data.dart';
import 'package:zachranobed/services/donor_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DonorService _donorService;

  AuthService(this._donorService);

  Future<UserData?> getUserData() async {
    UserData? data =
        await _donorService.getDonorByEmail(_auth.currentUser!.email!);
    return data;
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
}
