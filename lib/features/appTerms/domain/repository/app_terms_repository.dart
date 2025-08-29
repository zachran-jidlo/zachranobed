/// Repository to manage app terms related operations.
abstract class AppTermsRepository {
  /// Updates the accepted app terms version for a user with the given [entityId].
  Future<void> updateAcceptedAppTermsVersion({
    required String entityId,
    required int appTermsVersion,
  });
}
