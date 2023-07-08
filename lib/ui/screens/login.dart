import 'package:flutter/material.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:zachranobed/models/user.dart';
import 'package:zachranobed/notifiers/user_notifier.dart';
import 'package:zachranobed/routes.dart';
import 'package:zachranobed/services/api/user_api_service.dart';
import 'package:zachranobed/shared/constants.dart';
import 'package:zachranobed/ui/widgets/button.dart';
import 'package:zachranobed/ui/widgets/clickable_text.dart';
import 'package:zachranobed/ui/widgets/passwd_text_field.dart';
import 'package:zachranobed/ui/widgets/text_field.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<User?> _tryLogIn() {
    return UserApiService().logIn(email: _emailController.text);
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
                          label: ZOStrings.emailAddress,
                          inputType: TextInputType.emailAddress,
                          controller: _emailController,
                          onValidation: (val) => val!.isEmpty
                              ? ZOStrings.requiredFieldError
                              : null,
                        ),
                        const SizedBox(height: GapSize.s),
                        ZOPasswordTextField(
                          text: ZOStrings.password,
                          controller: _passwordController,
                          onValidation: (val) => val!.isEmpty
                              ? ZOStrings.requiredFieldError
                              : null,
                        ),
                        const SizedBox(height: GapSize.m),
                        ZOButton(
                          text: ZOStrings.login,
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
                  clickableText: ZOStrings.forgottenPassword,
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
    User? user = await _tryLogIn();
    if (user != null) {
      if (context.mounted) {
        final userNotifier = Provider.of<UserNotifier>(context, listen: false);
        userNotifier.user = User.create(
          user.internalId,
          user.email,
          user.pickUpFrom,
          user.pickUpWithin,
          user.establishmentName,
          user.organization,
          user.recipient,
        );
        Navigator.of(context).pushReplacementNamed(RouteManager.home);
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Center(
              child: Text(ZOStrings.wrongCredentialsError),
            ),
          ),
        );
      }
    }
  }
}
