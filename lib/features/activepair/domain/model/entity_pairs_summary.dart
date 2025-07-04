import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zachranobed/models/entity_pair.dart';

/*
 * Command to rebuild the entity_pairs_summary.freezed.dart file:
 * flutter packages pub run build_runner build --delete-conflicting-outputs
 */
part 'entity_pairs_summary.freezed.dart';

/// A summary of entity pairs.
///
/// This class holds information about the currently active pair and other
/// available pairs.
@freezed
abstract class EntityPairsSummary with _$EntityPairsSummary {
  /// Creates a new [EntityPairsSummary] instance.
  const factory EntityPairsSummary({
    /// The currently active pair.
    required EntityPair active,

    /// A list of other available pairs.
    required List<EntityPair> otherPairs,
  }) = $EntityPairsSummary;
}
