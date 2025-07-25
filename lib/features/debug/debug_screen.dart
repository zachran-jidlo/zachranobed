import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:zachranobed/common/logger/zo_logger.dart';
import 'package:zachranobed/ui/widgets/app_bar.dart';
import 'package:zachranobed/ui/widgets/button.dart';
import 'package:zachranobed/ui/widgets/screen_scaffold.dart';

@RoutePage()
class DebugScreen extends StatelessWidget {
  const DebugScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold.universal(
      appBar: const ZOAppBar(
        title: "Debug Screen",
      ),
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
            ],
          ),
        ),
      ),
    );
  }
}
