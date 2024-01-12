import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/common/helper_service.dart';
import 'package:zachranobed/common/logger/zo_logger.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/routes/app_router.gr.dart';
import 'package:zachranobed/services/auth_service.dart';
import 'package:zachranobed/ui/widgets/button.dart';
import 'package:zachranobed/ui/widgets/clickable_text.dart';
import 'package:zachranobed/ui/widgets/password_text_field.dart';
import 'package:zachranobed/ui/widgets/snackbar/temporary_snackbar.dart';
import 'package:zachranobed/ui/widgets/text_field.dart';

@RoutePage()
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _authService = GetIt.I<AuthService>();

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(height: GapSize.xl),
              SvgPicture.asset(ZOStrings.zoLogoPath, width: 270, height: 46),
              const SizedBox(height: GapSize.l),
              Image.asset(
                width: 415,
                ZOStrings.foodImagePath,
                fit: BoxFit.fitWidth,
              ),
              const SizedBox(height: GapSize.l),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: WidgetStyle.padding,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      ZOTextField(
                        label: context.l10n!.emailAddress,
                        inputType: TextInputType.emailAddress,
                        controller: _emailController,
                        onValidation: (val) => val!.isEmpty
                            ? context.l10n!.requiredFieldError
                            : null,
                      ),
                      const SizedBox(height: GapSize.m),
                      ZOPasswordTextField(
                        text: context.l10n!.password,
                        controller: _passwordController,
                        onValidation: (val) => val!.isEmpty
                            ? context.l10n!.requiredFieldError
                            : null,
                      ),
                      const SizedBox(height: GapSize.l),
                      ZOButton(
                        text: context.l10n!.signIn,
                        icon: MaterialSymbols.login,
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await _logIn();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: GapSize.m),
              ZOClickableText(
                  clickableText: context.l10n!.forgotPassword,
                  color: ZOColors.onPrimaryLight,
                  underline: false,
                  onTap: () {
                    context.router.push(const ForgotPasswordRoute());
                  }),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _logIn() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final result = await _authService.signIn(
      _emailController.text,
      _passwordController.text,
    );
    if (result != null) {
      if (mounted) {
        await HelperService.loadUserInfo(context);

        ZOLogger.logMessage(
            "Přihlášen uživatel: ${HelperService.getCurrentUser(_formKey.currentContext!)?.debugInfo}");

        if (mounted) {
          context.router.replace(const HomeRoute());
        }
      }
    } else {
      if (mounted) {
        context.router.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          ZOTemporarySnackBar(
            backgroundColor: Colors.red,
            message: context.l10n!.wrongCredentialsError,
          ),
        );
      }
    }
  }
}
