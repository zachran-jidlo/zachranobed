import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  final String pageTitle;
  final Object? error;

  const ErrorPage({super.key, required this.pageTitle, required this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(pageTitle)),
      body: Center(child: Text('Error: $error')),
    );
  }
}
