import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:zachranobed/common/data/dto/paired_entity_dto.dart';
import 'package:zachranobed/common/domain/utils/zo_logger.dart';

/// Reads contact data of the entities the signed-in user is paired with.
class PairedEntityService {
  /// Must match the region the functions are deployed to.
  static const _region = 'europe-west1';

  /// How long a fetched result is reused.
  ///
  /// The app resolves pairs on every start, on every resume and on a few
  /// screens, which would otherwise be a separate call each time. Pairing
  /// changes are admin driven and rare, so a short window costs nothing and
  /// still picks a new pair up without a restart.
  static const _cacheDuration = Duration(seconds: 60);

  final _functions = FirebaseFunctions.instanceFor(region: _region);

  Future<List<PairedEntityDto>>? _cached;
  DateTime? _cachedAt;

  /// Fetches the entities with the given [ids].
  ///
  /// Anything the caller is not paired with is missing from the result, the
  /// function never returns it.
  Future<List<PairedEntityDto>> fetchEntities(List<String> ids) async {
    final entities = await _getAll();
    final byId = {for (final entity in entities) entity.id: entity};

    final missing = ids.where((id) => !byId.containsKey(id));
    if (missing.isNotEmpty) {
      ZOLogger.logMessage(
        'Paired entities not returned for ids ${missing.join(', ')}',
        isError: true,
      );
    }

    return ids.map((id) => byId[id]).nonNulls.toList();
  }

  /// Drops the cached result. Call when the signed-in account changes.
  void clearCache() {
    _cached = null;
    _cachedAt = null;
  }

  /// Fetches the caller's own entity together with every entity it is paired
  /// with, reusing the last result within [_cacheDuration].
  ///
  /// Throws when the call fails, so a transient error is not mistaken for an
  /// account without pairs. A failed call is not cached.
  Future<List<PairedEntityDto>> _getAll() async {
    final cached = _cached;
    final cachedAt = _cachedAt;
    if (cached != null && cachedAt != null && DateTime.now().difference(cachedAt) < _cacheDuration) {
      return cached;
    }

    _cachedAt = DateTime.now();
    final request = _fetchAll();
    _cached = request;

    try {
      return await request;
    } catch (_) {
      clearCache();
      rethrow;
    }
  }

  Future<List<PairedEntityDto>> _fetchAll() async {
    final result = await _functions.httpsCallable('getPairedEntities').call();

    // Normalize the whole payload first
    final data = jsonDecode(jsonEncode(result.data)) as Map<String, dynamic>;
    final entities = data['entities'] as List<dynamic>? ?? const [];

    return entities.map((e) => PairedEntityDto.fromJson(e as Map<String, dynamic>)).toList();
  }
}
