import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/common/helper_service.dart';
import 'package:zachranobed/common/utils/iterable_utils.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/features/foodboxes/domain/model/food_box_statistics.dart';
import 'package:zachranobed/features/foodboxes/domain/model/food_box_type.dart';
import 'package:zachranobed/features/foodboxes/domain/repository/food_box_repository.dart';
import 'package:zachranobed/ui/widgets/button.dart';
import 'package:zachranobed/ui/widgets/empty_page.dart';
import 'package:zachranobed/ui/widgets/error_content.dart';
import 'package:zachranobed/ui/widgets/food_box_counter.dart';
import 'package:zachranobed/ui/widgets/form/form_validation_manager.dart';
import 'package:zachranobed/ui/widgets/screen_scaffold.dart';

/// Screen for setting food boxes in food offer flow.
@RoutePage()
class OfferFoodBoxesScreen extends StatefulWidget {
  final Map<FoodBoxType, int> currentBoxesQuantity;

  const OfferFoodBoxesScreen({
    super.key,
    required this.currentBoxesQuantity,
  });

  @override
  State<OfferFoodBoxesScreen> createState() => _OfferFoodBoxesScreenState();
}

class _OfferFoodBoxesScreenState extends State<OfferFoodBoxesScreen> {
  final _foodBoxRepository = GetIt.I<FoodBoxRepository>();

  final _formKey = GlobalKey<FormState>();
  final _formValidationManager = FormValidationManager();

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

  @override
  void dispose() {
    _formValidationManager.dispose();
    super.dispose();
  }

  /// Loads food box statistics.
  void _loadStatistics() {
    setState(() {
      final user = HelperService.getCurrentUser(context)!;
      _statisticsFuture = _foodBoxRepository.observeStatistics(user).first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      web: (context) => _offerFoodBoxesScreenContent(useWideButton: false),
      mobile: (context) => _offerFoodBoxesScreenContent(useWideButton: true),
    );
  }

  /// Builds the content of the screen.
  ///
  /// The [useWideButton] parameter determines whether to stretch confirmation
  /// button to screen width.
  Widget _offerFoodBoxesScreenContent({
    required bool useWideButton,
  }) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(WidgetStyle.padding),
            alignment: Alignment.centerLeft,
            child: Text(
              context.l10n!.offerFoodBoxInfoScreenTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _statisticsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _loading();
                } else if (snapshot.hasError || snapshot.data == null) {
                  return _error(context);
                } else {
                  final hasSomeBoxes = snapshot.requireData.any((box) => box.quantityAtCanteen > 0);
                  if (!hasSomeBoxes) {
                    return _empty(context);
                  } else {
                    return _form(snapshot.requireData, useWideButton);
                  }
                }
              },
            ),
          )
        ],
      ),
    );
  }

  /// Builds a loading screen content.
  Widget _loading() {
    return const Center(child: CircularProgressIndicator());
  }

  /// Builds a generic error screen content.
  Widget _error(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ErrorContent(
            onRetryPressed: _loadStatistics,
          ),
          const SizedBox(height: GapSize.xs),
        ],
      ),
    );
  }

  /// Builds an empty screen content.
  Widget _empty(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          EmptyPage(
            vectorImagePath: ZOStrings.boxEmptyPath,
            title: context.l10n!.offerFoodBoxInfoEmptyTitle,
            description: context.l10n!.offerFoodBoxInfoEmptyDescription,
          ),
          ZOButton(
            text: context.l10n!.commonBack,
            minimumSize: ZOButtonSize.tiny(),
            onPressed: () => context.router.maybePop(),
          ),
          const SizedBox(height: GapSize.xs),
        ],
      ),
    );
  }

  /// Builds the form content for the given [statistics].
  Widget _form(
    Iterable<FoodBoxStatistics> statistics,
    bool useWideButton,
  ) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(GapSize.xs),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              ...statistics.map((value) {
                return FoodBoxCounter(
                  type: value.type,
                  initialValue: _boxesQuantity[value.type] ?? 0,
                  maxQuantity: value.quantityAtCanteen,
                  formValidationManager: _formValidationManager,
                  onChanged: (count) {
                    _boxesQuantity[value.type] = count;
                  },
                );
              }).separated(
                const SizedBox(height: GapSize.xl),
              ),
              const SizedBox(height: GapSize.xxl),
              Align(
                alignment: Alignment.centerLeft,
                child: ZOButton(
                  text: context.l10n!.offerFoodBoxInfoSaveAction,
                  minimumSize: ZOButtonSize.large(
                    fullWidth: useWideButton,
                  ),
                  onPressed: () => _onConfirmationButtonPressed(statistics),
                ),
              ),
              const SizedBox(height: GapSize.xxl),
            ],
          ),
        ),
      ),
    );
  }

  void _onConfirmationButtonPressed(Iterable<FoodBoxStatistics> statistics) async {
    if (_formKey.currentState!.validate()) {
      if (mounted) {
        // Use initial list of food boxes to maintain correct order and remove types where the quantity is zero
        final resultMap = {for (var item in statistics) item.type: _boxesQuantity[item.type] ?? 0};
        resultMap.removeWhere((key, value) => value <= 0);
        context.router.popForced(resultMap);
      }
    } else {
      _formValidationManager.scrollToFirstError();
    }
  }
}
