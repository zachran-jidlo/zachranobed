import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
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

/// TODO: Replace mocked values with real data
class _ContactsScreenState extends State<ContactsScreen> {
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
              MenuSection(
                label: "Jídelna U Ospalé pandy",
                menuItems: [
                  ContactRow(
                    isPreferred: true,
                    name: "Hana Novotná - kuchařka",
                    phoneNumber: "+420 XXX XXX XXX",
                  ),
                  const SizedBox(height: 8.0),
                  ContactRow(
                    name: "Jan Novák - vedoucí provozu",
                    phoneNumber: "+420 XXX XXX XXX",
                  ),
                ],
              ),
              MenuSection(
                label: "Jídelna U Smějící se kočky",
                menuItems: [
                  ContactRow(
                    isPreferred: true,
                    name: "Hana Novotná - kuchařka",
                    phoneNumber: "+420 XXX XXX XXX",
                  ),
                  const SizedBox(height: 8.0),
                  ContactRow(
                    name: "Jan Novák - vedoucí provozu",
                    phoneNumber: "+420 XXX XXX XXX",
                  ),
                ],
              ),
              MenuSection(
                label: "Dopravce",
                menuItems: [
                  ContactRow(
                    name: "Dodo - dispečink",
                    phoneNumber: "+420 XXX XXX XXX",
                  ),
                ],
              ),
              MenuSection(
                label: "Zachraň jídlo",
                menuItems: [
                  ContactRow(
                    name: "Denisa Rybářová - koordinátorka",
                    phoneNumber: "+420 XXX XXX XXX",
                  ),
                  const SizedBox(height: 8.0),
                  ContactRow(
                    name: "Marek Vimr - asistent koordinátora",
                    phoneNumber: "+420 XXX XXX XXX",
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
