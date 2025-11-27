import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A sealed class representing an icon specification that can be either a Flutter [IconData] or an SVG asset path.
sealed class UiIconSpec {
  const UiIconSpec();

  /// Creates an icon specification from Flutter's [IconData].
  const factory UiIconSpec.data(IconData iconData) = UiIconDataSpec;

  /// Creates an icon specification from an SVG asset path.
  const factory UiIconSpec.svg(String assetPath) = UiSvgAssetSpec;
}

/// Icon specification using Flutter's built-in [IconData].
class UiIconDataSpec extends UiIconSpec {
  /// The icon data to render.
  final IconData iconData;

  /// Creates a [UiIconDataSpec].
  const UiIconDataSpec(this.iconData);
}

/// Icon specification using an SVG asset path.
class UiSvgAssetSpec extends UiIconSpec {
  /// The path to the SVG asset.
  final String assetPath;

  /// Creates a [UiSvgAssetSpec].
  const UiSvgAssetSpec(this.assetPath);
}

/// A widget that renders an icon based on the provided [UiIconSpec].
///
/// This widget can display either a standard Flutter icon (using [IconData])
/// or an SVG icon (using an asset path). The icon's size and color are
/// determined by the [IconTheme] of the current context, unless overridden
/// by the [size] and [color] parameters.
class UiIcon extends StatelessWidget {
  /// The icon specification to render.
  final UiIconSpec spec;

  /// Optional size override for the icon.
  ///
  /// If not provided, uses the size from the current [IconTheme].
  final double? size;

  /// Optional color override for the icon.
  ///
  /// If not provided, uses the color from the current [IconTheme].
  final Color? color;

  /// Creates a [UiIcon] widget.
  const UiIcon({
    super.key,
    required this.spec,
    this.size,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return switch (spec) {
      UiIconDataSpec(:final iconData) => Icon(
          iconData,
          size: size,
          color: color,
        ),
      UiSvgAssetSpec(:final assetPath) => SvgPicture.asset(
          assetPath,
          width: size,
          height: size,
          colorFilter: color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
        ),
    };
  }
}
