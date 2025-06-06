import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:get_it/get_it.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/common/helper_service.dart';
import 'package:zachranobed/common/utils/iterable_utils.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/features/foodboxes/domain/model/box_info.dart';
import 'package:zachranobed/features/foodboxes/domain/model/food_box_statistics.dart';
import 'package:zachranobed/features/foodboxes/domain/repository/food_box_repository.dart';
import 'package:zachranobed/models/charity.dart';
import 'package:zachranobed/routes/app_router.gr.dart';
import 'package:zachranobed/ui/widgets/app_bar.dart';
import 'package:zachranobed/ui/widgets/button.dart';
import 'package:zachranobed/ui/widgets/dialog.dart';
import 'package:zachranobed/ui/widgets/empty_page.dart';
import 'package:zachranobed/ui/widgets/error_content.dart';
import 'package:zachranobed/ui/widgets/food_box_counter.dart';
import 'package:zachranobed/ui/widgets/form/form_validation_manager.dart';
import 'package:zachranobed/ui/widgets/screen_scaffold.dart';
import 'package:zachranobed/ui/widgets/snackbar/temporary_snackbar.dart';

@RoutePage()
class OrderShippingOfBoxesScreen extends StatefulWidget {
  const OrderShippingOfBoxesScreen({super.key});

  @override
  State<OrderShippingOfBoxesScreen> createState() => _OrderShippingOfBoxesScreenState();
}

class _OrderShippingOfBoxesScreenState extends State<OrderShippingOfBoxesScreen> {
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
      appBar: ZOAppBar(
        title: context.l10n!.shippingOfBoxesToCanteen,
      ),
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
      child: FutureBuilder(
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
            return _empty(context, useWideButton);
          }
          return _form(snapshot.requireData, useWideButton);
        },
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
  Widget _empty(
    BuildContext context,
    bool useWideButton,
  ) {
    return SingleChildScrollView(
      child: Column(
        children: [
          EmptyPage(
            vectorImagePath: ZOStrings.boxEmptyPath,
            title: context.l10n!.shippingOfBoxesEmptyTitle,
            description: context.l10n!.shippingOfBoxesEmptyDescription,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: GapSize.xl),
            child: ZOButton(
              text: context.l10n!.shippingOfBoxesEmptyAction,
              minimumSize: ZOButtonSize.medium(fullWidth: useWideButton),
              onPressed: () {
                if (mounted) {
                  context.router.maybePop();
                }
              },
            ),
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
              ...statistics.where((statistics) => statistics.quantityAtCharity > 0).map((value) {
                return FoodBoxCounter(
                  type: value.type,
                  initialValue: 0,
                  maxQuantity: value.quantityAtCharity,
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
              message: context.l10n!.shippingOrderConfirmation,
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
