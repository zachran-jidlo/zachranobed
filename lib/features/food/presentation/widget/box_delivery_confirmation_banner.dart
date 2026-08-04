import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:zachranobed/common/domain/model/user_data.dart';
import 'package:zachranobed/common/presentation/router/app_router.gr.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_outline_button.dart';
import 'package:zachranobed/common/presentation/widget/card/ui_food_box_return_tile.dart';
import 'package:zachranobed/features/food/domain/model/box_delivery_confirmation.dart';
import 'package:zachranobed/features/food/domain/usecase/observe_box_delivery_confirmation_use_case.dart';

/// Lets the canteen take today's box return into its stock right away, instead of
/// waiting for the carrier schedule to mark it as delivered.
///
/// Renders nothing when there is no box return to confirm.
///
/// Owns its stream rather than taking one, so that being removed from and added
/// back to the widget tree builds a fresh stream. The use case returns a
/// single-subscription stream, which would throw on a second listen.
class BoxDeliveryConfirmationBanner extends StatefulWidget {
  /// The user the box return belongs to.
  final UserData user;

  const BoxDeliveryConfirmationBanner({
    super.key,
    required this.user,
  });

  @override
  State<BoxDeliveryConfirmationBanner> createState() => _BoxDeliveryConfirmationBannerState();
}

class _BoxDeliveryConfirmationBannerState extends State<BoxDeliveryConfirmationBanner> {
  late Stream<BoxDeliveryConfirmation?> _stream;

  @override
  void initState() {
    super.initState();
    _stream = _createStream();
  }

  @override
  void didUpdateWidget(BoxDeliveryConfirmationBanner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.user != oldWidget.user) {
      _stream = _createStream();
    }
  }

  Stream<BoxDeliveryConfirmation?> _createStream() {
    final useCase = GetIt.I<ObserveBoxDeliveryConfirmationUseCase>();
    return useCase.invoke(widget.user);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BoxDeliveryConfirmation?>(
      stream: _stream,
      builder: (context, snapshot) {
        final confirmation = snapshot.data;
        if (confirmation == null) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: UiFoodBoxReturnTile(
            title: context.l10n.boxDeliveryConfirmationTileTitle,
            subtitle: context.l10n.boxDeliveryConfirmationTileSubtitle,
            count: confirmation.totalCount,
            action: UiOutlineButton(
              text: context.l10n.boxDeliveryConfirmationTileAction,
              onPressed: () {
                context.router.push(BoxDeliveryConfirmationRoute(confirmation: confirmation));
              },
            ),
          ),
        );
      },
    );
  }
}
