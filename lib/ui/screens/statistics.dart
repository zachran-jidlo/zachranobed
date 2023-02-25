import 'package:flutter/material.dart';
import 'package:zachranobed/shared/constants.dart';

class Statistics extends StatelessWidget {
  const Statistics({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(ZachranObedStrings.statistics),
      ),
    );
  }
}
