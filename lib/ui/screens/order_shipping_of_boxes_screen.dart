import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:get_it/get_it.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/common/helper_service.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/features/foodboxes/domain/model/box_info.dart';
import 'package:zachranobed/features/foodboxes/domain/model/food_box_type.dart';
import 'package:zachranobed/features/foodboxes/domain/repository/food_box_repository.dart';
import 'package:zachranobed/models/charity.dart';
import 'package:zachranobed/routes/app_router.gr.dart';
import 'package:zachranobed/ui/widgets/button.dart';
import 'package:zachranobed/ui/widgets/dialog.dart';
import 'package:zachranobed/ui/widgets/screen_scaffold.dart';
import 'package:zachranobed/ui/widgets/shipping_of_boxes_section_fields.dart';
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

  final List<BoxInfo> _shippingOfBoxesSections = [const BoxInfo()];
  final List<FoodBoxType> _foodBoxTypes = [];

  @override
  void initState() {
    super.initState();

    _foodBoxRepository.getTypes().then((value) {
      setState(() {
        _foodBoxTypes.clear();
        _foodBoxTypes.addAll(value);
      });
    });
  }

  bool _somethingIsFilled() {
    return _shippingOfBoxesSections.any((shippingInfo) =>
        shippingInfo.foodBoxId != null || shippingInfo.numberOfBoxes != null);
  }

  Future<bool> _showConfirmationDialog() async {
    if (_somethingIsFilled()) {
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
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: WidgetStyle.padding,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      context.l10n!.shippingOfBoxesToCanteen,
                      style: const TextStyle(fontSize: FontSize.l),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      ShippingOfBoxesSectionFields(
                        shippingSections: _shippingOfBoxesSections,
                        boxTypes: _foodBoxTypes,
                      ),
                      ZOButton(
                        text: context.l10n!.addAnotherBoxType,
                        icon: MaterialSymbols.add,
                        type: ZOButtonType.secondary,
                        minimumSize: ZOButtonSize.medium(),
                        onPressed: () {
                          setState(() {
                            _shippingOfBoxesSections.add(const BoxInfo());
                          });
                        },
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
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onConfirmationButtonPressed() async {
    if (_formKey.currentState!.validate()) {
      if (await _verifyAvailableBoxCount()) {
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

    final requiredBoxes = <String, int>{};
    for (final boxInfo in _shippingOfBoxesSections) {
      final foodBoxId = boxInfo.foodBoxId;
      if (foodBoxId == null) {
        continue;
      }
      final required = boxInfo.numberOfBoxes ?? 0;
      requiredBoxes[foodBoxId] = (requiredBoxes[foodBoxId] ?? 0) + required;
    }

    final available = await _foodBoxRepository.verifyAvailableBoxCount(
      user: user,
      requiredBoxes: requiredBoxes,
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

    return _foodBoxRepository.createBoxDelivery(
      user: user,
      boxInfo: _shippingOfBoxesSections,
    );
  }
}
