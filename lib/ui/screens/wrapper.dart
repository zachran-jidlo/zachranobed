import 'package:flutter/material.dart';
import 'package:zachranobed/ui/screens/login.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return either Home or Login widget
    return Login();
  }
}
