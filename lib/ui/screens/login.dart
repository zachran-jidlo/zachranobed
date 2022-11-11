import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zachranobed/constants.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              children: [
                SizedBox(height: 35),
                SvgPicture.asset(
                  ZachranObedStrings.zjLogoPath,
                  color: ZachranObedColors.primary,
                ),
                SizedBox(height: 20),

                Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 2)
                  ),
                  child: Image.asset(
                    ZachranObedStrings.placeholderImagePath,

                  ),
                ),
                SizedBox(height: 20),

                TextField(
                  decoration: InputDecoration(
                    labelText: ZachranObedStrings.emailAddress,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2
                      ),
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                ),
                SizedBox(height: 15),


                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: ZachranObedStrings.password,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2
                      ),
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                ),
                SizedBox(height: 10),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(50),
                  ),
                  onPressed: () {},
                  child: Text(
                    ZachranObedStrings.login.toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 15),

                RichText(
                  text: TextSpan(
                      text: ZachranObedStrings.forgottenPassword,
                      style: TextStyle(
                        color: Colors.black,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                        print('Change password');
                      }
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
