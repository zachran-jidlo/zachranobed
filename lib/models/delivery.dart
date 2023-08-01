import 'package:freezed_annotation/freezed_annotation.dart';

/*
 * Command to rebuild the delivery.g.dart file:
 * flutter pub run build_runner build --delete-conflicting-outputs
 */
part 'delivery.freezed.dart';
part 'delivery.g.dart';

@Freezed()
class Delivery with _$Delivery {
  const factory Delivery({
    required String id,
    required String donor,
    required String state,
  }) = _Delivery;

  factory Delivery.fromJson(Map<String, dynamic> json) =>
      _$DeliveryFromJson(json);
}
