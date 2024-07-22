import 'package:freezed_annotation/freezed_annotation.dart';

/*
 * Command to rebuild the contact.freezed.dart file:
 * flutter packages pub run build_runner build --delete-conflicting-outputs
 */
part 'contact.freezed.dart';

@Freezed()
class Contact with _$Contact {
  const factory Contact({
    required String name,
    required String? phoneNumber,
  }) = $Contact;
}
