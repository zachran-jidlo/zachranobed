import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:zachranobed/common/logger/zo_logger.dart';
import 'package:zachranobed/ui/widgets/button.dart';

@RoutePage()
class DebugScreen extends StatelessWidget {
  const DebugScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Debug Screen"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
                children: <Widget>[
                  ZOButton(
                    text: "Test log",
                    icon: MaterialSymbols.bug_report,
                    onPressed: () {
                      ZOLogger.logMessage("This is a debug message to the logger to verify, how the logger works");
                    },
                  ),
                ]
            )
          ),
        ),
      ),
    );
  }
}