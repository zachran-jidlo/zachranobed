import 'package:flutter/material.dart';

import 'canteen.dart';

abstract class UserData extends ChangeNotifier {
  final String entityId;
  final String email;
  final String establishmentName;
  final String establishmentId;
  final String organization;
  final int? lastAcceptedAppTermsVersion;

  UserData(
      {required this.entityId,
      required this.email,
      required this.establishmentName,
      required this.establishmentId,
      required this.organization,
      required this.lastAcceptedAppTermsVersion});

  String get debugInfo {
    return '''
      EntityID: $entityId, 
      Email: $email,
      Establishment: $establishmentName,
      ID: $establishmentId,
      Organization: $organization,
      Last accepted app terms version: $lastAcceptedAppTermsVersion
    ''';
  }
}

/// Extension [TimeCheck] on [UserData].
///
/// This extension provides additional methods related to time checking for [UserData] objects.
extension TimeCheck on UserData {
  /// Checks if the current time is within the pickup range for a [Canteen].
  ///
  /// This method is only applicable if the [UserData] instance is a [Canteen].
  /// It splits the pickup times into parts, creates [DateTime] objects for them,
  /// and checks if the current time is within this range.
  ///
  /// Returns `true` if the current time is within the pickup range, `false` otherwise.
  bool isCurrentTimeWithinPickupRange() {
    if (this is Canteen) {
      Canteen canteen = this as Canteen;
      DateTime now = DateTime.now();
      DateTime timeFrom = _getTime(canteen.pickUpFrom, now);
      DateTime timeWithin = _getTime(canteen.pickUpWithin, now);
      return now.isAfter(timeFrom) && now.isBefore(timeWithin);
    }
    return false;
  }

  /// Helper method to create a [DateTime] object from a time string.
  ///
  /// The time string should be in the format 'HH:mm'. The [DateTime] object
  /// is created with the current date and the time from the time string.
  ///
  /// Returns a [DateTime] object with the current date and the time from the time string.
  DateTime _getTime(String time, DateTime now) {
    List<String> timeParts = time.split(':');
    return DateTime(now.year, now.month, now.day, int.parse(timeParts[0]),
        int.parse(timeParts[1]));
  }
}
