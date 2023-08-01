import 'package:flutter/cupertino.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';

enum Packaging {
  reusableBox,
  ikeaBox,
  disposablePackaging,
}

abstract class PackagingHelper {
  static String toValue(Packaging packaging, BuildContext context) {
    switch (packaging) {
      case Packaging.reusableBox:
        return context.l10n!.packagingRekrabicka;
      case Packaging.ikeaBox:
        return context.l10n!.packagingIkeaBox;
      case Packaging.disposablePackaging:
        return context.l10n!.packagingDisposable;
      default:
        return '';
    }
  }
}
