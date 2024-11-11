import 'package:shared_preferences/shared_preferences.dart';
import 'package:zachranobed/common/prefs/entity_pair_struct.dart';

/// A wrapper around [SharedPreferences] for managing application preferences.
class AppPreferences {
  /// Key for storing the active pair donor ID.
  static const _keyActivePairDonorId = "KEY_ACTIVE_PAIR_DONOR_ID";

  /// Key for storing the active pair recipient ID.
  static const _keyActivePairRecipientId = "KEY_ACTIVE_PAIR_RECIPIENT_ID";

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

  /// Clears all preferences.
  ///
  /// Returns `true` if the preferences were successfully cleared, `false`
  /// otherwise.
  Future<bool> clear() async {
    final prefs = await _prefs();
    return prefs.clear();
  }

  /// Gets an instance of [SharedPreferences].
  Future<SharedPreferences> _prefs() async {
    return await SharedPreferences.getInstance();
  }
}
