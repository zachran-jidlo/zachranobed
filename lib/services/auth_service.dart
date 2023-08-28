import 'package:firebase_auth/firebase_auth.dart';
import 'package:zachranobed/models/user_data.dart';
import 'package:zachranobed/services/donor_service.dart';
import 'package:zachranobed/services/recipient_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DonorService _donorService;
  final RecipientService _recipientService;

  AuthService(this._donorService, this._recipientService);

  Future<UserData?> getUserData() async {
    final token = await _auth.currentUser!.getIdTokenResult(false);
    final claims = token.claims;

    if (claims?["donor"] == true) {
      return await _donorService.getDonorByEmail(_auth.currentUser!.email!);
    }
    if (claims?["recipient"] == true) {
      return await _recipientService
          .getRecipientByEmail(_auth.currentUser!.email!);
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
}
