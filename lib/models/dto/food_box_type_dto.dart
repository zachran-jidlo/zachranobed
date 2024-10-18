import 'package:json_annotation/json_annotation.dart';

/*
 * Command to rebuild the food_box_type_dto.g.dart file:
 * flutter packages pub run build_runner build --delete-conflicting-outputs
 */
part 'food_box_type_dto.g.dart';

@JsonSerializable()
class FoodBoxTypeDto {

  static const String idRekrabicka = "rekrabicka";
  static const String idIkeaLarge = "ikea_large";
  static const String idIkeaSmall = "ikea_small";
  static const String idDisposable = "disposable";
  static const String idOther = "other";

  final String id;
  final String name;
  final String type;

  FoodBoxTypeDto({
    required this.id,
    required this.name,
    required this.type,
  });

  factory FoodBoxTypeDto.fromJson(Map<String, dynamic> json) =>
      _$FoodBoxTypeDtoFromJson(json);

  Map<String, dynamic> toJson() => _$FoodBoxTypeDtoToJson(this);
}
