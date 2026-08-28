import 'package:flutter/material.dart' hide Banner;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zachranobed/common/presentation/deeplink/app_deeplink_handler.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_button_size.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_icon_button.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_text_button.dart';
import 'package:zachranobed/common/presentation/widget/card/ui_notification_tile.dart';
import 'package:zachranobed/common/presentation/widget/markdown/ui_markdown_style.dart';
import 'package:zachranobed/features/banners/domain/model/banner.dart';

/// Renders a single dynamic banner. Closable banners show an X, and banners
/// with an action show a button that opens a deeplink or external URL.
class BannerTile extends StatelessWidget {
  final Banner banner;

  /// Called when the user closes a closable banner.
  final VoidCallback onDismiss;

  const BannerTile({
    super.key,
    required this.banner,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return UiNotificationTile(
      title: banner.title,
      titleMaxLines: null,
      descriptionWidget: _buildMessage(context),
      icon: _icon(),
      trailing: _buildTrailing(),
      actions: _buildActions(context),
    );
  }

  /// Renders the message as markdown, matching FAQ answers. Returns null when
  /// there is no text.
  Widget? _buildMessage(BuildContext context) {
    if (banner.text.isEmpty) {
      return null;
    }

    return MarkdownBody(
      data: banner.text,
      styleSheet: uiMarkdownStyleSheet(
        context,
        context.textStyles.bodyMedium.copyWith(
          color: context.uiColors.textPrimary,
        ),
      ),
      onTapLink: (text, href, title) {
        if (href != null) {
          _handleLink(context, href);
        }
      },
    );
  }

  Widget? _buildTrailing() {
    if (!banner.closable) {
      return null;
    }

    return UiIconButton.solid(
      icon: Icons.close,
      onPressed: onDismiss,
    );
  }

  IconData? _icon() {
    return switch (banner.type) {
      BannerType.warning => Icons.warning_rounded,
      BannerType.info => Icons.info_outline,
      null => null,
    };
  }

  List<Widget>? _buildActions(BuildContext context) {
    final label = banner.actionLabel;
    final url = banner.actionUrl;
    if (label == null || label.isEmpty || url == null || url.isEmpty) {
      return null;
    }

    return [
      Align(
        alignment: Alignment.centerRight,
        child: UiTextButton(
          text: label,
          size: UiButtonSize.tiny(),
          onPressed: () => _handleLink(context, url),
        ),
      ),
    ];
  }

  void _handleLink(BuildContext context, String url) {
    if (AppDeeplinkHandler.handle(context, url)) {
      return;
    }
    final uri = Uri.tryParse(url);
    if (uri != null) {
      launchUrl(uri);
    }
  }
}
