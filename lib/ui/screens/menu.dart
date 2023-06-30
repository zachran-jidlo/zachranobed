import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
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
          padding: const EdgeInsets.symmetric(
            horizontal: WidgetStyle.horizontalPadding,
          ),
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
                  MenuItem(
                    leadingIcon: Icons.phone_outlined,
                    text: ZachranObedStrings.contactCarrier,
                    onPressed: () async =>
                        await HelperService.makePhoneCall('123456789'),
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
                  MenuItem(
                    leadingIcon: Icons.language,
                    text: ZachranObedStrings.about,
                    onPressed: () async {
                      await _openUrlInBrowser(ZachranObedStrings.zjUrl);
                    },
                  ),
                  const SizedBox(height: 8.0),
                  MenuItem(
                    leadingIcon: Icons.volunteer_activism_outlined,
                    text: ZachranObedStrings.sponsors,
                    onPressed: () async {
                      await _openUrlInBrowser(ZachranObedStrings.zjUrl);
                    },
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
                  MenuItem(
                    leadingIcon: Icons.security,
                    text: ZachranObedStrings.privacyProtection,
                    onPressed: () async {
                      await _openUrlInBrowser(ZachranObedStrings.zjUrl);
                    },
                  ),
                  const SizedBox(height: 8.0),
                  MenuItem(
                    leadingIcon: Icons.text_snippet_outlined,
                    text: ZachranObedStrings.termsOfUse,
                    onPressed: () async {
                      await _openUrlInBrowser(ZachranObedStrings.zjUrl);
                    },
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

  Future<void> _openUrlInBrowser(String siteUrl) async {
    final Uri url = Uri.parse(siteUrl);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}
