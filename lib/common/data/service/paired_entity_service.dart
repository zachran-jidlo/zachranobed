import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:zachranobed/common/data/dto/paired_entity_dto.dart';

/// Reads contact data of the entities the signed-in user is paired with.
class PairedEntityService {
  /// Must match the region the functions are deployed to.
  static const _region = 'europe-west1';

  final _functions = FirebaseFunctions.instanceFor(region: _region);

  /// Fetches the entities with the given [ids].
  ///
  /// Anything the caller is not paired with is missing from the result, the
  /// function never returns it.
  Future<List<PairedEntityDto>> fetchEntities(List<String> ids) async {
    final entities = await _getAll();
    return entities.where((e) => ids.contains(e.id)).toList();
  }

  /// Fetches the caller's own entity together with every entity it is paired
  /// with.
  ///
  /// Throws when the call fails, so a transient error is not mistaken for an
  /// account without pairs.
  Future<List<PairedEntityDto>> _getAll() async {
    final result = await _functions.httpsCallable('getPairedEntities').call();

    // Normalize the whole payload first
    final data = jsonDecode(jsonEncode(result.data)) as Map<String, dynamic>;
    final entities = data['entities'] as List<dynamic>? ?? const [];

    return entities.map((e) => PairedEntityDto.fromJson(e as Map<String, dynamic>)).toList();
  }
}
