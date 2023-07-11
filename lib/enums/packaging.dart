import 'package:zachranobed/shared/constants.dart';

enum Packaging {
  rekrabicka,
  ikeaBox,
  disposablePackaging,
}

extension PackagingExtension on Packaging {
  String get packagingName {
    switch (this) {
      case Packaging.rekrabicka:
        return ZOStrings.packagingRekrabicka;
      case Packaging.ikeaBox:
        return ZOStrings.packagingIkeaBox;
      case Packaging.disposablePackaging:
        return ZOStrings.packagingDisposable;
      default:
        return '';
    }
  }
}
