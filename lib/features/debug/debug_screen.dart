import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:zachranobed/common/domain/utils/zo_logger.dart';
import 'package:zachranobed/common/presentation/router/app_router.gr.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_button_size.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_primary_button.dart';
import 'package:zachranobed/common/presentation/widget/screen_scaffold.dart';
import 'package:zachranobed/common/presentation/widget/ui_app_bar.dart';

@RoutePage()
class DebugScreen extends StatelessWidget {
  const DebugScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold.universal(
      appBar: const UiAppBar(
        title: "Debug Screen",
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            spacing: 16.0,
            children: <Widget>[
              UiPrimaryButton(
                size: UiButtonSize.medium(),
                text: "Test log",
                icon: MaterialSymbols.bug_report,
                onPressed: () {
                  ZOLogger.logMessage("This is a debug message to the logger to verify, how the logger works");
                },
              ),
              UiPrimaryButton(
                size: UiButtonSize.medium(),
                text: "Components screen",
                onPressed: () {
                  context.router.push(const ComponentsRoute());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
