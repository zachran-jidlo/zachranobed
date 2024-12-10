import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:get_it/get_it.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/common/helper_service.dart';
import 'package:zachranobed/common/utils/field_validation_utils.dart';
import 'package:zachranobed/common/utils/iterable_utils.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/features/foodboxes/domain/model/box_info.dart';
import 'package:zachranobed/features/foodboxes/domain/model/food_box_statistics.dart';
import 'package:zachranobed/features/foodboxes/domain/repository/food_box_repository.dart';
import 'package:zachranobed/models/charity.dart';
import 'package:zachranobed/routes/app_router.gr.dart';
import 'package:zachranobed/ui/widgets/button.dart';
import 'package:zachranobed/ui/widgets/counter_field.dart';
import 'package:zachranobed/ui/widgets/dialog.dart';
import 'package:zachranobed/ui/widgets/empty_page.dart';
import 'package:zachranobed/ui/widgets/error_content.dart';
import 'package:zachranobed/ui/widgets/form/form_validation_manager.dart';
import 'package:zachranobed/ui/widgets/screen_scaffold.dart';
import 'package:zachranobed/ui/widgets/section_header.dart';
import 'package:zachranobed/ui/widgets/snackbar/temporary_snackbar.dart';

@RoutePage()
class OrderShippingOfBoxesScreen extends StatefulWidget {
  const OrderShippingOfBoxesScreen({super.key});

  @override
  State<OrderShippingOfBoxesScreen> createState() =>
      _OrderShippingOfBoxesScreenState();
}

