import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zachranobed/common/domain/usecase/check_if_devtools_are_enabled_usecase.dart';
import 'package:zachranobed/common/domain/usecase/get_app_version_usecase.dart';
import 'package:zachranobed/common/domain/usecase/sign_out_usecase.dart';
import 'package:zachranobed/common/domain/utils/constants.dart';
import 'package:zachranobed/common/presentation/router/app_router.gr.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/utils/helper_service.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_button_size.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_outline_button.dart';
import 'package:zachranobed/common/presentation/widget/card/ui_list_tile.dart';
import 'package:zachranobed/common/presentation/widget/graphics/ui_gradient_icon.dart';
import 'package:zachranobed/common/presentation/widget/graphics/ui_icon.dart';
import 'package:zachranobed/common/presentation/widget/layout/adaptive_content.dart';
import 'package:zachranobed/common/presentation/widget/layout/screen_scaffold.dart';
import 'package:zachranobed/common/presentation/widget/layout/sectioned_list_view.dart';
import 'package:zachranobed/common/presentation/widget/navigation/ui_app_bar.dart';

/// A screen that displays the user's profile and app settings.
///
/// This screen presents various menu options organized into sections:
/// - **User info**: Displays establishment name and email
/// - **All contacts**: Quick access to contacts screen
/// - **Settings**: Password change option
/// - **Save Lunch**: Feedback and project information links
/// - **More**: Privacy policy, terms of use, and app version
/// - **Logout**: Sign out button at the bottom
///
/// Menu items with external links open in the system browser.
/// The app version is fetched on initialization and displayed at the bottom.
@RoutePage()
class ProfileScreen extends StatefulWidget {
  /// Creates a [ProfileScreen].
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _checkIfDevtoolsAreEnabledUseCase = GetIt.I<CheckIfDevtoolsAreEnabledUseCase>();
  final _getAppVersion = GetIt.I<GetAppVersionUseCase>();
  String _appVersion = '-';

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold.universalBuilder(
      appBar: UiAppBar(
        title: context.l10n.profileScreenTitle,
      ),
      builder: (context) {
        final user = HelperService.watchCurrentUser(context);
        if (user == null) {
          return const SizedBox.shrink();
        }

        return SectionedListView(
          entries: [
            // User info and contacts section (no header)
            SectionedListItem(
              UiListTile(
                title: user.establishmentName,
                supportingText: user.email,
              ),
            ),
            SectionedListItem(
              _buildListItem(
                context,
                icon: const UiIconSpec.data(Icons.call_outlined),
                title: context.l10n.contactsMenuLabel,
                onPressed: () => context.router.push(const ContactsRoute()),
              ),
            ),

            // Settings section
            SectionedListHeader(context.l10n.settings),
            SectionedListItem(
              _buildListItem(
                context,
                icon: const UiIconSpec.data(Icons.password),
                title: context.l10n.changePassword,
                onPressed: () => context.router.push(const ChangePasswordRoute()),
              ),
            ),

            // Organization section
            SectionedListHeader(context.l10n.saveLunch),
            SectionedListItem(
              _buildListItem(
                context,
                icon: const UiIconSpec.data(Icons.textsms_outlined),
                title: context.l10n.feedback,
                onPressed: () => _openEmailClient(context),
              ),
            ),
            SectionedListItem(
              _buildListItem(
                context,
                icon: const UiIconSpec.data(Icons.language),
                title: context.l10n.about,
                onPressed: () => _openUrlInBrowser(Constants.urlHomepage),
              ),
            ),

            // More section
            SectionedListHeader(context.l10n.more),
            SectionedListItem(
              _buildListItem(
                context,
                icon: const UiIconSpec.data(Icons.security),
                title: context.l10n.privacyProtection,
                onPressed: () => _openUrlInBrowser(Constants.urlAppPrivacy),
              ),
            ),
            SectionedListItem(
              _buildListItem(
                context,
                icon: const UiIconSpec.data(Icons.text_snippet_outlined),
                title: context.l10n.termsOfUse,
                onPressed: () => _openUrlInBrowser(Constants.urlAppTerms),
              ),
            ),
            SectionedListItem(
              UiListTile(
                title: context.l10n.version,
                end: Text(
                  _appVersion,
                  style: context.textStyles.labelLarge.copyWith(
                    color: context.uiColors.textPrimary,
                  ),
                ),
                onPressed: _showDebugScreenIfPossible,
              ),
            ),
            SectionedListItem(
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: UiOutlineButton(
                    size: UiButtonSize.medium(
                      fullWidth: context.watch<AdaptiveLayoutConfig>().isMobile,
                    ),
                    text: context.l10n.signOut,
                    icon: Icons.logout,
                    onPressed: _handleSignOut,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Loads and sets the app version from device info.
  Future<void> _initPackageInfo() async {
    final version = await _getAppVersion.invoke();
    setState(() {
      _appVersion = version;
    });
  }

  /// Builds a list item with an icon, title, gradient chevron, and onPressed callback.
  Widget _buildListItem(
    BuildContext context, {
    required UiIconSpec icon,
    required String title,
    required VoidCallback onPressed,
  }) {
    return UiListTile(
      title: title,
      start: UiIcon(spec: icon),
      end: UiGradientIcon(
        gradient: context.uiColors.primaryGradient,
        spec: const UiIconSpec.data(Icons.chevron_right),
      ),
      onPressed: onPressed,
    );
  }

  /// Opens the system email client with pre-filled feedback email.
  Future<void> _openEmailClient(BuildContext context) async {
    final email = Uri.encodeComponent(Constants.emailFeedback);
    final subject = Uri.encodeComponent(context.l10n.feedbackSubject);
    final mail = Uri.parse('mailto:$email?subject=$subject');
    await launchUrl(mail);
  }

  /// Opens a URL in the system browser.
  Future<void> _openUrlInBrowser(String siteUrl) async {
    final url = Uri.parse(siteUrl);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  /// Signs out the current user and navigates to login screen.
  Future<void> _handleSignOut() async {
    final entityId = HelperService.getCurrentUser(context)?.entityId;
    await GetIt.I<SignOutUseCase>().invoke(entityId);
  }

  /// Shows debug screen if devtools are enabled.
  void _showDebugScreenIfPossible() {
    final areDevtoolsEnabled = _checkIfDevtoolsAreEnabledUseCase.invoke();
    if (areDevtoolsEnabled) {
      context.router.push(const DebugRoute());
    }
  }
}
