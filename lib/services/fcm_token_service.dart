import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:zachranobed/models/canteen.dart';
import 'package:zachranobed/models/fcm_token.dart';
import 'package:zachranobed/services/auth_service.dart';
import 'package:zachranobed/services/helper_service.dart';

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

  Future<FCMToken?> getFCMToken(BuildContext context) async {
    final user = HelperService.getCurrentUser(context) as Canteen;
    final fCMToken =
        await _fCMTokenCollection.doc(user.recipient!.establishmentId).get();
    return fCMToken.data();
  }

  Future<void> saveFCMToken(FCMToken token) async {
    final user = await _authService.getUserData();
    await _fCMTokenCollection.doc(user!.establishmentId).set(token);
  }
}
