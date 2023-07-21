import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zachranobed/routes.dart';
import 'package:zachranobed/services/auth_service.dart';
import 'package:zachranobed/services/helper_service.dart';
import 'package:zachranobed/shared/constants.dart';
import 'package:zachranobed/ui/widgets/menu_button.dart';
import 'package:zachranobed/ui/widgets/menu_item.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    final user = HelperService.getCurrentUser(context)!;
    final authService = GetIt.I<AuthService>();

    return Scaffold(
      appBar: AppBar(
        title: Text(HelperService.getCurrentUser(context)!.email),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: WidgetStyle.padding,
          ),
          child: Column(
            children: [
              _buildMenuSection(
                ZOStrings.organization,
                [
                  MenuItem(leadingIcon: Icons.business, text: user.organization)
                ],
              ),
              _buildMenuSection(
                ZOStrings.donor,
                [
                  MenuItem(
                    leadingIcon: Icons.perm_contact_calendar_outlined,
                    text: user.establishmentName,
                  )
                ],
              ),
              _buildMenuSection(
                ZOStrings.recipient,
                [
                  MenuItem(
                    leadingIcon: Icons.perm_contact_calendar_outlined,
                    text: user.recipient,
                  ),
                  const SizedBox(height: 8.0),
                  MenuItem(
                    leadingIcon: Icons.phone_outlined,
                    text: ZOStrings.contactCarrier,
                    onPressed: () async =>
                        await HelperService.makePhoneCall('123456789'),
                  )
                ],
              ),
              _buildMenuSection(
                ZOStrings.saveLunch,
                [
                  const MenuItem(
                    leadingIcon: Icons.textsms_outlined,
                    text: ZOStrings.feedback,
                  ),
                  const SizedBox(height: 8.0),
                  MenuItem(
                    leadingIcon: Icons.language,
                    text: ZOStrings.about,
                    onPressed: () async {
                      await _openUrlInBrowser(ZOStrings.zjUrl);
                    },
                  ),
                  const SizedBox(height: 8.0),
                  MenuItem(
                    leadingIcon: Icons.volunteer_activism_outlined,
                    text: ZOStrings.sponsors,
                    onPressed: () async {
                      await _openUrlInBrowser(ZOStrings.zjUrl);
                    },
                  ),
                ],
              ),
              _buildMenuSection(
                ZOStrings.more,
                [
                  const MenuItem(
                    leadingIcon: Icons.star_border,
                    text: ZOStrings.rate,
                  ),
                  const SizedBox(height: 8.0),
                  MenuItem(
                    leadingIcon: Icons.security,
                    text: ZOStrings.privacyProtection,
                    onPressed: () async =>
                        await _openUrlInBrowser(ZOStrings.zjUrl),
                  ),
                  const SizedBox(height: 8.0),
                  MenuItem(
                    leadingIcon: Icons.text_snippet_outlined,
                    text: ZOStrings.termsOfUse,
                    onPressed: () async =>
                        await _openUrlInBrowser(ZOStrings.zjUrl),
                  ),
                ],
              ),
              MenuButton(
                text: ZOStrings.logout,
                icon: Icons.logout,
                onPressed: () async {
                  await authService.signOut();
                  if (context.mounted) {
                    Navigator.of(context)
                        .pushReplacementNamed(RouteManager.login);
                  }
                },
              ),
              const SizedBox(height: GapSize.xl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuSection(String label, List<Widget> menuItems) {
    return Column(
      children: [
        Row(
          children: [Text(label, style: const TextStyle(fontSize: FontSize.s))],
        ),
        for (var item in menuItems) item,
        const SizedBox(height: GapSize.s),
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
