import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zachranobed/common/presentation/deeplink/app_deeplink_handler.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/widget/layout/screen_scaffold.dart';
import 'package:zachranobed/common/presentation/widget/markdown/ui_markdown_style.dart';
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
          styleSheet: uiMarkdownStyleSheet(context, context.textStyles.bodyLarge),
          onTapLink: (text, href, title) {
            if (href != null) {
              _handleLink(context, href);
            }
          },
        );
      },
    );
  }

  void _handleLink(BuildContext context, String url) {
    if (AppDeeplinkHandler.handle(context, url)) {
      return;
    }
    final uri = Uri.tryParse(url);
    if (uri == null) {
      return;
    }
    launchUrl(uri);
  }
}
