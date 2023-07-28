import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/routes/app_router.gr.dart';
import 'package:zachranobed/services/auth_service.dart';
import 'package:zachranobed/services/helper_service.dart';
import 'package:zachranobed/shared/constants.dart';
import 'package:zachranobed/ui/widgets/menu_button.dart';
import 'package:zachranobed/ui/widgets/menu_item.dart';

@RoutePage()
class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

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
                context.l10n!.organization,
                [
                  MenuItem(leadingIcon: Icons.business, text: user.organization)
                ],
              ),
              _buildMenuSection(
                context.l10n!.donor,
                [
                  MenuItem(
                    leadingIcon: Icons.perm_contact_calendar_outlined,
                    text: user.establishmentName,
                  )
                ],
              ),
              _buildMenuSection(
                context.l10n!.recipient,
                [
                  MenuItem(
                    leadingIcon: Icons.perm_contact_calendar_outlined,
                    text: user.recipient,
                  ),
                  const SizedBox(height: 8.0),
                  MenuItem(
                    leadingIcon: Icons.phone_outlined,
                    text: context.l10n!.contactCarrier,
                    onPressed: () async =>
                        await HelperService.makePhoneCall('123456789'),
                  )
                ],
              ),
              _buildMenuSection(
                context.l10n!.saveLunch,
                [
                  MenuItem(
                    leadingIcon: Icons.textsms_outlined,
                    text: context.l10n!.feedback,
                  ),
                  const SizedBox(height: 8.0),
                  MenuItem(
                    leadingIcon: Icons.language,
                    text: context.l10n!.about,
                    onPressed: () async {
                      await _openUrlInBrowser(ZOStrings.zjUrl);
                    },
                  ),
                  const SizedBox(height: 8.0),
                  MenuItem(
                    leadingIcon: Icons.volunteer_activism_outlined,
                    text: context.l10n!.sponsors,
                    onPressed: () async {
                      await _openUrlInBrowser(ZOStrings.zjUrl);
                    },
                  ),
                ],
              ),
              _buildMenuSection(
                context.l10n!.more,
                [
                  MenuItem(
                    leadingIcon: Icons.star_border,
                    text: context.l10n!.rate,
                  ),
                  const SizedBox(height: 8.0),
                  MenuItem(
                    leadingIcon: Icons.security,
                    text: context.l10n!.privacyProtection,
                    onPressed: () async =>
                        await _openUrlInBrowser(ZOStrings.zjUrl),
                  ),
                  const SizedBox(height: 8.0),
                  MenuItem(
                    leadingIcon: Icons.text_snippet_outlined,
                    text: context.l10n!.termsOfUse,
                    onPressed: () async =>
                        await _openUrlInBrowser(ZOStrings.zjUrl),
                  ),
                ],
              ),
              MenuButton(
                text: context.l10n!.signOut,
                icon: Icons.logout,
                onPressed: () async {
                  await authService.signOut();
                  if (context.mounted) {
                    context.router.replace(const LoginRoute());
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
