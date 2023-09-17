import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/models/box_movement.dart';
import 'package:zachranobed/models/user_data.dart';
import 'package:zachranobed/ui/widgets/snackbar/persistent_snackbar.dart';
import 'package:zachranobed/ui/widgets/supporting_text.dart';
import 'package:zachranobed/ui/widgets/text_field.dart';

@RoutePage()
class BoxMovementDetailScreen extends StatelessWidget {
  final BoxMovement boxMovement;
  final UserData user;

  const BoxMovementDetailScreen({
    super.key,
    required this.boxMovement,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: WidgetStyle.padding,
          ),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    boxMovement.boxType ?? '',
                    style: const TextStyle(fontSize: FontSize.l),
                  ),
                ],
              ),
              const SizedBox(height: GapSize.s),
              ZOTextField(
                label: context.l10n!.numberOfBoxes,
                initialValue: user.establishmentId == boxMovement.senderId
                    ? '-${boxMovement.numberOfBoxes.toString()}'
                    : '+${boxMovement.numberOfBoxes.toString()}',
                readOnly: true,
              ),
              const SizedBox(height: GapSize.xs),
              SupportingText(
                text: '${context.l10n!.sentOn}'
                    ' ${DateFormat('d.M.y').format(boxMovement.date!)}'
                    ' ${context.l10n!.atTime}'
                    ' ${DateFormat('HH:mm').format(boxMovement.date!)}.',
              ),
              const SizedBox(height: GapSize.xs),
              ZOPersistentSnackBar(message: context.l10n!.formCantBeEdited),
              const SizedBox(height: GapSize.s),
            ],
          ),
        ),
      ),
    );
  }
}
