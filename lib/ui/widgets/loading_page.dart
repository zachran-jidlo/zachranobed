import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  final String pageTitle;

  const LoadingPage({super.key, required this.pageTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(pageTitle)),
      body: const Center(child: CircularProgressIndicator()),
    );
  }
}
