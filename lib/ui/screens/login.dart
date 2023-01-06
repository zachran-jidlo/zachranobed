import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:zachranobed/constants.dart';
import 'package:zachranobed/models/user.dart';
import 'package:zachranobed/routes.dart';
import 'package:zachranobed/ui/widgets/button.dart';
import 'package:zachranobed/ui/widgets/checkbox.dart';
import 'package:zachranobed/ui/widgets/clickable_text.dart';
import 'package:zachranobed/ui/widgets/text_field.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _rememberUser = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SvgPicture.asset(
                    ZachranObedStrings.zjLogoPath,
                    color: ZachranObedColors.primary,
                  ),
                  const SizedBox(height: 20),

                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 2)
                    ),
                    child: Image.asset(
                      ZachranObedStrings.placeholderImagePath,
                    ),
                  ),
                  const SizedBox(height: 20),

                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        ZachranObedTextField(
                          text: ZachranObedStrings.emailAddress,
                          controller: emailController,
                          onValidation: (val) => val!.isEmpty ? ZachranObedStrings.requiredFieldError : null,
                        ),
                        const SizedBox(height: 15),

                        ZachranObedTextField(
                          text: ZachranObedStrings.password,
                          controller: passwordController,
                          obscureText: true,
                          onValidation: (val) => val!.isEmpty ? ZachranObedStrings.requiredFieldError : null,
                        ),
                        const SizedBox(height: 10),

                        ZachranObedCheckbox(
                          text: ZachranObedStrings.rememberUser,
                          isChecked: _rememberUser,
                          whatIsChecked: (bool value) => setState(() {
                            _rememberUser = value;
                            print(_rememberUser);
                          })
                        ),

                        ZachranObedButton(
                          text: ZachranObedStrings.login.toUpperCase(),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              Provider.of<User>(context, listen: false).newUser(
                                  emailController.text, passwordController.text);
                              Navigator.of(context).pushReplacementNamed(RouteManager.home);
                            }
                          },
                        ),
                      ],
                    )
                  ),
                  const SizedBox(height: 15),

                  ZachranObedClickableText(
                    text: ZachranObedStrings.forgottenPassword,
                    onTap: () {
                      print('Change password');
                    }
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