class _OrderShippingOfBoxesScreenState
    extends State<OrderShippingOfBoxesScreen> {
  final _foodBoxRepository = GetIt.I<FoodBoxRepository>();

  final _formKey = GlobalKey<FormState>();
  final _formValidationManager = FormValidationManager();

  final Map<String, int> _boxesQuantity = {};

  late Future<Iterable<FoodBoxStatistics>> _statisticsFuture;

  @override
  void initState() {
    super.initState();
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

  Future<bool> _showConfirmationDialog() async {
    final isFilled = _boxesQuantity.values.any((value) => value > 0);
    if (isFilled) {
      return (await showDialog(
            context: context,
            builder: (context) => ZODialog(
              title: context.l10n!.cancelShippingOfBoxes,
              content: context.l10n!.cancelShippingOfBoxesDialogContent,
              confirmText: context.l10n!.confirmCancel,
              cancelText: context.l10n!.continueTheOffer,
              onConfirmPressed: () => Navigator.of(context).pop(true),
              onCancelPressed: () => Navigator.of(context).pop(false),
            ),
          )) ??
          false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      web: (context) => _orderBoxShippingScreenContent(useWideButton: false),
      mobile: (context) => _orderBoxShippingScreenContent(useWideButton: true),
    );
  }

  /// Builds the content of the order box shipping screen.
  ///
  /// The [useWideButton] parameter determines whether to stretch confirmation
  /// button to screen width.
  Widget _orderBoxShippingScreenContent({
    required bool useWideButton,
  }) {
    return WillPopScope(
      onWillPop: _showConfirmationDialog,
      child: Scaffold(
        appBar: AppBar(
          bottom: AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              context.l10n!.shippingOfBoxesToCanteen,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
        ),
        body: FutureBuilder(
          future: _statisticsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _loading();
            } else if (snapshot.hasError || snapshot.data == null) {
              return _error(context);
            }
            final hasSomeBoxes = snapshot.requireData.any(
              (box) => box.quantityAtCharity > 0,
            );
            if (!hasSomeBoxes) {
              return _empty(context);
            }
            return _form(snapshot.requireData, useWideButton);
          },
        ),
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
            title: context.l10n!.shippingOfBoxesEmptyTitle,
            description: context.l10n!.shippingOfBoxesEmptyDescription,
          ),
          ZOButton(
            text: context.l10n!.shippingOfBoxesEmptyAction,
            minimumSize: ZOButtonSize.tiny(),
            onPressed: () {
              if (mounted) {
                context.router.maybePop();
              }
            },
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
              ...statistics
                  .where((statistics) => statistics.quantityAtCharity > 0)
                  .map((value) {
                return _FoodBoxCounter(
                  statistics: value,
                  formValidationManager: _formValidationManager,
                  onChanged: (count) {
                    _boxesQuantity[value.type.id] = count;
                  },
                );
              }).separated(
                const SizedBox(height: GapSize.xl),
              ),
              const SizedBox(height: GapSize.xxl),
              Align(
                alignment: Alignment.centerLeft,
                child: ZOButton(
                  text: context.l10n!.orderShipping,
                  icon: MaterialSymbols.check,
                  minimumSize: ZOButtonSize.large(
                    fullWidth: useWideButton,
                  ),
                  onPressed: _onConfirmationButtonPressed,
                ),
              ),
              const SizedBox(height: GapSize.xxl),
            ],
          ),
        ),
      ),
    );
  }

  void _onConfirmationButtonPressed() async {
    if (_formKey.currentState!.validate()) {
      if (_boxesQuantity.values.every((quantity) => quantity == 0)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            ZOTemporarySnackBar(
              message: context.l10n!.shippingOfBoxesEmptyFormMessage,
            ),
          );
        }
      } else if (await _verifyAvailableBoxCount()) {
        final isSuccess = await _orderShipping();
        if (mounted) {
          context.router.replace(
            ThankYouRoute(
              isSuccess: isSuccess,
              message:
              context.l10n!.shippingOrderConfirmation,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            ZOTemporarySnackBar(
              backgroundColor: Colors.red,
              message: context.l10n!.boxCountError,
            ),
          );
        }
      }
    } else {
      _formValidationManager.scrollToFirstError();
    }
  }

  Future<bool> _verifyAvailableBoxCount() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final user = HelperService.getCurrentUser(context);
    if (user == null) {
      return false;
    }

    final available = await _foodBoxRepository.verifyAvailableBoxCount(
      user: user,
      requiredBoxes: _boxesQuantity,
      getQuantity: (e) => e.quantityAtCharity,
    );

    if (!available) {
      if (mounted) {
        context.router.pop();
      }
    }

    return available;
  }

  Future<bool> _orderShipping() async {
    final user = HelperService.getCurrentUser(context);
    if (user is! Charity) {
      return false;
    }

    final boxes = _boxesQuantity.map(
      (id, count) => MapEntry(
        id,
        BoxInfo(
          foodBoxId: id,
          numberOfBoxes: count,
        ),
      ),
    );
    return _foodBoxRepository.createBoxDelivery(
      user: user,
      boxInfo: boxes.values.toList(),
    );
  }
}

/// A widget that displays a counter for a specific type of food box.
class _FoodBoxCounter extends StatelessWidget {
  /// Statistics about available food box type and quantity.
  final FoodBoxStatistics statistics;

  /// Callback function triggered when the counter value changes.
  final Function(int)? onChanged;

  /// The form validation manager.
  final FormValidationManager formValidationManager;

  /// Creates a [_FoodBoxCounter] widget.
  const _FoodBoxCounter({
    Key? key,
    required this.statistics,
    required this.onChanged,
    required this.formValidationManager,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        SectionHeader(
          title: Text(
            statistics.type.name,
            style: textTheme.titleLarge,
          ),
          subtitle: Text(
            context.l10n!.totalCountOfBoxes(statistics.quantityAtCharity),
            style: textTheme.titleSmall
                ?.copyWith(color: ZOColors.onBackgroundSecondary),
          ),
        ),
        const SizedBox(height: GapSize.xs),
        CounterField(
          label: context.l10n!.numberOfBoxes,
          focusNode: formValidationManager.getFocusNode(statistics.type.id),
          onValidation: formValidationManager.wrapValidator(
            statistics.type.id,
            FieldValidationUtils.getBoxNumberValidator(
              context,
              allowZero: true,
              max: statistics.quantityAtCharity,
            ),
          ),
          initialValue: 0,
          maxValue: statistics.quantityAtCharity,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
