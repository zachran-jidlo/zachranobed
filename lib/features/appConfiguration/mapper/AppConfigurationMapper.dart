import 'package:zachranobed/features/appConfiguration/entity/ApiConfiguration.dart';
import 'package:zachranobed/features/appConfiguration/entity/BuildConfiguration.dart';

class AppConfigurationMapper {
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