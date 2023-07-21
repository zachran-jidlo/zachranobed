import 'package:json_annotation/json_annotation.dart';

/*
 * Command to rebuild the user_data.g.dart file:
 * flutter packages pub run build_runner build --delete-conflicting-outputs
 */
part 'delivery.g.dart';

@JsonSerializable()
class Delivery {
  final String id;
  final String donor;
  final String state;

  Delivery({
    required this.id,
    required this.donor,
    required this.state,
  });

  factory Delivery.fromJson(Map<String, dynamic> json) =>
      _$DeliveryFromJson(json);

  Map<String, dynamic> toJson() => _$DeliveryToJson(this);

  Delivery copyWith({
    String? id,
    String? donor,
    String? state,
  }) {
    return Delivery(
      id: id ?? this.id,
      donor: donor ?? this.donor,
      state: state ?? this.state,
    );
  }
}
