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
        return ZachranObedStrings.packagingRekrabicka;
      case Packaging.ikeaBox:
        return ZachranObedStrings.packagingIkeaBox;
      case Packaging.disposablePackaging:
        return ZachranObedStrings.packagingDisposable;
      default:
        return '';
    }
  }
}
