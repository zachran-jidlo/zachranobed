import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';

/// Shared markdown style for the app, used with `Markdown` / `MarkdownBody`.
///
/// Headings, links, blockquotes, and horizontal rules use a common style.
/// [baseTextStyle] drives the body text (paragraphs, list bullets, bold, and
/// italic), so callers can size the content to their context.
MarkdownStyleSheet uiMarkdownStyleSheet(BuildContext context, TextStyle baseTextStyle) {
  return MarkdownStyleSheet(
    h1: context.textStyles.headlineLarge,
    h2: context.textStyles.titleLarge,
    h3: context.textStyles.titleMedium,
    p: baseTextStyle,
    listBullet: baseTextStyle,
    strong: baseTextStyle.copyWith(fontWeight: FontWeight.w700),
    em: baseTextStyle.copyWith(fontStyle: FontStyle.italic),
    a: TextStyle(
      color: context.uiColors.primary,
      decoration: TextDecoration.underline,
      decorationColor: context.uiColors.primary,
    ),
    blockquoteDecoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8.0),
      border: Border.all(color: context.uiColors.primary, width: 2.0),
    ),
    horizontalRuleDecoration: BoxDecoration(
      border: Border(
        top: BorderSide(
          width: 2.0,
          color: context.uiColors.surfaceGrayDark,
        ),
      ),
    ),
  );
}
