import 'package:zachranobed/common/data/prefs/app_preferences.dart';
import 'package:zachranobed/features/banners/data/mapper/banner_mapper.dart';
import 'package:zachranobed/features/banners/data/service/banner_service.dart';
import 'package:zachranobed/features/banners/domain/model/banner.dart';
import 'package:zachranobed/features/banners/domain/repository/banner_repository.dart';

class FirebaseBannerRepository implements BannerRepository {
  final BannerService _service;
  final AppPreferences _appPreferences;

  FirebaseBannerRepository(this._service, this._appPreferences);

  @override
  Stream<List<Banner>> observeActive() {
    return _service.observeActive().map((dtos) => dtos.toDomain());
  }

  @override
  Stream<Set<String>> observeDismissedIds() {
    return _appPreferences.observeDismissedBanners();
  }

  @override
  Future<void> dismiss(String id) {
    return _appPreferences.addDismissedBanner(id);
  }
}
