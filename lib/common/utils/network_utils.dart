import 'package:internet_connection_checker/internet_connection_checker.dart';

/// A utility class for checking network connectivity.
class NetworkUtils {
  /// Private constructor to prevent instantiation.
  NetworkUtils._();

  /// Checks if the device is connected to the internet.
  static Future<bool> isConnected() => InternetConnectionChecker().hasConnection;
}
