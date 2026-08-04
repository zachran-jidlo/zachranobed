import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:zachranobed/common/presentation/router/app_router.gr.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_button_size.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_primary_button.dart';
import 'package:zachranobed/common/presentation/widget/card/ui_list_tile.dart';
import 'package:zachranobed/common/presentation/widget/layout/content_with_loading.dart';
import 'package:zachranobed/common/presentation/widget/layout/screen_scaffold.dart';
import 'package:zachranobed/common/presentation/widget/layout/section_header.dart';
import 'package:zachranobed/common/presentation/widget/navigation/ui_app_bar.dart';
import 'package:zachranobed/common/presentation/widget/overlay/ui_temporary_snackbar.dart';
import 'package:zachranobed/features/food/domain/model/box_delivery_confirmation.dart';
import 'package:zachranobed/features/food/domain/usecase/confirm_box_delivery_use_case.dart';

/// Screen where the canteen confirms it received a box return from the charity.
@RoutePage()
class BoxDeliveryConfirmationScreen extends StatefulWidget {
  /// The box return to confirm, captured when the user opened this screen.
  ///
  /// A one-time snapshot by design, so the list cannot shift while the user is
  /// counting boxes.
  final BoxDeliveryConfirmation confirmation;

  const BoxDeliveryConfirmationScreen({
    super.key,
    required this.confirmation,
  });

  @override
  State<BoxDeliveryConfirmationScreen> createState() => _BoxDeliveryConfirmationScreenState();
}

class _BoxDeliveryConfirmationScreenState extends State<BoxDeliveryConfirmationScreen> {
  late final ConfirmBoxDeliveryUseCase _confirmBoxDelivery;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _confirmBoxDelivery = GetIt.I<ConfirmBoxDeliveryUseCase>();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold.universal(
      appBar: UiAppBar(title: context.l10n.boxDeliveryConfirmationScreenTitle),
      child: ContentWithLoading(
        isLoading: _isLoading,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: _buildContent(context)),
            _buildBottomButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        spacing: 16.0,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.l10n.boxDeliveryConfirmationScreenDescription,
            style: context.textStyles.bodyLarge,
          ),
          SectionHeader(
            title: context.l10n.boxDeliveryConfirmationSectionTitle,
          ),
          _buildBoxList(context),
        ],
      ),
    );
  }

  Widget _buildBoxList(BuildContext context) {
    return Column(
      spacing: 8.0,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: widget.confirmation.items.map((item) {
        return UiListTile(
          title: item.type.name,
          end: Text(
            context.l10n.commonCountTemplate(item.count),
            style: context.textStyles.labelLarge,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: UiPrimaryButton(
        text: context.l10n.boxDeliveryConfirmationSubmitAction,
        size: UiButtonSize.medium(fullWidth: true),
        enabled: !_isLoading,
        onPressed: () => _submit(context),
      ),
    );
  }

  Future<void> _submit(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    final success = await _confirmBoxDelivery.invoke(widget.confirmation.delivery);
    if (!context.mounted) {
      return;
    }

    if (success) {
      context.router.popUntilRouteWithName(HomeRoute.name);
    } else {
      UiTemporarySnackBar.showError(context, message: context.l10n.boxDeliveryConfirmationErrorMessage);
      setState(() {
        _isLoading = false;
      });
    }
  }
}
