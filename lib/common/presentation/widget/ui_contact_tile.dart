import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_fill_icon_button.dart';
import 'package:zachranobed/common/presentation/widget/ui_card.dart';

/// A contact tile widget that displays contact information with optional call functionality.
class UiContactTile extends StatelessWidget {
  /// The name and position of the contact (title).
  final String name;

  /// The phone number of the contact.
  final String phoneNumber;

  /// Whether this is a preferred contact.
  final bool isPreferred;

  /// Whether to show the call button. Default is true.
  final bool showCallButton;

  /// A [Future] that resolves to true if the contact can be called, or false otherwise.
  final Future<bool> _canCall;

  /// Creates a [UiContactTile] widget.
  UiContactTile({
    super.key,
    required this.name,
    required this.phoneNumber,
    this.isPreferred = false,
    this.showCallButton = true,
  }) : _canCall = canLaunchUrl(Uri.parse("tel:$phoneNumber"));

  @override
  Widget build(BuildContext context) {
    return UiCard(
      borderRadius: 8.0,
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 12.0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 16.0,
        children: [
          Expanded(
            child: _buildContent(context),
          ),
          _buildCallButton(context),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4.0,
      children: [
        if (isPreferred)
          Text(
            context.l10n.contactsPreferredLabel,
            style: context.textStyles.labelMedium.copyWith(
              color: context.uiColors.textSecondary,
            ),
          ),
        Text(
          name,
          style: context.textStyles.titleMedium.copyWith(
            color: context.uiColors.textPrimary,
          ),
        ),
        Text(
          phoneNumber,
          style: context.textStyles.bodyMedium.copyWith(
            color: context.uiColors.textSecondary,
          ),
        )
      ],
    );
  }

  Widget _buildCallButton(BuildContext context) {
    if (!showCallButton) {
      return SizedBox();
    }

    return FutureBuilder<bool>(
      future: _canCall,
      builder: (context, snapshot) {
        if (snapshot.data == true) {
          return UiIconFillButton(
            icon: Icons.call,
            onPressed: _dialUpNumber,
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  void _dialUpNumber() async {
    final uri = Uri.parse("tel:$phoneNumber");
    await launchUrl(uri);
  }
}
