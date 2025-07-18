import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/common/helper_service.dart';
import 'package:zachranobed/common/logger/zo_logger.dart';
import 'package:zachranobed/common/utils/device_utils.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/features/login/domain/check_if_devtools_are_enabled_usecase.dart';
import 'package:zachranobed/routes/app_router.gr.dart';
import 'package:zachranobed/services/auth_service.dart';
import 'package:zachranobed/ui/widgets/app_bar.dart';
import 'package:zachranobed/ui/widgets/button.dart';
import 'package:zachranobed/ui/widgets/menu/menu_button.dart';
import 'package:zachranobed/ui/widgets/menu/menu_item.dart';
import 'package:zachranobed/ui/widgets/menu/menu_section.dart';
import 'package:zachranobed/ui/widgets/menu/menu_user_info.dart';
import 'package:zachranobed/ui/widgets/screen_scaffold.dart';

@RoutePage()
class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final _checkIfDevtoolsAreEnabledUseCase = GetIt.I<CheckIfDevtoolsAreEnabledUseCase>();
  String _appVersion = '-';

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    var version = await DeviceUtils.getAppVersion();
    setState(() {
      ZOLogger.logMessage(version.toString());
      _appVersion = version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      appBar: ZOAppBar(
        title: context.l10n!.profileScreenTitle,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      web: (context) => _menuScreenContent(useWideButton: false),
      mobile: (context) => _menuScreenContent(useWideButton: true),
    );
  }

  /// Builds the content of the menu screen.
  ///
  /// The [useWideButton] parameter determines whether to stretch logout button
  /// to screen width.
  Widget _menuScreenContent({
    required bool useWideButton,
  }) {
    final authService = GetIt.I<AuthService>();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: WidgetStyle.padding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MenuUserInfo(user: HelperService.getCurrentUser(context)!),
            const SizedBox(height: 8.0),
            MenuItem(
              leadingIcon: Icons.call_outlined,
              text: context.l10n!.contactsMenuLabel,
              onPressed: () => context.router.push(const ContactsRoute()),
            ),
            const SizedBox(height: GapSize.m),
            MenuSection.simple(
              label: context.l10n!.settings,
              menuItems: [
                MenuItem(
                  leadingIcon: Icons.password,
                  text: context.l10n!.changePassword,
                  onPressed: () => context.router.push(const ChangePasswordRoute()),
                )
              ],
            ),
            MenuSection.simple(
              label: context.l10n!.saveLunch,
              menuItems: [
                MenuItem(
                  leadingIcon: Icons.textsms_outlined,
                  text: context.l10n!.feedback,
                  onPressed: () async {
                    await _openEmailClient(context);
                  },
                ),
                const SizedBox(height: 8.0),
                MenuItem(
                  leadingIcon: Icons.language,
                  text: context.l10n!.about,
                  onPressed: () async {
                    await _openUrlInBrowser(ZOStrings.zobWebHomepage);
                  },
                ),
                const SizedBox(height: 8.0),
                MenuItem(
                  leadingIcon: Icons.volunteer_activism_outlined,
                  text: context.l10n!.sponsors,
                  onPressed: () async {
                    await _openUrlInBrowser(ZOStrings.sponsors);
                  },
                ),
              ],
            ),
            MenuSection.simple(
              label: context.l10n!.more,
              menuItems: [
                MenuItem(
                  leadingIcon: Icons.security,
                  text: context.l10n!.privacyProtection,
                  onPressed: () async => await _openUrlInBrowser(ZOStrings.appPrivacy),
                ),
                const SizedBox(height: 8.0),
                MenuItem(
                  leadingIcon: Icons.text_snippet_outlined,
                  text: context.l10n!.termsOfUse,
                  onPressed: () async => await _openUrlInBrowser(ZOStrings.appTerms),
                ),
                const SizedBox(height: 8.0),
                MenuItem(
                  text: context.l10n!.version,
                  secondaryText: _appVersion,
                  onPressed: showDebugScreenIfPossible,
                ),
              ],
            ),
            MenuButton(
              text: context.l10n!.signOut,
              icon: Icons.logout,
              minimumSize: ZOButtonSize.large(fullWidth: useWideButton),
              onPressed: () async {
                final entityId = HelperService.getCurrentUser(context)?.entityId;
                await authService.signOut(entityId);
                if (mounted) {
                  context.router.replaceAll([const LoginRoute()]);
                }
              },
            ),
            const SizedBox(height: GapSize.xxl),
          ],
        ),
      ),
    );
  }

  Future<void> _openEmailClient(BuildContext context) async {
    final email = Uri.encodeComponent(ZOStrings.zjEmail);
    final subject = Uri.encodeComponent(context.l10n!.feedbackSubject);
    final mail = Uri.parse('mailto:$email?subject=$subject');
    await launchUrl(mail);
  }

  Future<void> _openUrlInBrowser(String siteUrl) async {
    final Uri url = Uri.parse(siteUrl);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  void showDebugScreenIfPossible() {
    bool areDevtoolsEnabled = _checkIfDevtoolsAreEnabledUseCase.invoke();
    if (areDevtoolsEnabled) context.router.push(const DebugRoute());
  }
}
