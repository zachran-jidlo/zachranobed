import 'package:json_annotation/json_annotation.dart';
import 'package:zachranobed/models/user_data.dart';

/*
 * Command to rebuild the canteen.g.dart file:
 * flutter packages pub run build_runner build --delete-conflicting-outputs
 */
part 'canteen.g.dart';

@JsonSerializable()
class Canteen extends UserData {
  final String? pickUpFrom;
  final String? pickUpWithin;
  final String? recipientId;

  Canteen({
    required super.email,
    required super.establishmentName,
    required super.establishmentId,
    required super.organization,
    this.pickUpFrom,
    this.pickUpWithin,
    this.recipientId,
  });

  factory Canteen.fromJson(Map<String, dynamic> json) =>
      _$CanteenFromJson(json);

  Map<String, dynamic> toJson() => _$CanteenToJson(this);
}
