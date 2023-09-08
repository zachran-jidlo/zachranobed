import 'package:flutter/cupertino.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';

enum BoxType {
  reusableBox,
  ikeaBoxSmall,
  ikeaBoxLarge,
  disposablePackaging,
}

abstract class BoxTypeHelper {
  static String toValue(BoxType boxType, BuildContext context) {
    switch (boxType) {
      case BoxType.reusableBox:
        return context.l10n!.boxTypeReKrabicka;
      case BoxType.ikeaBoxSmall:
        return context.l10n!.boxTypeIkeaBoxSmall;
      case BoxType.ikeaBoxLarge:
        return context.l10n!.boxTypeIkeaBoxLarge;
      case BoxType.disposablePackaging:
        return context.l10n!.packagingDisposable;
      default:
        return '';
    }
  }
}
