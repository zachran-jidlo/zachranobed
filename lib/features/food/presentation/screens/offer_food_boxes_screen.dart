import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/utils/helper_service.dart';
import 'package:zachranobed/common/presentation/utils/image_assets.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_button_size.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_primary_button.dart';
import 'package:zachranobed/common/presentation/widget/other/adaptive_content.dart';
import 'package:zachranobed/common/presentation/widget/page/error_page.dart';
import 'package:zachranobed/common/presentation/widget/page/info_page.dart';
import 'package:zachranobed/common/presentation/widget/page/loading_page.dart';
import 'package:zachranobed/common/presentation/widget/screen_scaffold.dart';
import 'package:zachranobed/common/presentation/widget/ui_app_bar.dart';
import 'package:zachranobed/common/presentation/widget/ui_box_counter_tile.dart';
import 'package:zachranobed/common/presentation/widget/ui_counter_field.dart';
import 'package:zachranobed/features/food/domain/model/food_box_statistics.dart';
import 'package:zachranobed/features/food/domain/model/food_box_type.dart';
import 'package:zachranobed/features/food/domain/usecase/observe_food_box_statistics_use_case.dart';

/// A screen that allows canteen users to specify returnable food boxes
/// included with their food donation.
///
/// Displays a list of available box types with counters, allowing users to
/// specify how many boxes of each type they are including. Shows an empty state
/// when no boxes are available at the canteen. Returns a [Map] of selected
/// box types and their quantities when saved.
@RoutePage()
class OfferFoodBoxesScreen extends StatefulWidget {
  /// The current quantities of each box type, used to pre-populate the form.
  final Map<FoodBoxType, int> currentBoxesQuantity;

  const OfferFoodBoxesScreen({
    super.key,
    required this.currentBoxesQuantity,
  });

  @override
  State<OfferFoodBoxesScreen> createState() => _OfferFoodBoxesScreenState();
}

class _OfferFoodBoxesScreenState extends State<OfferFoodBoxesScreen> {
  final _observeFoodBoxStatistics = GetIt.I<ObserveFoodBoxStatisticsUseCase>();

  final Map<FoodBoxType, int> _boxesQuantity = {};

  late Future<Iterable<FoodBoxStatistics>> _statisticsFuture;

  @override
  void initState() {
    super.initState();

    // Sets the current food box quantities
    _boxesQuantity.clear();
    _boxesQuantity.addAll(widget.currentBoxesQuantity);

    _loadStatistics();
  }

  /// Loads food box statistics.
  void _loadStatistics() {
    setState(() {
      final user = HelperService.getCurrentUser(context)!;
      _statisticsFuture = _observeFoodBoxStatistics.invoke(user).first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold.universalBuilder(
      appBar: UiAppBar(title: context.l10n.offerFoodBoxInfoScreenTitle),
      builder: (context) {
        return FutureBuilder(
          future: _statisticsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingPage();
            }
            if (snapshot.hasError || snapshot.data == null) {
              return ErrorPage(onRetryPressed: _loadStatistics);
            }
            final availableBoxes = snapshot.requireData.where((statistics) => statistics.quantityAtCanteen > 0);
            if (availableBoxes.isEmpty) {
              return _buildEmptyPage();
            }
            return _buildContent(context, availableBoxes);
          },
        );
      },
    );
  }

  Widget _buildEmptyPage() {
    return InfoPage(
      image: ImageAssets.imageEmptyBox,
      title: context.l10n.offerFoodBoxInfoEmptyTitle,
      description: context.l10n.offerFoodBoxInfoEmptyDescription,
      actions: [
        UiPrimaryButton(
          size: UiButtonSize.medium(fullWidth: true),
          text: context.l10n.commonBack,
          onPressed: () => context.router.maybePop(),
        ),
      ],
    );
  }

  Widget _buildContent(
    BuildContext context,
    Iterable<FoodBoxStatistics> availableBoxes,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: _buildForm(availableBoxes),
          ),
        ),
        _buildBottomButton(context),
      ],
    );
  }

  Widget _buildForm(Iterable<FoodBoxStatistics> availableBoxes) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        spacing: 24.0,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            context.l10n.offerFoodBoxInfoDescription,
            style: context.textStyles.bodyLarge,
          ),
          ...availableBoxes.map((value) {
            return UiBoxCounterTile(
              title: value.type.name,
              subtitle: context.l10n.totalCountOfBoxes(value.quantityAtCanteen),
              counterField: UiCounterField(
                label: context.l10n.numberOfBoxes,
                value: _boxesQuantity[value.type] ?? 0,
                maxValue: value.quantityAtCanteen,
                onChanged: (count) {
                  setState(() {
                    _boxesQuantity[value.type] = count;
                  });
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    final isMobileLayout = context.watch<AdaptiveLayoutConfig>().isMobile;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Flex(
        spacing: 16.0,
        direction: isMobileLayout ? Axis.vertical : Axis.horizontal,
        children: [
          UiPrimaryButton(
            text: context.l10n.offerFoodBoxInfoSaveAction,
            size: UiButtonSize.medium(fullWidth: isMobileLayout),
            onPressed: _onConfirmationButtonPressed,
          ),
        ],
      ),
    );
  }

  void _onConfirmationButtonPressed() {
    // Use initial list of food boxes to maintain correct order
    // Remove types where the quantity is zero
    final resultMap = Map<FoodBoxType, int>.from(_boxesQuantity);
    resultMap.removeWhere((key, value) => value <= 0);
    context.router.pop(resultMap);
  }
}
