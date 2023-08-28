import 'package:json_annotation/json_annotation.dart';

/*
 * Command to rebuild the food_info.g.dart file:
 * flutter packages pub run build_runner build --delete-conflicting-outputs
 */
part 'food_info.g.dart';

@JsonSerializable()
class FoodInfo {
  String dishName;
  List<String>? allergens;
  int? numberOfServings;

  FoodInfo({this.dishName = '', this.allergens, this.numberOfServings});

  factory FoodInfo.fromJson(Map<String, dynamic> json) =>
      _$FoodInfoFromJson(json);

  Map<String, dynamic> toJson() => _$FoodInfoToJson(this);
}
