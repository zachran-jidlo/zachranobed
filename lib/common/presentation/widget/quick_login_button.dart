import 'package:flutter/material.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_button_size.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_outline_button.dart';
import 'package:zachranobed/common/presentation/widget/sectioned_list_view.dart';
import 'package:zachranobed/common/presentation/widget/ui_list_tile.dart';

/// A list of available test users grouped by sections.
///
/// **Note: The users in this list are stripped out from the production build for security.**
const List<SectionedListEntry<_TestUser>> _users = [
  SectionedListHeader("Základní"),
  SectionedListItem(
    _TestUser(
      "test-zo-charita",
      "[charita]",
      "Test Charita",
      "zachranobed.charita.test@gmail.com",
      "ZOcharitaTest8359",
    ),
  ),
  SectionedListItem(
    _TestUser(
      "test-zo-jidelna",
      "[jídelna]",
      "Test Jídelna",
      "zachranobed.jidelna.test@gmail.com",
      "ZOjidelnaTest7296",
    ),
  ),
  SectionedListHeader("Bez historie"),
  SectionedListItem(
    _TestUser(
      "test-zo-charita-bezhistorie",
      "[charita]",
      "Test Charita",
      "zo.charita.test@gmail.com",
      "ZOcharitaTest8359",
    ),
  ),
  SectionedListItem(
    _TestUser(
      "test-zo-jidelna-bezhistorie",
      "[jídelna]",
      "Test Jídelna",
      "zo.test.jidelna@gmail.com",
      "ZOjidelnaTest7296",
    ),
  ),
  SectionedListHeader("Multi (1 charita, 3 jídelny)"),
  SectionedListItem(
    _TestUser(
      "test-zo-charita-multi",
      "[charita]",
      "Škola čar a kouzel v Bradavicích",
      "zo.charita.test.multi@gmail.com",
      "Bageta123",
    ),
  ),
  SectionedListItem(
    _TestUser(
      "test-zo-jidelna-multi-1",
      "[jídelna]",
      "Hostinec U Tří košťat",
      "zo.jidelna.test.multi.1@gmail.com",
      "Bageta123",
    ),
  ),
  SectionedListItem(
    _TestUser(
      "test-zo-jidelna-multi-2",
      "[jídelna]",
      "Hostinec U Prasečí hlavy",
      "zo.jidelna.test.multi.2@gmail.com",
      "Bageta123",
    ),
  ),
  SectionedListItem(
    _TestUser(
      "test-zo-jidelna-multi-3",
      "[jídelna]",
      "Kratochvilné kouzelnické kejkle",
      "zo.jidelna.test.multi.3@gmail.com",
      "Bageta123",
    ),
  ),
  SectionedListHeader("Multi (1 jídelna, 3 charity)"),
  SectionedListItem(
    _TestUser(
      "test-zo-jidelna-multi-westeros",
      "[jídelna]",
      "Kuchyně Rudé bašty",
      "zo.jidelna.test.multi.westeros@gmail.com",
      "Bageta123",
    ),
  ),
  SectionedListItem(
    _TestUser(
      "test-zo-charita-multi-westeros-1",
      "[charita]",
      "Chudobinec v Bleším zadku",
      "zo.charita.test.multi.westeros.1@gmail.com",
      "Bageta123",
    ),
  ),
  SectionedListItem(
    _TestUser(
      "test-zo-charita-multi-westeros-2",
      "[charita]",
      "Hostinec U Prasečí hlavy",
      "zo.charita.test.multi.westeros.2@gmail.com",
      "Bageta123",
    ),
  ),
  SectionedListItem(
    _TestUser(
      "test-zo-charita-multi-westeros-3",
      "[charita]",
      "Kratochvilné kouzelnické kejkle",
      "zo.charita.test.multi.westeros.3@gmail.com",
      "Bageta123",
    ),
  ),
];

/// A utility button designed for non-production environments to facilitate quick logins.
///
/// When pressed, this button opens a modal sheet displaying a list of pre-defined users. Selecting a user
/// automatically populates the provided [emailController] and [passwordController] with that user's credentials.
class QuickLoginButton extends StatelessWidget {
  /// The controller for the email input field that will be updated upon user selection.
  final TextEditingController emailController;

  /// The controller for the password input field that will be updated upon user selection.
  final TextEditingController passwordController;

  /// Creates a [QuickLoginButton].
  const QuickLoginButton({
    super.key,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return UiOutlineButton(
      size: UiButtonSize.medium(),
      text: context.l10n.testUsers,
      onPressed: () async {
        final user = await _showTestUsers(context);
        if (user == null) {
          return;
        }

        emailController.text = user.email;
        passwordController.text = user.password;
      },
    );
  }
}

/// A data model representing a test user's credentials and display info.
class _TestUser {
  final String id;
  final String label;
  final String name;
  final String email;
  final String password;

  const _TestUser(
    this.id,
    this.label,
    this.name,
    this.email,
    this.password,
  );
}

/// Displays a scrollable modal bottom sheet containing the list of [_users].
///
/// Returns the selected [_TestUser] object, or `null` if the sheet is closed without a selection.
Future<_TestUser?> _showTestUsers(BuildContext context) async {
  return await showModalBottomSheet<_TestUser?>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    constraints: const BoxConstraints.tightFor(width: 640.0),
    builder: (BuildContext context) {
      return DraggableScrollableSheet(
        initialChildSize: 1.0,
        minChildSize: 0.5,
        expand: false,
        snap: true,
        snapSizes: const [0.5, 1.0],
        builder: (_, controller) {
          return LayoutBuilder(
            builder: (context, constraints) {
              return SizedBox(
                width: constraints.maxWidth,
                child: SectionedListView<_TestUser>.builder(
                  entries: _users,
                  controller: controller,
                  itemBuilder: (context, user) {
                    return UiListTile(
                      overline: user.label,
                      title: user.name,
                      supportingText: user.id,
                      onPressed: () {
                        Navigator.pop(context, user);
                      },
                    );
                  },
                ),
              );
            },
          );
        },
      );
    },
  );
}
