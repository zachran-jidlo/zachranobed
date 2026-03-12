import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zachranobed/common/presentation/deeplink/app_deeplink_handler.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/widget/layout/screen_scaffold.dart';
import 'package:zachranobed/common/presentation/widget/navigation/ui_app_bar.dart';
import 'package:zachranobed/features/faq/domain/model/faq_item.dart';

/// Screen that displays the full answer for a FAQ question.
@RoutePage()
class FaqDetailScreen extends StatelessWidget {
  final FaqItem item;

  const FaqDetailScreen({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold.universalBuilder(
      appBar: UiAppBar(
        title: context.l10n.faqTitle,
      ),
      builder: (context) {
        return Markdown(
          data: '## ${item.question}\n\n${item.answer}',
          padding: const EdgeInsets.all(16),
          styleSheet: _buildStyleSheet(context),
          onTapLink: (text, href, title) {
            if (href != null) {
              _handleLink(context, href);
            }
          },
        );
      },
    );
  }

  MarkdownStyleSheet _buildStyleSheet(BuildContext context) {
    return MarkdownStyleSheet(
      h1: context.textStyles.headlineLarge,
      h2: context.textStyles.titleLarge,
      h3: context.textStyles.titleMedium,
      p: context.textStyles.bodyLarge,
      listBullet: context.textStyles.bodyLarge,
      strong: context.textStyles.bodyLarge.copyWith(fontWeight: FontWeight.w700),
      em: context.textStyles.bodyLarge.copyWith(fontStyle: FontStyle.italic),
      a: TextStyle(
        color: context.uiColors.primary,
        decoration: TextDecoration.underline,
        decorationColor: context.uiColors.primary,
      ),
      blockquoteDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color:context.uiColors.primary, width: 2.0),
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

  void _handleLink(BuildContext context, String url) {
    if (!AppDeeplinkHandler.handle(context, url)) {
      launchUrl(Uri.parse(url));
    }
  }
}
