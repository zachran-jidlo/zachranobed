import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:get_it/get_it.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/common/helper_service.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/models/box_movement.dart';
import 'package:zachranobed/models/charity.dart';
import 'package:zachranobed/models/shipping_of_boxes.dart';
import 'package:zachranobed/routes/app_router.gr.dart';
import 'package:zachranobed/services/box_movement_srvice.dart';
import 'package:zachranobed/services/box_service.dart';
import 'package:zachranobed/services/shipping_of_boxes_service.dart';
import 'package:zachranobed/ui/widgets/button.dart';
import 'package:zachranobed/ui/widgets/dialog.dart';
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
  final _shippingOfBoxesService = GetIt.I<ShippingOfBoxesService>();
  final _boxMovementService = GetIt.I<BoxMovementService>();
  final _boxService = GetIt.I<BoxService>();

  DocumentReference<BoxMovement>? _futureResponse;

  final _formKey = GlobalKey<FormState>();

  final List<BoxMovement> _shippingOfBoxesSections = [const BoxMovement()];

  bool _somethingIsFilled() {
    return _shippingOfBoxesSections.any((shippingInfo) =>
        shippingInfo.boxType != null || shippingInfo.numberOfBoxes != null);
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
                      ),
                      ZOButton(
                        text: context.l10n!.addAnotherBoxType,
                        icon: MaterialSymbols.add,
                        type: ZOButtonType.secondary,
                        height: 40.0,
                        onPressed: () {
                          setState(() {
                            _shippingOfBoxesSections.add(
                              const BoxMovement(),
                            );
                          });
                        },
                      ),
                      const SizedBox(height: GapSize.xxl),
                      ZOButton(
                        text: context.l10n!.orderShipping,
                        icon: MaterialSymbols.check,
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if (await _verifyAvailableBoxCount()) {
                              _futureResponse = await _orderShipping();
                              if (mounted) {
                                context.router.replace(
                                  ThankYouRoute(
                                    response: _futureResponse,
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
                        },
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

  Future<bool> _verifyAvailableBoxCount() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final charity = HelperService.getCurrentUser(context) as Charity;
    for (var shippingInfo in _shippingOfBoxesSections) {
      final isAvailable = await _boxService.verifyAvailableBoxCount(
        numberOfBoxes: shippingInfo.numberOfBoxes!,
        boxType: shippingInfo.boxType!,
        establishmentId: charity.establishmentId,
      );
      if (!isAvailable) {
        if (mounted) {
          context.router.pop();
        }
        return false;
      }
    }
    return true;
  }

  Future<DocumentReference<BoxMovement>?> _orderShipping() async {
    DocumentReference<BoxMovement>? response;
    final charity = HelperService.getCurrentUser(context) as Charity;
    final now = DateTime.now();
    for (var shippingInfo in _shippingOfBoxesSections) {
      response = await _boxMovementService.addBoxMovement(
        BoxMovement(
          senderId: charity.establishmentId,
          recipientId: charity.donorId![0],
          boxType: shippingInfo.boxType,
          numberOfBoxes: shippingInfo.numberOfBoxes,
          date: now,
          weekNumber: '${now.year}-${HelperService.getCurrentWeekNumber}',
        ),
      );
    }
    await _shippingOfBoxesService.createShippingOfBoxes(
      ShippingOfBoxes(
        charityId: charity.establishmentId,
        canteenId: charity.donorId![0],
        date: DateTime.now(),
      ),
    );

    return response;
  }
}
