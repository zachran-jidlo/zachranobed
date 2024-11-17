import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// An icon that displays an SVG image with the size and color determined by
/// the [IconTheme] of the current context.
class SvgIcon extends StatelessWidget {
  /// The path to the SVG image asset.
  final String resource;

  /// Creates a new [SvgIcon] widget.
  ///
  /// The [resource] parameter is required and specifies the path to the SVG
  /// image asset.
  const SvgIcon({
    super.key,
    required this.resource,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        final iconTheme = IconTheme.of(context);
        return SvgPicture.asset(
          resource,
          width: iconTheme.size,
          height: iconTheme.size,
          colorFilter: ColorFilter.mode(
            iconTheme.color ?? Colors.transparent,
            BlendMode.srcIn,
          ),
        );
      },
    );
  }
}
