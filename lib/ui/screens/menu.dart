import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zachranobed/routes.dart';
import 'package:zachranobed/services/helper_service.dart';
import 'package:zachranobed/shared/constants.dart';
import 'package:zachranobed/ui/widgets/menu_button.dart';
import 'package:zachranobed/ui/widgets/menu_item.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    final user = HelperService.getCurrentUser(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(HelperService.getCurrentUser(context)!.email),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: [
              _buildMenuSection(
                ZachranObedStrings.organization,
                [
                  MenuItem(leadingIcon: Icons.business, text: user.organization)
                ],
              ),
              _buildMenuSection(
                ZachranObedStrings.donor,
                [
                  MenuItem(
                    leadingIcon: Icons.perm_contact_calendar_outlined,
                    text: user.establishmentName,
                  )
                ],
              ),
              _buildMenuSection(
                ZachranObedStrings.recipient,
                [
                  MenuItem(
                    leadingIcon: Icons.perm_contact_calendar_outlined,
                    text: user.recipient,
                  ),
                  const SizedBox(height: 8.0),
                  const MenuItem(
                    leadingIcon: Icons.phone_outlined,
                    text: ZachranObedStrings.contactCarrier,
                  )
                ],
              ),
              _buildMenuSection(
                ZachranObedStrings.saveLunch,
                [
                  const MenuItem(
                    leadingIcon: Icons.textsms_outlined,
                    text: ZachranObedStrings.feedback,
                  ),
                  const SizedBox(height: 8.0),
                  const MenuItem(
                    leadingIcon: Icons.language,
                    text: ZachranObedStrings.about,
                  ),
                  const SizedBox(height: 8.0),
                  const MenuItem(
                    leadingIcon: Icons.volunteer_activism_outlined,
                    text: ZachranObedStrings.sponsors,
                  ),
                ],
              ),
              _buildMenuSection(
                ZachranObedStrings.more,
                [
                  const MenuItem(
                    leadingIcon: Icons.star_border,
                    text: ZachranObedStrings.rate,
                  ),
                  const SizedBox(height: 8.0),
                  const MenuItem(
                    leadingIcon: Icons.security,
                    text: ZachranObedStrings.privacyProtection,
                  ),
                  const SizedBox(height: 8.0),
                  const MenuItem(
                    leadingIcon: Icons.text_snippet_outlined,
                    text: ZachranObedStrings.termsOfUse,
                  ),
                ],
              ),
              MenuButton(
                text: ZachranObedStrings.logout,
                icon: Icons.logout,
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  prefs.clear();

                  if (context.mounted) {
                    Navigator.of(context)
                        .pushReplacementNamed(RouteManager.login);
                  }
                },
              ),
              const SizedBox(height: 48.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuSection(String label, List<Widget> menuItems) {
    return Column(
      children: [
        Row(children: [Text(label, style: const TextStyle(fontSize: 16.0))]),
        for (var item in menuItems) item,
        const SizedBox(height: 24.0),
      ],
    );
  }
}
