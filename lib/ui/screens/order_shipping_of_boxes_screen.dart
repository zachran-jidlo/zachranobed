import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:get_it/get_it.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/models/charity.dart';
import 'package:zachranobed/models/shipping_of_boxes.dart';
import 'package:zachranobed/routes/app_router.gr.dart';
import 'package:zachranobed/services/helper_service.dart';
import 'package:zachranobed/services/shipping_of_boxes_service.dart';
import 'package:zachranobed/shared/constants.dart';
import 'package:zachranobed/ui/widgets/button.dart';
import 'package:zachranobed/ui/widgets/dialog.dart';
import 'package:zachranobed/ui/widgets/shipping_of_boxes_section_fields.dart';

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

  DocumentReference<ShippingOfBoxes>? _futureResponse;

  final _formKey = GlobalKey<FormState>();

  final List<ShippingOfBoxes> _shippingOfBoxesSections = [
    const ShippingOfBoxes()
  ];

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
              icon: Icons.delete_outline,
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
                        isSecondary: true,
                        height: 40.0,
                        onPressed: () {
                          setState(() {
                            _shippingOfBoxesSections.add(
                              const ShippingOfBoxes(),
                            );
                          });
                        },
                      ),
                      const SizedBox(height: GapSize.xl),
                      ZOButton(
                        text: context.l10n!.orderShipping,
                        icon: MaterialSymbols.check,
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _futureResponse = await _orderShipping();
                            if (mounted) {
                              context.router.replace(ThankYouRoute(
                                response: _futureResponse,
                                message:
                                    context.l10n!.shippingOrderConfirmation,
                              ));
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

  Future<DocumentReference<ShippingOfBoxes>> _orderShipping() async {
    var response = null;
    final charity = HelperService.getCurrentUser(context) as Charity;
    for (var shippingInfo in _shippingOfBoxesSections) {
      response = await _shippingOfBoxesService.createShippingOfBoxes(
        ShippingOfBoxes(
          charityId: charity.establishmentId,
          canteenId: charity.donor!.establishmentId,
          boxType: shippingInfo.boxType,
          numberOfBoxes: shippingInfo.numberOfBoxes,
        ),
      );
    }
    return response;
  }
}
