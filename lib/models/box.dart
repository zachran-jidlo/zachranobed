import 'package:json_annotation/json_annotation.dart';

/*
 * Command to rebuild the box.g.dart file:
 * flutter packages pub run build_runner build --delete-conflicting-outputs
 */
part 'box.g.dart';

@JsonSerializable()
class Box {
  final String charityId;
  final String canteenId;
  final String boxType;
  final int totalQuantity;
  final int quantityAtCharity;
  final int quantityAtCanteen;

  const Box({
    required this.charityId,
    required this.canteenId,
    required this.boxType,
    required this.totalQuantity,
    required this.quantityAtCharity,
    required this.quantityAtCanteen,
  });

  factory Box.fromJson(Map<String, dynamic> json) => _$BoxFromJson(json);

  Map<String, dynamic> toJson() => _$BoxToJson(this);
}
