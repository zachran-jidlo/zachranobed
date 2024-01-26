import 'package:zachranobed/features/appConfiguration/entity/ApiConfiguration.dart';
import 'package:zachranobed/features/appConfiguration/entity/BuildConfiguration.dart';

class AppConfiguration {
  BuildConfiguration buildConfiguration;
  ApiConfiguration apiConfiguration;

  AppConfiguration({
    this.buildConfiguration = BuildConfiguration.prod,
    this.apiConfiguration = ApiConfiguration.prod
  });

  void set(
    BuildConfiguration buildConfiguration,
    ApiConfiguration apiConfiguration
  ) {
    this.buildConfiguration = buildConfiguration;
    this.apiConfiguration = apiConfiguration;
  }
}