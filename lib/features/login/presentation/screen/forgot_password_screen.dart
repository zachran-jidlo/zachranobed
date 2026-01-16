import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:zachranobed/common/data/service/auth_service.dart';
import 'package:zachranobed/common/presentation/router/app_router.gr.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/utils/field_validation_utils.dart';
import 'package:zachranobed/common/presentation/widget/adaptive_content.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_button_size.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_primary_button.dart';
import 'package:zachranobed/common/presentation/widget/screen_scaffold.dart';
import 'package:zachranobed/common/presentation/widget/snackbar/temporary_snackbar.dart';
import 'package:zachranobed/common/presentation/widget/ui_app_bar.dart';
import 'package:zachranobed/common/presentation/widget/ui_text_field.dart';

@RoutePage()
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  final authService = GetIt.I<AuthService>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold.universalBuilder(
      appBar: UiAppBar(
        title: context.l10n.passwordReset,
      ),
      builder: (context) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Text(
                  context.l10n.passwordResetExplanation,
                  style: context.textStyles.bodyLarge,
                ),
                const SizedBox(height: 40),
                UiTextField(
                  controller: _emailController,
                  labelText: context.l10n.emailAddress,
                  keyboardType: TextInputType.emailAddress,
                  disableAutocorrect: true,
                  onValidation: FieldValidationUtils.getEmailValidator(context),
                ),
                const SizedBox(height: 40),
                UiPrimaryButton(
                  text: context.l10n.resetPassword,
                  size: UiButtonSize.medium(fullWidth: context.watch<AdaptiveLayoutConfig>().isMobile),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await _resetPassword();
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _resetPassword() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await authService.resetPassword(_emailController.text);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          ZOTemporarySnackBar(message: context.l10n.passwordResetConfirmation),
        );

        context.router.replaceAll([const LoginRoute()]);
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        context.router.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          ZOTemporarySnackBar(
            backgroundColor: Colors.red,
            message: e.code == 'invalid-email'
                ? context.l10n.invalidFieldEmail
                : e.code == 'user-not-found'
                    ? context.l10n.userNotFoundError
                    : context.l10n.somethingWentWrongError,
          ),
        );
      }
    }
  }
}
