import 'package:json_annotation/json_annotation.dart';
import 'package:zachranobed/models/dto/contact_dto.dart';

/*
 * Command to rebuild the carrier_dto.g.dart file:
 * flutter packages pub run build_runner build --delete-conflicting-outputs
 */
part 'carrier_dto.g.dart';

@JsonSerializable()
class CarrierDto {
  final List<ContactDto>? contacts;

  CarrierDto({
    required this.contacts,
  });

  factory CarrierDto.fromJson(Map<String, dynamic> json) =>
      _$CarrierDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CarrierDtoToJson(this);
}
