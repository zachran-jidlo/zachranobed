import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A sealed class representing an icon specification that can be either a Flutter [IconData] or an SVG asset path.
sealed class UiIconSpec {
  const UiIconSpec();

  /// Creates an icon specification from Flutter's [IconData].
  const factory UiIconSpec.data(IconData iconData) = UiIconDataSpec;

  /// Creates an icon specification from an SVG asset path.
  ///
  /// Set [applyTint] to false to render the SVG with its original colors.
  const factory UiIconSpec.svg(String assetPath, {bool applyTint}) = UiSvgAssetSpec;
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

  /// Whether to apply tint color to the SVG.
  ///
  /// When true (default), the SVG is tinted with the icon color.
  /// When false, the SVG renders with its original colors.
  final bool applyTint;

  /// Creates a [UiSvgAssetSpec].
  const UiSvgAssetSpec(this.assetPath, {this.applyTint = true});
}

/// A widget that renders an icon based on the provided [UiIconSpec].
///
/// This widget can display either a standard Flutter icon (using [IconData])
/// or an SVG icon (using an asset path).
///
/// For Material icons, size and color are passed directly to the [Icon] widget,
/// which automatically falls back to [IconTheme] when not specified.
///
/// For SVG icons, size and color explicitly fall back to [IconTheme] values
/// when not provided, ensuring consistent behavior across icon types.
class UiIcon extends StatelessWidget {
  /// The icon specification to render.
  final UiIconSpec spec;

  /// Optional size override for the icon.
  ///
  /// If not provided, falls back to the size from the current [IconTheme].
  final double? size;

  /// Optional color override for the icon.
  ///
  /// If not provided, falls back to the color from the current [IconTheme].
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
    final iconTheme = IconTheme.of(context);

    return switch (spec) {
      UiIconDataSpec(:final iconData) => Icon(
          iconData,
          size: size,
          color: color,
        ),
      UiSvgAssetSpec(:final assetPath, :final applyTint) => SvgPicture.asset(
          assetPath,
          width: size ?? iconTheme.size,
          height: size ?? iconTheme.size,
          colorFilter: applyTint ? _buildColorFilter(color, iconTheme.color) : null,
        ),
    };
  }

  ColorFilter? _buildColorFilter(Color? explicitColor, Color? themeColor) {
    final effectiveColor = explicitColor ?? themeColor;
    return effectiveColor != null ? ColorFilter.mode(effectiveColor, BlendMode.srcIn) : null;
  }
}
