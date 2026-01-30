import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:zachranobed/common/data/service/auth_service.dart';
import 'package:zachranobed/common/presentation/router/app_router.gr.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/utils/field_validation_utils.dart';
import 'package:zachranobed/common/presentation/utils/helper_service.dart';
import 'package:zachranobed/common/presentation/widget/other/adaptive_content.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_button_size.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_primary_button.dart';
import 'package:zachranobed/common/presentation/widget/screen_scaffold.dart';
import 'package:zachranobed/common/presentation/widget/snackbar/temporary_snackbar.dart';
import 'package:zachranobed/common/presentation/widget/ui_app_bar.dart';
import 'package:zachranobed/common/presentation/widget/ui_password_text_field.dart';

/// A screen that allows authenticated users to change their password.
///
/// This screen guides users through the password change process with three steps:
/// 1. Enter current password (for verification)
/// 2. Enter new password (with validation)
/// 3. Confirm new password (must match)
///
/// Security flow:
/// - Validates all inputs before submission
/// - Re-authenticates user with current password before allowing change
/// - Signs user out after successful password change
/// - Redirects to login screen to re-authenticate with new password
@RoutePage()
class ChangePasswordScreen extends StatefulWidget {
  /// Creates a [ChangePasswordScreen].
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController = TextEditingController();

  final authService = GetIt.I<AuthService>();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold.universalBuilder(
      appBar: UiAppBar(
        title: context.l10n.changePassword,
      ),
      builder: (context) {
        return SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8.0),
                  UiPasswordTextField(
                    labelText: context.l10n.currentPassword,
                    controller: _oldPasswordController,
                    onValidation: FieldValidationUtils.getPasswordValidator(context),
                  ),
                  const SizedBox(height: 32.0),
                  UiPasswordTextField(
                    labelText: context.l10n.newPassword,
                    controller: _newPasswordController,
                    onValidation: FieldValidationUtils.getNewPasswordValidator(context),
                  ),
                  const SizedBox(height: 32.0),
                  UiPasswordTextField(
                    labelText: context.l10n.repeatNewPassword,
                    controller: _confirmNewPasswordController,
                    onValidation: FieldValidationUtils.getRepeatNewPasswordValidator(
                      context,
                      _newPasswordController,
                    ),
                  ),
                  const SizedBox(height: 40.0),
                  UiPrimaryButton(
                    size: UiButtonSize.medium(fullWidth: context.watch<AdaptiveLayoutConfig>().isMobile),
                    text: context.l10n.savePassword,
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final entityId = HelperService.getCurrentUser(context)?.entityId;
                        await _changePassword(entityId);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _changePassword(String? entityId) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await authService.reauthenticateUser(_oldPasswordController.text);

      await authService.changePassword(_newPasswordController.text);

      await authService.signOut(entityId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          ZOTemporarySnackBar(
            message: context.l10n.newPasswordSuccessfullySaved,
          ),
        );

        context.router.replaceAll([const LoginRoute()]);
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        context.router.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          ZOTemporarySnackBar(
            backgroundColor: Colors.red,
            message:
                _isPasswordError(e) ? context.l10n.invalidCurrentPasswordError : context.l10n.somethingWentWrongError,
          ),
        );
      }
    }
  }

  bool _isPasswordError(FirebaseAuthException e) {
    // TODO: Encapsulate this error codes in AuthService
    return e.code == 'wrong-password' || e.code == 'invalid-credential';
  }
}
