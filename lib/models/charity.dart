import 'package:json_annotation/json_annotation.dart';
import 'package:zachranobed/models/user_data.dart';

/*
 * Command to rebuild the charity.g.dart file:
 * flutter packages pub run build_runner build --delete-conflicting-outputs
 */
part 'charity.g.dart';

@JsonSerializable()
class Charity extends UserData {
  final List<String>? donorId;

  Charity({
    required super.email,
    required super.establishmentName,
    required super.establishmentId,
    required super.organization,
    this.donorId,
  });

  factory Charity.fromJson(Map<String, dynamic> json) =>
      _$CharityFromJson(json);

  Map<String, dynamic> toJson() => _$CharityToJson(this);
}
