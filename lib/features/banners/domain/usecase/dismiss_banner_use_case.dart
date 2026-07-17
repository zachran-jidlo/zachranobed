import 'package:zachranobed/features/banners/domain/repository/banner_repository.dart';

/// Marks a banner as dismissed so it no longer shows.
class DismissBannerUseCase {
  final BannerRepository _repository;

  DismissBannerUseCase(this._repository);

  Future<void> invoke(String id) => _repository.dismiss(id);
}
