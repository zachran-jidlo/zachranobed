import 'package:zachranobed/common/utils/generic_utils.dart';
import 'package:zachranobed/features/menu/domain/model/contact.dart';
import 'package:zachranobed/models/dto/contact_dto.dart';

/// DTO to domain mapper for [Contact].
extension ContactMapper on ContactDto {
  /// Maps DTO to domain representation.
  Contact toDomain() {
    return Contact(
      name: name,
      phoneNumber: phoneNumber?.takeIf((e) => e.isNotEmpty),
    );
  }
}
