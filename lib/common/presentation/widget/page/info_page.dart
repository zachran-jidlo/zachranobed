import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';

/// A reusable informational page widget displaying an image, title, optional description, and action buttons.
///
/// This component is designed to display various informational states such as empty states, error messages,
/// onboarding screens, or success confirmations. It provides a consistent layout with an SVG illustration,
/// centered text content, and optional action buttons.
///
/// The component is wrapped in [SingleChildScrollView] to handle content overflow on smaller screens.
class InfoPage extends StatelessWidget {
  /// The path to the SVG asset to display at the top of the page.
  final String image;

  /// The main heading text displayed below the image.
  final String title;

  /// Optional descriptive text displayed below the title.
  final String? description;

  /// Optional list of action widgets (typically buttons) displayed at the bottom.
  final List<Widget>? actions;

  /// The amount of padding to add before the action widgets.
  final double paddingBeforeActions;

  /// Creates a [InfoPage] widget.
  const InfoPage({
    super.key,
    required this.image,
    required this.title,
    this.description,
    this.actions,
    this.paddingBeforeActions = 40.0,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(image),
              const SizedBox(height: 40.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: context.textStyles.titleHeavy,
                      textAlign: TextAlign.center,
                    ),
                    if (description != null) ...[
                      const SizedBox(height: 16.0),
                      Text(
                        description!,
                        style: context.textStyles.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    ],
                    if (actions != null) ...[
                      SizedBox(height: paddingBeforeActions),
                      ...actions!,
                    ]
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
