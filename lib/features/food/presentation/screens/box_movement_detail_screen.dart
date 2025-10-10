import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/common/presentation/widget/app_bar.dart';
import 'package:zachranobed/common/presentation/widget/screen_scaffold.dart';
import 'package:zachranobed/common/presentation/widget/snackbar/persistent_snackbar.dart';
import 'package:zachranobed/common/presentation/widget/supporting_text.dart';
import 'package:zachranobed/common/presentation/widget/text_field.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/features/food/domain/model/box_movement.dart';

@RoutePage()
class BoxMovementDetailScreen extends StatelessWidget {
  final BoxMovement boxMovement;

  const BoxMovementDetailScreen({
    super.key,
    required this.boxMovement,
  });

  @override
  Widget build(BuildContext context) {
    final countPrefix = boxMovement.count > 0 ? '+' : '';
    return ScreenScaffold.universal(
      appBar: ZOAppBar(
        title: boxMovement.type.name,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: WidgetStyle.padding,
          ),
          child: Column(
            children: <Widget>[
              ZOTextField(
                label: context.l10n!.numberOfBoxes,
                initialValue: '$countPrefix${boxMovement.count}',
                readOnly: true,
              ),
              const SizedBox(height: GapSize.xs),
              SupportingText(
                text: '${context.l10n!.sentOn}'
                    ' ${DateFormat('d.M.y').format(boxMovement.date)}.',
              ),
              const SizedBox(height: GapSize.xs),
              ZOPersistentSnackBar(message: context.l10n!.formCantBeEdited),
              const SizedBox(height: GapSize.m),
            ],
          ),
        ),
      ),
    );
  }
}
