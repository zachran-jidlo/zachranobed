/// Represents the status of the acceptance of the terms and conditions.
enum AppTermsStatus {
  /// The user has accepted the current version of the terms and conditions.
  accepted,

  /// The user has not accepted the terms and conditions.
  notAccepted,

  /// A new version of the terms and conditions is available.
  newVersionIsAvailable,
}
