/// The `ProjectConfiguration` class manages the build and API configurations for the application.
class ProjectConfiguration {
  BuildConfiguration buildConfiguration = BuildConfiguration.prod;
  ApiConfiguration apiConfiguration = ApiConfiguration.prod;

  ProjectConfiguration._();

  static final ProjectConfiguration _instance = ProjectConfiguration._();

  static ProjectConfiguration get instance => _instance;

  ProjectConfiguration({
    this.buildConfiguration = BuildConfiguration.prod,
    this.apiConfiguration = ApiConfiguration.prod,
  });

  /// Sets the environment values for the build and API configurations.
  void set(BuildConfiguration buildConfiguration, ApiConfiguration apiConfiguration) {
    this.buildConfiguration = buildConfiguration;
    this.apiConfiguration = apiConfiguration;
  }
}

class ProjectConfigurationMapper {
  ProjectConfigurationMapper._();

  static BuildConfiguration mapBuildConfiguration(String? flavor) {
    switch (flavor) {
      case "dev":
        return BuildConfiguration.dev;
      case "stage":
        return BuildConfiguration.stage;
      case "prod":
        return BuildConfiguration.prod;
      default:
        // When we can not resolve flavor type, it is safe to use the `prod` option
        return BuildConfiguration.prod;
    }
  }

  static ApiConfiguration mapApiConfiguration(String? flavor) {
    switch (flavor) {
      case "dev":
        return ApiConfiguration.dev;
      case "stage":
        return ApiConfiguration.stage;
      case "prod":
        return ApiConfiguration.prod;
      default:
        // When we can not resolve flavor type, it is safe to use the `prod` option
        return ApiConfiguration.prod;
    }
  }
}

enum ApiConfiguration {
  dev,
  stage,
  prod,
}

enum BuildConfiguration {
  dev,
  stage,
  prod,
}
