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
import 'package:zachranobed/ui/widgets/snackbar/temporary_snackbar.dart';
import 'package:zachranobed/ui/widgets/text_field.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n!.passwordReset),
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
                Text(context.l10n!.passwordResetExplanation),
                const SizedBox(height: GapSize.m),
                ZOTextField(
                  label: context.l10n!.emailAddress,
                  inputType: TextInputType.emailAddress,
                  disableAutocorrect: true,
                  controller: _emailController,
                  onValidation: FieldValidationUtils.getEmailValidator(
                    context,
                  ),
                ),
                const SizedBox(height: GapSize.m),
                ZOButton(
                  text: context.l10n!.resetPassword,
                  icon: Icons.email_outlined,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await _resetPassword();
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
          ZOTemporarySnackBar(message: context.l10n!.passwordResetConfirmation),
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
                ? context.l10n!.invalidEmailAddressError
                : e.code == 'user-not-found'
                    ? context.l10n!.userNotFoundError
                    : context.l10n!.somethingWentWrongError,
          ),
        );
      }
    }
  }
}
