import 'package:zachranobed/features/banners/domain/model/banner.dart';

/// Repository for reading banners and tracking which ones the user dismissed.
abstract class BannerRepository {
  /// Observes all active banners, unfiltered by targeting.
  Stream<List<Banner>> observeActive();

  /// Observes the IDs of banners the user has dismissed.
  Stream<Set<String>> observeDismissedIds();

  /// Marks the banner with the given [id] as dismissed.
  Future<void> dismiss(String id);
}
