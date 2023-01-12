import 'package:flutter/material.dart';
import 'package:zachranobed/constants.dart';

class Menu extends StatelessWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(ZachranObedStrings.menu),
      ),
    );
  }
}
