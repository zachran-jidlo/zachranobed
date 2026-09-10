import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';

/// Content for [InfoPage] title or description, supporting both simple text and custom widgets.
sealed class InfoPageContent {
  const InfoPageContent();

  /// Creates simple text content.
  const factory InfoPageContent.text(String text) = _TextContent;

  /// Creates custom widget content for advanced styling.
  ///
  /// This allows you to provide a fully styled Text widget or Text.rich widget.
  const factory InfoPageContent.widget(Widget widget) = _WidgetContent;
}

class _TextContent extends InfoPageContent {
  final String text;

  const _TextContent(this.text);
}

class _WidgetContent extends InfoPageContent {
  final Widget widget;

  const _WidgetContent(this.widget);
}

/// A reusable informational page widget displaying an image, title, optional description, and action buttons.
///
/// This component is designed to display various informational states such as empty states, error messages,
/// onboarding screens, or success confirmations. It provides a consistent layout with an SVG illustration,
/// centered text content, and optional action buttons.
///
/// The component is wrapped in [SingleChildScrollView] to handle content overflow on smaller screens.
class InfoPage extends StatelessWidget {
  /// Optional path to the SVG asset to display at the top of the page.
  final String? image;

  /// The main heading content displayed below the image.
  final InfoPageContent title;

  /// Optional descriptive content displayed below the title.
  final InfoPageContent? description;

  /// Optional list of action widgets (typically buttons) displayed at the bottom.
  final List<Widget>? actions;

  /// The amount of padding to add before the action widgets.
  final double paddingBeforeActions;

  /// Creates a [InfoPage] widget with simple text for title and description.
  ///
  /// This is the standard constructor for most use cases.
  InfoPage({
    super.key,
    this.image,
    required String title,
    String? description,
    this.actions,
    this.paddingBeforeActions = 40.0,
  })  : title = _TextContent(title),
        description = description != null ? _TextContent(description) : null;

  /// Creates a [InfoPage] widget with rich content for title and description.
  ///
  /// Use this constructor when you need custom styling beyond the default text styles.
  /// Follows the Flutter convention of `Text` vs `Text.rich`.
  ///
  /// Examples:
  /// ```dart
  /// // Custom styled title
  /// InfoPage.rich(
  ///   image: ImageAssets.example,
  ///   title: InfoPageContent.widget(
  ///     Text('Custom', style: TextStyle(color: Colors.red)),
  ///   ),
  /// )
  ///
  /// // Rich text description
  /// InfoPage.rich(
  ///   image: ImageAssets.example,
  ///   title: InfoPageContent.text('Title'),
  ///   description: InfoPageContent.widget(
  ///     Text.rich(
  ///       TextSpan(children: [
  ///         TextSpan(text: 'Bold ', style: TextStyle(fontWeight: FontWeight.bold)),
  ///         TextSpan(text: 'and normal'),
  ///       ]),
  ///     ),
  ///   ),
  /// )
  /// ```
  const InfoPage.rich({
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
              if (image != null) ...[
                SvgPicture.asset(image!),
                const SizedBox(height: 40.0),
              ],
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildTextContent(
                      context,
                      content: title,
                      style: context.textStyles.titleHeavy,
                    ),
                    if (description != null) ...[
                      const SizedBox(height: 16.0),
                      _buildTextContent(
                        context,
                        content: description,
                        style: context.textStyles.bodyLarge,
                      ),
                    ],
                    if (actions != null) ...[
                      SizedBox(height: paddingBeforeActions),
                      ...actions!,
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextContent(
    BuildContext context, {
    required InfoPageContent? content,
    required TextStyle style,
  }) {
    return switch (content) {
      _TextContent() => Text(
          content.text,
          style: style,
          textAlign: TextAlign.center,
        ),
      _WidgetContent() => content.widget,
      null => const SizedBox(),
    };
  }
}
