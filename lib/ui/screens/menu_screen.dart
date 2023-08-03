import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/models/donor.dart';
import 'package:zachranobed/routes/app_router.gr.dart';
import 'package:zachranobed/services/auth_service.dart';
import 'package:zachranobed/services/helper_service.dart';
import 'package:zachranobed/shared/constants.dart';
import 'package:zachranobed/ui/widgets/menu/menu_button.dart';
import 'package:zachranobed/ui/widgets/menu/menu_item.dart';
import 'package:zachranobed/ui/widgets/menu/menu_section.dart';

@RoutePage()
class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = HelperService.getCurrentUser(context)!;
    final authService = GetIt.I<AuthService>();

    // TODO - zobrazovatúdaje jinak v případě příjemce a v případě dárce
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
              MenuSection(
                label: context.l10n!.organization,
                menuItems: [
                  MenuItem(leadingIcon: Icons.business, text: user.organization)
                ],
              ),
              MenuSection(
                label: context.l10n!.donor,
                menuItems: [
                  MenuItem(
                    leadingIcon: Icons.perm_contact_calendar_outlined,
                    text: user.establishmentName,
                  )
                ],
              ),
              MenuSection(
                label: context.l10n!.recipient,
                menuItems: [
                  MenuItem(
                    leadingIcon: Icons.perm_contact_calendar_outlined,
                    text:
                        user is Donor ? user.recipient : user.donor.toString(),
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
              MenuSection(
                label: context.l10n!.saveLunch,
                menuItems: [
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
              MenuSection(
                label: context.l10n!.more,
                menuItems: [
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

  Future<void> _openUrlInBrowser(String siteUrl) async {
    final Uri url = Uri.parse(siteUrl);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}
