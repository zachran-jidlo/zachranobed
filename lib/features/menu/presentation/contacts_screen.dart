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

    final entityId = HelperService.getCurrentUser(context)!.entityId;
    final getContacts = GetIt.I<GetContactsUseCase>();
    _contactsFuture = getContacts.invoke(entityId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
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
              _screenContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _screenContent() {
    return FutureBuilder(
      future: _contactsFuture,
      builder: (BuildContext context, AsyncSnapshot<ContactsSummary> snapshot) {
        // TODO (ZOB-226) Implement correct loading & error UI
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        } else if (snapshot.hasError || snapshot.data == null) {
          return const Text("Error");
        }
        return _contacts(snapshot.data!);
      },
    );
  }

  Widget _contacts(ContactsSummary summary) {
    return Column(
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
    );
  }

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
            return ContactRow(
              isPreferred: markFirstAsPreferred && index == 0,
              name: e.name,
              phoneNumber: e.phoneNumber,
            );
          })
          .separated(const SizedBox(height: 8.0))
          .toList(),
    );
  }
}
