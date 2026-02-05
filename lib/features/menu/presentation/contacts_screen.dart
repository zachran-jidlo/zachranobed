import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:zachranobed/common/domain/model/user_data.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/utils/helper_service.dart';
import 'package:zachranobed/common/presentation/widget/page/error_page.dart';
import 'package:zachranobed/common/presentation/widget/page/loading_page.dart';
import 'package:zachranobed/common/presentation/widget/screen_scaffold.dart';
import 'package:zachranobed/common/presentation/widget/sectioned_list_view.dart';
import 'package:zachranobed/common/presentation/widget/ui_app_bar.dart';
import 'package:zachranobed/common/presentation/widget/ui_contact_tile.dart';
import 'package:zachranobed/features/menu/domain/model/contacts_summary.dart';
import 'package:zachranobed/features/menu/domain/model/entity_contacts.dart';
import 'package:zachranobed/features/menu/domain/usecase/get_contacts_use_case.dart';

/// A screen that displays a comprehensive list of contacts organized by category.
///
/// This screen presents contacts in organized sections:
/// - **Target entities**: Selected pair entity with their staff contacts
///   - For charities: Shows active pairs with a suffix
///   - First contact in each section marked as preferred when multiple contacts exist
/// - **Delivery contacts**: Courier/delivery service contacts
/// - **Organisation contacts**: Zachraň jídlo staff contacts
///
/// Features:
/// - Sectioned list view with clear category headers
/// - Contact tiles showing name, position, and phone number
/// - One-tap calling via phone buttons with gradient styling
/// - Preferred contact indication for primary contacts
/// - Loading state during data fetch
/// - Error handling with retry functionality
/// - Responsive layout using SectionedListView
@RoutePage()
class ContactsScreen extends StatefulWidget {
  /// Creates a [ContactsScreen].
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  late Future<ContactsSummary> _contactsFuture;

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold.universalBuilder(
      appBar: UiAppBar(
        title: context.l10n.contactsTitle,
      ),
      builder: (context) {
        return FutureBuilder<ContactsSummary>(
          future: _contactsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingPage();
            }
            if (snapshot.hasError || snapshot.data == null) {
              return ErrorPage(onRetryPressed: _loadContacts);
            }
            return _contacts(snapshot.data!);
          },
        );
      },
    );
  }

  /// Loads contacts summary.
  void _loadContacts() {
    final getContacts = GetIt.I<GetContactsUseCase>();
    setState(() {
      final user = HelperService.getCurrentUser(context)!;
      _contactsFuture = getContacts.invoke(user);
    });
  }

  /// Builds the contacts content for the given [summary].
  Widget _contacts(ContactsSummary summary) {
    final entries = <SectionedListEntry<Widget>>[];

    // Add target entity sections
    final isMultiPair = summary.targets.length > 1;
    for (final target in summary.targets) {
      if (target.contacts.isNotEmpty) {
        final labelSuffix = _resolveLabelSuffix(target, isMultiPair);
        final headerText = labelSuffix.isEmpty ? target.name : "${target.name} $labelSuffix";
        entries.add(SectionedListHeader(headerText));

        for (var i = 0; i < target.contacts.length; i++) {
          final contact = target.contacts[i];
          entries.add(
            SectionedListItem(
              UiContactTile(
                name: contact.formattedName,
                phoneNumber: contact.phoneNumber ?? context.l10n.contactsNoPhoneLabel,
                isPreferred: target.contacts.length > 1 && i == 0,
                showCallButton: contact.phoneNumber != null,
              ),
            ),
          );
        }
      }
    }

    // Add delivery contacts section
    if (summary.deliveryContacts.isNotEmpty) {
      entries.add(SectionedListHeader(context.l10n.contactsDeliveryHeader));
      for (final contact in summary.deliveryContacts) {
        entries.add(
          SectionedListItem(
            UiContactTile(
              name: contact.formattedName,
              phoneNumber: contact.phoneNumber ?? context.l10n.contactsNoPhoneLabel,
              showCallButton: contact.phoneNumber != null,
            ),
          ),
        );
      }
    }

    // Add organisation contacts section
    if (summary.organisationContacts.isNotEmpty) {
      entries.add(SectionedListHeader(context.l10n.contactsOrganisationHeader));
      for (final contact in summary.organisationContacts) {
        entries.add(
          SectionedListItem(
            UiContactTile(
              name: contact.formattedName,
              phoneNumber: contact.phoneNumber ?? context.l10n.contactsNoPhoneLabel,
              showCallButton: contact.phoneNumber != null,
            ),
          ),
        );
      }
    }

    return SectionedListView(entries: entries);
  }

  String _resolveLabelSuffix(EntityContacts contacts, bool isMultiPair) {
    // Show label only for multi-pair entities and active pairs
    if (!isMultiPair || !contacts.active) {
      return "";
    }

    final user = HelperService.getCurrentUser(context)!;
    return switch (user) {
      Charity() => context.l10n.activePairContactsCanteenLabel,
      Canteen() => context.l10n.activePairContactsCharityLabel,
    };
  }
}
