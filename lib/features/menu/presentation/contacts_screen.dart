import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/common/helper_service.dart';
import 'package:zachranobed/common/utils/iterable_utils.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/features/menu/domain/model/contact.dart';
import 'package:zachranobed/features/menu/domain/model/contacts_summary.dart';
import 'package:zachranobed/features/menu/domain/usecase/get_contacts_use_case.dart';
import 'package:zachranobed/ui/widgets/contact_row.dart';
import 'package:zachranobed/ui/widgets/error_content.dart';
import 'package:zachranobed/ui/widgets/menu/menu_section.dart';

/// A screen that displays a list of contacts.
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
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: _contactsFuture,
        builder:
            (BuildContext context, AsyncSnapshot<ContactsSummary> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _loading();
          } else if (snapshot.hasError || snapshot.data == null) {
            return _error(context);
          }
          return _contacts(snapshot.data!);
        },
      ),
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

  /// Builds the screen content, optionally wrapping it in a
  /// [SingleChildScrollView]. The [child] parameter represents the main
  /// content of the screen.
  Widget _screen({
    bool scrollable = true,
    required Widget child,
  }) {
    final content = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: WidgetStyle.padding,
      ),
      child: Column(
        children: [
          Row(
            children: <Widget>[
              Text(
                context.l10n!.contactsTitle,
                style: const TextStyle(fontSize: FontSize.l),
              ),
            ],
          ),
          const SizedBox(height: GapSize.s),
          child,
        ],
      ),
    );

    if (scrollable) {
      return SingleChildScrollView(child: content);
    } else {
      return content;
    }
  }

  /// Builds the contacts content for the given [summary].
  Widget _contacts(ContactsSummary summary) {
    return _screen(
      child: Column(
        children: [
          ...summary.targets.map((e) {
            return _menuSection(
              label: e.name,
              contacts: e.contacts,
              markFirstAsPreferred: e.contacts.length > 1,
            );
          }),
          _menuSection(
            label: context.l10n!.contactsDeliveryHeader,
            contacts: summary.deliveryContacts,
          ),
          _menuSection(
            label: context.l10n!.contactsOrganisationHeader,
            contacts: summary.organisationContacts,
          ),
        ],
      ),
    );
  }

  /// Builds a section within contacts menu.
  Widget _menuSection({
    required String label,
    required List<Contact> contacts,
    bool markFirstAsPreferred = false,
  }) {
    if (contacts.isEmpty) {
      return const SizedBox();
    }
    return MenuSection(
      label: label,
      menuItems: contacts
          .mapIndexed((index, e) {
            final contactName =
                e.position != null ? "${e.name} - ${e.position}" : e.name;

            return ContactRow(
              isPreferred: markFirstAsPreferred && index == 0,
              name: contactName,
              phoneNumber: e.phoneNumber,
            );
          })
          .separated(const SizedBox(height: 8.0))
          .toList(),
    );
  }

  /// Builds a loading screen.
  Widget _loading() {
    return _screen(
      scrollable: false,
      child: const Expanded(child: Center(child: CircularProgressIndicator())),
    );
  }

  /// Builds a generic error screen.
  Widget _error(BuildContext context) {
    return _screen(
      child: Column(
        children: [
          ErrorContent(
            onRetryPressed: _loadContacts,
          ),
          const SizedBox(height: GapSize.xs),
        ],
      ),
    );
  }
}
