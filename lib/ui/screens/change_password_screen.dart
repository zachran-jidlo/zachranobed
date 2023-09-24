import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/routes/app_router.gr.dart';
import 'package:zachranobed/services/auth_service.dart';
import 'package:zachranobed/ui/widgets/button.dart';
import 'package:zachranobed/ui/widgets/snackbar/temporary_snackbar.dart';
import 'package:zachranobed/ui/widgets/text_field.dart';

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
                ZOTextField(
                  label: context.l10n!.currentPassword,
                  inputType: TextInputType.text,
                  controller: _oldPasswordController,
                  onValidation: (val) {
                    return val!.isEmpty
                        ? context.l10n!.requiredFieldError
                        : null;
                  },
                ),
                const SizedBox(height: GapSize.m),
                ZOTextField(
                  label: context.l10n!.newPassword,
                  inputType: TextInputType.text,
                  controller: _newPasswordController,
                  onValidation: (val) {
                    if (val!.isEmpty) {
                      return context.l10n!.requiredFieldError;
                    }
                    if (val.length < 6) {
                      return context.l10n!.passwordLengthError;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: GapSize.m),
                ZOTextField(
                  label: context.l10n!.repeatNewPassword,
                  inputType: TextInputType.text,
                  controller: _confirmNewPasswordController,
                  onValidation: (val) {
                    if (val!.isEmpty) {
                      return context.l10n!.requiredFieldError;
                    }
                    if (val != _newPasswordController.text) {
                      return context.l10n!.passwordsDontMatchError;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: GapSize.m),
                ZOButton(
                  text: context.l10n!.savePassword,
                  icon: Icons.check,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await _changePassword();
                    }
                  },
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
            message: e.code == 'wrong-password'
                ? context.l10n!.invalidCurrentPasswordError
                : context.l10n!.somethingWentWrongError,
          ),
        );
      }
    }
  }
}
