import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';

/// A widget that displays contact information, including name, optional phone
/// number, and whether the contact is a preferred contact. If contact can be
/// called (phone number is provided and device is able to call), the call
/// button will be shown.
class ContactRow extends StatelessWidget {
  /// The name of the contact.
  final String name;

  /// The phone number of the contact, or null if no phone number is available.
  final String? phoneNumber;

  /// Whether this contact is a preferred contact.
  final bool isPreferred;

  /// A [Future] that resolves to true if the contact can be called, or false
  /// otherwise.
  final Future<bool> _canCall;

  /// Creates a [ContactRow] widget.
  ContactRow({
    super.key,
    required this.name,
    required this.phoneNumber,
    this.isPreferred = false,
  }) : _canCall = canLaunchUrl(Uri.parse("tel:$phoneNumber"));

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: ZOColors.cardBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: WidgetStyle.padding,
          vertical: WidgetStyle.paddingSmall,
        ),
        child: Row(
          children: [
            Expanded(
              child: _rowContent(context),
            ),
            _actionContent(),
          ],
        ),
      ),
    );
  }

  Widget _rowContent(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isPreferred)
          Column(
            children: [
              Text(
                context.l10n!.contactsPreferredLabel,
                style: textTheme.labelMedium?.copyWith(
                  color: ZOColors.onPrimaryLight,
                ),
              ),
              const SizedBox(height: 4),
            ],
          ),
        Text(
          name,
          style: textTheme.titleMedium,
        ),
        const SizedBox(height: 4),
        if (phoneNumber != null)
          Text(
            phoneNumber ?? "",
            style: textTheme.bodyMedium?.copyWith(
              color: ZOColors.onPrimaryLight,
            ),
          )
        else
          Text(
            context.l10n!.contactsNoPhoneLabel,
            style: textTheme.bodyMedium?.copyWith(
              color: ZOColors.outline,
            ),
          ),
      ],
    );
  }

  Widget _actionContent() {
    return FutureBuilder(
      future: _canCall,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (phoneNumber != null && snapshot.data == true) {
          return IconButton(
            icon: const Icon(Icons.call_outlined),
            color: Colors.black,
            style: IconButton.styleFrom(backgroundColor: ZOColors.secondary),
            onPressed: _dialUpNumber,
          );
        }

        return const SizedBox();
      },
    );
  }

  void _dialUpNumber() async {
    final uri = Uri.parse("tel:$phoneNumber");
    await launchUrl(uri);
  }
}
