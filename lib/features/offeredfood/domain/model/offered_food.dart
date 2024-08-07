import 'package:freezed_annotation/freezed_annotation.dart';

/*
 * Command to rebuild the offered_food.g.dart file:
 * flutter packages pub run build_runner build --delete-conflicting-outputs
 */
part 'offered_food.freezed.dart';

@Freezed()
class OfferedFood with _$OfferedFood {
  const factory OfferedFood({
    required String id,
    required DateTime date,
    required String dishName,
    required String foodCategory,
    required List<String> allergens,
    required int numberOfServings,
    required String boxType,
    required DateTime consumeBy,
    required String donorId,
    required String recipientId,
    required int numberOfBoxes,
  }) = _OfferedFood;
}
