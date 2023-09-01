import 'package:flutter/cupertino.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';

enum BoxType {
  reusableBox,
  ikeaBox,
  disposablePackaging,
}

abstract class BoxTypeHelper {
  static String toValue(BoxType boxType, BuildContext context) {
    switch (boxType) {
      case BoxType.reusableBox:
        return context.l10n!.boxTypeRekrabicka;
      case BoxType.ikeaBox:
        return context.l10n!.boxTypeIkeaBox;
      case BoxType.disposablePackaging:
        return context.l10n!.packagingDisposable;
      default:
        return '';
    }
  }
}
