import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zachranobed/models/fcm_token.dart';
import 'package:zachranobed/services/auth_service.dart';

class FCMTokenService {
  final AuthService _authService;

  final _fCMTokenCollection =
      FirebaseFirestore.instance.collection('fCMTokens').withConverter(
    fromFirestore: (snapshot, options) {
      final json = snapshot.data() ?? {};
      json['id'] = snapshot.id;
      return FCMToken.fromJson(json);
    },
    toFirestore: (value, options) {
      final json = value.toJson();
      json.remove('id');
      return json;
    },
  );

  FCMTokenService(this._authService);

  /// Retrieves the current user's establishment ID and uses it to store the
  /// provided FCM [token] in the Firestore collection dedicated to FCM tokens.
  /// It either updates the FCM token if document with this ID already exists
  /// or creates a new one with this ID and stores the token.
  Future<void> saveFCMToken(FCMToken token) async {
    final user = await _authService.getUserData();
    await _fCMTokenCollection.doc(user!.establishmentId).set(token);
  }
}
