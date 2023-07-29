import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/routes/app_router.gr.dart';
import 'package:zachranobed/services/auth_service.dart';
import 'package:zachranobed/services/helper_service.dart';
import 'package:zachranobed/shared/constants.dart';
import 'package:zachranobed/ui/widgets/button.dart';
import 'package:zachranobed/ui/widgets/clickable_text.dart';
import 'package:zachranobed/ui/widgets/passwd_text_field.dart';
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
              const SizedBox(height: GapSize.l),
              SvgPicture.asset(ZOStrings.zoLogoPath, width: 270, height: 46),
              const SizedBox(height: GapSize.m),
              Image.asset(
                width: 415,
                ZOStrings.foodImagePath,
                fit: BoxFit.fitWidth,
              ),
              const SizedBox(height: GapSize.m),
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
                        const SizedBox(height: GapSize.s),
                        ZOPasswordTextField(
                          text: context.l10n!.password,
                          controller: _passwordController,
                          onValidation: (val) => val!.isEmpty
                              ? context.l10n!.requiredFieldError
                              : null,
                        ),
                        const SizedBox(height: GapSize.m),
                        ZOButton(
                          text: context.l10n!.signIn,
                          icon: MaterialSymbols.login,
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await _logIn(context);
                            }
                          },
                        ),
                      ],
                    )),
              ),
              const SizedBox(height: GapSize.s),
              ZOClickableText(
                  clickableText: context.l10n!.forgottenPassword,
                  color: ZOColors.onPrimaryLight,
                  underline: false,
                  onTap: () {
                    print('Forgotten password');
                  }),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _logIn(BuildContext context) async {
    final result = await _authService.signIn(
      _emailController.text,
      _passwordController.text,
    );
    if (result != null) {
      if (mounted) {
        await HelperService.loadUserInfo(context);
        if (mounted) {
          context.router.replace(const HomeRoute());
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Center(
              child: Text(context.l10n!.wrongCredentialsError),
            ),
          ),
        );
      }
    }
  }
}
