import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/common/utils/field_validation_utils.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/routes/app_router.gr.dart';
import 'package:zachranobed/services/auth_service.dart';
import 'package:zachranobed/ui/widgets/button.dart';
import 'package:zachranobed/ui/widgets/password_text_field.dart';
import 'package:zachranobed/ui/widgets/screen_scaffold.dart';
import 'package:zachranobed/ui/widgets/snackbar/temporary_snackbar.dart';

@RoutePage()
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();

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
    return ScreenScaffold(
      web: (context) => _changePasswordScreenContent(useWideButton: false),
      mobile: (context) => _changePasswordScreenContent(useWideButton: true),
    );
  }

  /// Builds the content of the change password screen.
  ///
  /// The [useWideButton] parameter determines whether to stretch confirmation
  /// button to screen width.
  Widget _changePasswordScreenContent({
    required bool useWideButton,
  }) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n!.changePassword),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: WidgetStyle.padding,
            ),
            child: Column(
              children: [
                const SizedBox(height: GapSize.xxs),
                ZOPasswordTextField(
                  text: context.l10n!.currentPassword,
                  controller: _oldPasswordController,
                  onValidation: FieldValidationUtils.getPasswordValidator(
                    context,
                  ),
                ),
                const SizedBox(height: GapSize.m),
                ZOPasswordTextField(
                  text: context.l10n!.newPassword,
                  controller: _newPasswordController,
                  onValidation: FieldValidationUtils.getNewPasswordValidator(
                    context,
                  ),
                ),
                const SizedBox(height: GapSize.m),
                ZOPasswordTextField(
                  text: context.l10n!.repeatNewPassword,
                  controller: _confirmNewPasswordController,
                  onValidation:
                  FieldValidationUtils.getRepeatNewPasswordValidator(
                    context,
                    _newPasswordController,
                  ),
                ),
                const SizedBox(height: GapSize.m),
                Align(
                  alignment: Alignment.centerLeft,
                  child: ZOButton(
                    text: context.l10n!.savePassword,
                    icon: Icons.check,
                    minimumSize: ZOButtonSize.large(fullWidth: useWideButton),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await _changePassword();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _changePassword() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await authService.reauthenticateUser(_oldPasswordController.text);

      await authService.changePassword(_newPasswordController.text);

      await authService.signOut();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          ZOTemporarySnackBar(
            message: context.l10n!.newPasswordSuccessfullySaved,
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
            message: _isPasswordError(e)
                ? context.l10n!.invalidCurrentPasswordError
                : context.l10n!.somethingWentWrongError,
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
