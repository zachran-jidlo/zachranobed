import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zachranobed/common/data/dto/entity_dto.dart';
import 'package:zachranobed/common/data/dto/entity_pair_dto.dart';
import 'package:zachranobed/common/data/mapper/entity_pair_mapper.dart';
import 'package:zachranobed/common/data/prefs/app_preferences.dart';
import 'package:zachranobed/common/data/service/entity_pairs_service.dart';
import 'package:zachranobed/common/data/service/entity_service.dart';
import 'package:zachranobed/common/data/service/paired_entity_service.dart';
import 'package:zachranobed/common/data/utils/auth_error_codes.dart';
import 'package:zachranobed/common/data/utils/firebase_helper.dart';
import 'package:zachranobed/common/domain/model/entity_pair.dart';
import 'package:zachranobed/common/domain/model/user_data.dart';
import 'package:zachranobed/common/domain/usecase/get_device_id_usecase.dart';
import 'package:zachranobed/common/domain/utils/zo_logger.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final EntityService _entityService;
  final PairedEntityService _pairedEntityService;
  final EntityPairService _entityPairService;
  final AppPreferences _appPreferences;
  final GetDeviceIdUseCase _getDeviceId;

  AuthService(
    this._entityService,
    this._pairedEntityService,
    this._entityPairService,
    this._appPreferences,
    this._getDeviceId,
  );

  /// Fetches the entity of the signed-in user, which also determines the
  /// user's role. Depending on the entity type (`donor` or `recipient`) it
  /// returns the corresponding user data from the respective services.
  ///
  /// The entity is taken from the `entityId` custom claim, which is set on the
  /// account when it is created. Security rules read the same claim, so the app
  /// and the rules can never disagree on who the caller is.
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

    final token = await user.getIdTokenResult();
    final entityId = token.claims?['entityId'] as String?;
    if (entityId == null) {
      ZOLogger.logMessage(
        "Unable to get user data, the account has no entityId claim",
        isError: true,
      );
      return null;
    }

    final entity = await _entityService.getById(entityId);
    if (entity == null) {
      ZOLogger.logMessage(
        "Unable to get user data, entity $entityId is not found",
        isError: true,
      );
      return null;
    }

    final entityType = entity.entityType;
    if (entityType == null) {
      ZOLogger.logMessage(
        "Unable to get user data, entity type "
        "is not recognised for entity $entityId",
        isError: true,
      );
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

  /// Checks whether the session still exists on the server.
  ///
  /// Forces a token refresh, which Firebase rejects once the session is
  /// revoked. Returns `false` only in that case, so a failed check or an
  /// offline device never signs the user out.
  Future<bool> isSessionValid() async {
    ZOLogger.logMessage("Session check started");

    final user = _auth.currentUser ?? await _waitForRestoredUser();
    if (user == null) {
      ZOLogger.logMessage("Session check skipped, nobody is signed in");
      return true;
    }

    try {
      await user.getIdToken(true);
      ZOLogger.logMessage("Session check passed, the session is still valid");
      return true;
    } on FirebaseAuthException catch (e) {
      if (AuthErrorCodes.isSessionRevoked(e.code)) {
        ZOLogger.logMessage("Session check failed, the session was revoked: ${e.code}");
        return false;
      }
      ZOLogger.logMessage("Session check failed, keeping the session: $e");
      return true;
    } on Exception catch (e) {
      ZOLogger.logMessage("Session check failed, keeping the session: $e");
      return true;
    }
  }

  /// Waits for the first auth state value, capped so it cannot block app start.
  ///
  /// On the web the persisted user is restored asynchronously, so
  /// [FirebaseAuth.currentUser] can still be `null` right after a cold start.
  Future<User?> _waitForRestoredUser() async {
    ZOLogger.logMessage("Waiting for the restored auth state");

    try {
      final user = await _auth.authStateChanges().first.timeout(const Duration(seconds: 3));
      ZOLogger.logMessage("Restored auth state read, signed in: ${user != null}");
      return user;
    } on Exception catch (e) {
      ZOLogger.logMessage("Unable to read the restored auth state: $e");
      return null;
    }
  }

  /// Signs out the current user with the given [entityId].
  Future<void> signOut(String? entityId) async {
    if (entityId != null) {
      try {
        final deviceId = await _getDeviceId.invoke();
        await _entityService.updateFCMToken(entityId, null, deviceId);
      } on Exception catch (e) {
        ZOLogger.logException(e, "Unable to update FCM token, user is probably offline");
      }
    }
    await _auth.signOut();
    await _appPreferences.clear();
    _pairedEntityService.clearCache();
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

  /// Stream that emits whenever the Firebase Auth session state changes.
  ///
  /// Emits the current [User] when authenticated, or `null` when the session
  /// ends (sign-out, token revocation, account disabled, etc.).
  Stream<User?> observeAuthState() => _auth.authStateChanges();

  /// Fetches canteen data from entity pairs relation.
  Future<Canteen?> _getCanteenData(EntityDto entity) async {
    final pairs = await _entityPairService.getByDonorId(entity.id);
    if (pairs == null) {
      ZOLogger.logMessage(
        "Unable to get canteen data, no pair "
        "is found for donor ID ${entity.id}",
      );
      return null;
    }

    final pairsInfo = await _resolvePairsInfo(
      userEntityId: entity.id,
      pairs: pairs,
    );
    final activePair = pairsInfo.activePair;
    if (activePair == null) {
      ZOLogger.logMessage(
        "Unable to get canteen data, no active "
        "pair is found",
      );
      return null;
    }

    return Canteen(
      entityId: entity.id,
      email: entity.email,
      establishmentName: entity.establishmentName,
      establishmentId: entity.establishmentId,
      organization: entity.organization,
      lastAcceptedAppTermsVersion: entity.lastAcceptedAppTermsVersion,
      activePair: activePair,
      allPairs: pairsInfo.allPairs,
      tags: entity.tags ?? const [],
    );
  }

  /// Fetches charity data from entity pairs relation.
  Future<Charity?> _getCharityData(EntityDto entity) async {
    final pairs = await _entityPairService.getByRecipientId(entity.id);
    if (pairs == null) {
      ZOLogger.logMessage(
        "Unable to get charity data, no pair "
        "is found for recipient ID ${entity.id}",
      );
      return null;
    }

    final pairsInfo = await _resolvePairsInfo(
      userEntityId: entity.id,
      pairs: pairs,
    );
    final activePair = pairsInfo.activePair;
    if (activePair == null) {
      ZOLogger.logMessage(
        "Unable to get charity data, no active "
        "pair is found",
      );
      return null;
    }

    return Charity(
      entityId: entity.id,
      email: entity.email,
      establishmentName: entity.establishmentName,
      establishmentId: entity.establishmentId,
      organization: entity.organization,
      lastAcceptedAppTermsVersion: entity.lastAcceptedAppTermsVersion,
      activePair: activePair,
      allPairs: pairsInfo.allPairs,
      tags: entity.tags ?? const [],
    );
  }

  Future<_PairsInfo> _resolvePairsInfo({
    required String userEntityId,
    required List<EntityPairDto> pairs,
  }) async {
    final entityPairs = await pairs.toDomain(
      userEntityId: userEntityId,
      entities: _pairedEntityService.fetchEntities,
    );

    final savedActivePair = await _appPreferences.getActivePair();
    final activePair = entityPairs.firstWhereOrNull(
      (pair) =>
          pair.enabled && //
          pair.donorId == savedActivePair?.donorId &&
          pair.recipientId == savedActivePair?.recipientId,
    );

    // Fall back to any active pair before settling for an inactive one
    return _PairsInfo(
      activePair: activePair ?? entityPairs.firstWhereOrNull((pair) => pair.enabled) ?? entityPairs.firstOrNull,
      allPairs: entityPairs,
    );
  }
}

class _PairsInfo {
  final EntityPair? activePair;
  final List<EntityPair> allPairs;

  _PairsInfo({
    required this.activePair,
    required this.allPairs,
  });
}
