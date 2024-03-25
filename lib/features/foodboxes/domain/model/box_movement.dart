import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zachranobed/features/foodboxes/domain/model/food_box_type.dart';

/*
 * Command to rebuild the box_movement.freezed.dart file:
 * flutter packages pub run build_runner build --delete-conflicting-outputs
 */
part 'box_movement.freezed.dart';

@Freezed()
class BoxMovement with _$BoxMovement {
  const factory BoxMovement({
    required FoodBoxType type,
    required int count,
    required DateTime date,
  }) = _BoxMovement;
}
