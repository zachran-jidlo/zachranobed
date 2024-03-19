import 'package:zachranobed/features/appConfiguration/entity/api_configuration.dart';
import 'package:zachranobed/features/appConfiguration/entity/build_configuration.dart';

/// The `AppConfiguration` class manages the build and API configurations for the application.
///
/// It provides a centralized way to handle and retrieve the current build and API configurations.
/// The class follows a singleton pattern, ensuring that there is only one instance of `AppConfiguration`
/// throughout the application.
///
/// ## Example:
///
/// ```dart
/// // Access the singleton instance of AppConfiguration.
/// AppConfiguration appConfig = AppConfiguration.instance;
///
/// // Set the environment values for build and API configurations.
/// appConfig.set(BuildConfiguration.dev, ApiConfiguration.staging);
///
/// // Retrieve the current build configuration.
/// BuildConfiguration currentBuildConfig = appConfig.buildConfiguration;
///
/// // Retrieve the current API configuration.
/// ApiConfiguration currentApiConfig = appConfig.apiConfiguration;
/// ```
class AppConfiguration {
  BuildConfiguration buildConfiguration = BuildConfiguration.prod;
  ApiConfiguration apiConfiguration = ApiConfiguration.prod;

  AppConfiguration._();

  static final AppConfiguration _instance = AppConfiguration._();
  static AppConfiguration get instance => _instance;

  AppConfiguration({
    this.buildConfiguration = BuildConfiguration.prod,
    this.apiConfiguration = ApiConfiguration.prod
  });

  /// Sets the environment values for the build and API configurations.
  ///
  /// This method allows you to dynamically change the build and API configurations during runtime.
  /// After calling this method, the [buildConfiguration] and [apiConfiguration] properties will be updated.
  ///
  /// Example:
  /// ```dart
  /// appConfig.set(BuildConfiguration.dev, ApiConfiguration.staging);
  /// ```
  void set(
    BuildConfiguration buildConfiguration,
    ApiConfiguration apiConfiguration
  ) {
    this.buildConfiguration = buildConfiguration;
    this.apiConfiguration = apiConfiguration;
  }
}