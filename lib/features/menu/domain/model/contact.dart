import 'package:freezed_annotation/freezed_annotation.dart';

/*
 * Command to rebuild the contact.freezed.dart file:
 * flutter packages pub run build_runner build --delete-conflicting-outputs
 */
part 'contact.freezed.dart';

@freezed
abstract class Contact with _$Contact {
  const Contact._();

  const factory Contact({
    required String name,
    required String? position,
    required String? phoneNumber,
  }) = $Contact;

  /// Returns the formatted name with position if available.
  ///
  /// Format: "Name - Position" if position exists, otherwise just "Name".
  String get formattedName {
    return position != null ? "$name - $position" : name;
  }
}
