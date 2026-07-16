import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:zachranobed/common/data/prefs/entity_pair_struct.dart';
import 'package:zachranobed/common/domain/utils/iterable_utils.dart';

/// A wrapper around [SharedPreferences] for managing application preferences.
class AppPreferences {
  /// Key for storing the active pair donor ID.
  static const _keyActivePairDonorId = "KEY_ACTIVE_PAIR_DONOR_ID";

  /// Key for storing the active pair recipient ID.
  static const _keyActivePairRecipientId = "KEY_ACTIVE_PAIR_RECIPIENT_ID";

  /// Key for storing the IDs of banners the user has dismissed.
  static const _keyDismissedBanners = "KEY_DISMISSED_BANNERS";

  /// Signals a change to the dismissed banner IDs so observers re-read them.
  final _dismissedChanged = StreamController<void>.broadcast();

  /// Sets the given entity [pair] as active.
  Future<void> setActivePair(EntityPairStruct pair) async {
    final prefs = await _prefs();
    prefs.setString(_keyActivePairDonorId, pair.donorId);
    prefs.setString(_keyActivePairRecipientId, pair.recipientId);
  }

  /// Gets the active entity pair. Returns the active entity pair, or `null`
  /// if no active pair is set.
  Future<EntityPairStruct?> getActivePair() async {
    final prefs = await _prefs();
    final donorId = prefs.getString(_keyActivePairDonorId);
    final recipientId = prefs.getString(_keyActivePairRecipientId);
    if (donorId == null || recipientId == null) {
      return null;
    }
    return EntityPairStruct(donorId: donorId, recipientId: recipientId);
  }

  /// Observes the dismissed banner IDs. Reads once on subscribe, then re-reads
  /// whenever a banner is dismissed.
  Stream<Set<String>> observeDismissedBanners() async* {
    yield await _readDismissedBanners();

    await for (final _ in _dismissedChanged.stream) {
      yield await _readDismissedBanners();
    }
  }

  /// Marks the banner with the given [id] as dismissed so it no longer shows.
  Future<void> addDismissedBanner(String id) async {
    final current = await _readDismissedBanners();
    final prefs = await _prefs();
    await prefs.setStringList(_keyDismissedBanners, {...current, id}.toList());
    _dismissedChanged.add(null);
  }

  /// Clears all preferences.
  ///
  /// Returns `true` if the preferences were successfully cleared, `false`
  /// otherwise.
  Future<bool> clear() async {
    final prefs = await _prefs();
    final result = await prefs.clear();
    _dismissedChanged.add(null);
    return result;
  }

  Future<Set<String>> _readDismissedBanners() async {
    final prefs = await _prefs();
    return prefs.getStringList(_keyDismissedBanners).orEmpty().toSet();
  }

  /// Gets an instance of [SharedPreferences].
  Future<SharedPreferences> _prefs() async {
    return await SharedPreferences.getInstance();
  }
}
