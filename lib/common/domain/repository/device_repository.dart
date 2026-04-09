/// Repository for device and app metadata.
abstract class DeviceRepository {
  /// Returns the device ID, or null if unavailable.
  Future<String?> getDeviceId();

  /// Returns the app version string including build number (e.g. "1.0.0 (42)").
  Future<String> getAppVersion();

  /// Returns the semantic app version (e.g. "1.0.0").
  Future<String> getAppSemanticVersion();
}
