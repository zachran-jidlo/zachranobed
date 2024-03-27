import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zachranobed/common/firebase/firebase_helper.dart';
import 'package:zachranobed/common/logger/zo_logger.dart';
import 'package:zachranobed/models/canteen.dart';
import 'package:zachranobed/models/charity.dart';
import 'package:zachranobed/models/dto/entity_dto.dart';
import 'package:zachranobed/models/user_data.dart';
import 'package:zachranobed/services/entity_pairs_service.dart';
import 'package:zachranobed/services/entity_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final EntityService _entityService;
  final EntityPairService _entityPairService;

  AuthService(this._entityService, this._entityPairService);

  /// Gets the current user's e-mail and fetches entity, which also determines
  /// user's role. Depending on the entity type (`donor` or `recipient`), it
  /// fetches and returns the corresponding user data from the respective
  /// services.
  ///
  /// Returns a [Future] that completes with [UserData] for the authenticated
  /// user.
  Future<UserData?> getUserData() async {
    FirebaseHelper.setUserIdentifier(_auth.currentUser?.uid);

    final user = _auth.currentUser;
    if (user == null) {
      ZOLogger.logMessage("Unable to get user data");
      return null;
    }

    final email = user.email;
    if (email == null) {
      ZOLogger.logMessage("Unable to get user data, e-mail is null");
      return null;
    }

    final entity = await _entityService.getEntityByEmail(email);
    if (entity == null) {
      ZOLogger.logMessage("Unable to get user data, entity "
          "is not found for e-mail $email");
      return null;
    }

    final entityType = entity.entityType;
    if (entityType == null) {
      ZOLogger.logMessage("Unable to get user data, entity type "
          "is not recognised for e-mail $email");
      return null;
    }

    switch (entityType) {
      case EntityTypeDto.donor:
        return _getCanteenData(entity);
      case EntityTypeDto.recipient:
        return _getCharityData(entity);
    }
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

  /// Fetches canteen data from entity pairs relation. Each canteen may have
  /// only one charity, thus the first pair may be taken.
  Future<Canteen?> _getCanteenData(EntityDto entity) async {
    final pairs = await _entityPairService.getByDonorId(entity.id);
    if (pairs == null) {
      ZOLogger.logMessage("Unable to get canteen data, no pair "
          "is found for donor ID ${entity.id}");
      return null;
    }

    // Canteen may have only one charity, so it is safe to take the first pair
    final pair = pairs.first;
    final window = pair.pickupTimeWindows.firstOrNull;
    if (window == null) {
      ZOLogger.logMessage("Unable to get canteen data, it's pair "
          "with ${pair.recipientId} has no pick up windows");
      return null;
    }



    return Canteen(
      entityId: entity.id,
      email: entity.email,
      establishmentName: entity.establishmentName,
      establishmentId: entity.establishmentId,
      organization: entity.organization,
      pickUpFrom: window.start,
      pickUpWithin: window.end,
      recipientId: pair.recipientId,
      lastAcceptedAppTermsVersion: _mapLastAcceptedAppTermsVersion(entity.lastAcceptedAppTermsVersion)
    );
  }

  /// Fetches charity data from entity pairs relation. Each charity may have
  /// multiple canteens, thus all pairs should be taken into account.
  Future<Charity?> _getCharityData(EntityDto entity) async {
    final pairs =
        await _entityPairService.getByRecipientId(entity.id);
    if (pairs == null) {
      ZOLogger.logMessage("Unable to get canteen data, no pair "
          "is found for recipient ID ${entity.id}");
      return null;
    }

    return Charity(
      entityId: entity.id,
      email: entity.email,
      establishmentName: entity.establishmentName,
      establishmentId: entity.establishmentId,
      organization: entity.organization,
      donorId: pairs.map((e) => e.donorId).toList(),
      lastAcceptedAppTermsVersion: _mapLastAcceptedAppTermsVersion(entity.lastAcceptedAppTermsVersion)
    );
  }

  // Mapping

  int? _mapLastAcceptedAppTermsVersion(String? version) {
    int? lastAcceptedAppTermsVersion = null;
    if (version != null) {
      lastAcceptedAppTermsVersion = int.parse(version);
    }

    return lastAcceptedAppTermsVersion;
  }
}
