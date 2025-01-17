import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/features/foodboxes/domain/model/food_box_type.dart';
import 'package:zachranobed/features/foodboxes/domain/repository/food_box_repository.dart';
import 'package:zachranobed/features/offeredfood/domain/model/food_info.dart';
import 'package:zachranobed/routes/app_router.gr.dart';
import 'package:zachranobed/ui/widgets/button.dart';
import 'package:zachranobed/ui/widgets/dialog.dart';
import 'package:zachranobed/ui/widgets/food_info_fields.dart';
import 'package:zachranobed/ui/widgets/form/form_validation_manager.dart';
import 'package:zachranobed/ui/widgets/screen_scaffold.dart';
import 'package:zachranobed/ui/widgets/snackbar/temporary_snackbar.dart';

@RoutePage()
class OfferFoodDetailScreen extends StatefulWidget {
  final FoodInfo editedFoodInfo;
  final List<FoodInfo> allFoodInfos;

  const OfferFoodDetailScreen({
    super.key,
    required this.editedFoodInfo,
    required this.allFoodInfos,
  });

  @override
  State<OfferFoodDetailScreen> createState() => _OfferFoodDetailScreenState();
}

class _OfferFoodDetailScreenState extends State<OfferFoodDetailScreen> {
  late FoodInfo _foodInfoPending;

  final _foodBoxRepository = GetIt.I<FoodBoxRepository>();
  final _formValidationManager = FormValidationManager();
  final _formKey = GlobalKey<FormState>();
  final List<FoodBoxType> _foodBoxTypes = [];

  @override
  void initState() {
    super.initState();

    _foodInfoPending = widget.editedFoodInfo;

    _foodBoxRepository.getTypes(includeDisposable: true).then((value) {
      setState(() {
        _foodBoxTypes.clear();
        _foodBoxTypes.addAll(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      web: (context) => _offerFoodDetailScreenContent(
        actionButtonsAxis: Axis.horizontal,
      ),
      mobile: (context) => _offerFoodDetailScreenContent(
        actionButtonsAxis: Axis.vertical,
      ),
    );
  }

  /// Builds the content of the offer food detail screen.
  ///
  /// The [actionButtonsAxis] parameter determines direction of the action
  /// buttons.
  Widget _offerFoodDetailScreenContent({
    required Axis actionButtonsAxis,
  }) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(WidgetStyle.padding),
              alignment: Alignment.centerLeft,
              child: Text(
                context.l10n!.offerFoodDetailScreenTitle,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.left,
                overflow: TextOverflow.clip,
              ),
            ),
            const SizedBox(height: GapSize.m),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: WidgetStyle.padding,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    FoodInfoFields(
                      formValidationManager: _formValidationManager,
                      foodInfo: _foodInfoPending,
                      boxTypes: _foodBoxTypes,
                      onChanged: (food) {
                        setState(() {
                          _foodInfoPending = food;
                        });
                      },
                    ),
                    const SizedBox(height: GapSize.m),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Flex(
                        direction: actionButtonsAxis,
                        mainAxisAlignment: actionButtonsAxis == Axis.vertical
                            ? MainAxisAlignment.start
                            : MainAxisAlignment.spaceBetween,
                        children: [
                          ZOButton(
                            icon: Icons.check,
                            text: context.l10n!.offerFoodDetailSaveButton,
                            minimumSize: ZOButtonSize.large(
                              fullWidth: actionButtonsAxis == Axis.vertical,
                            ),
                            onPressed: _onConfirmationButtonPressed,
                          ),
                          const SizedBox.square(dimension: GapSize.xs),
                          ZOButton(
                            icon: Icons.delete_outlined,
                            text: context.l10n!.offerFoodDetailRemoveButton,
                            type: ZOButtonType.tertiary,
                            minimumSize: ZOButtonSize.large(
                              fullWidth: actionButtonsAxis == Axis.vertical,
                            ),
                            onPressed: () => _onRemoveFoodPressed(false),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: GapSize.l),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onConfirmationButtonPressed() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final index = widget.allFoodInfos.indexWhere(
      (element) => element.id == _foodInfoPending.id,
    );
    if (index > -1) {
      widget.allFoodInfos[index] = _foodInfoPending;
    }

    if (_formKey.currentState!.validate()) {
      if (await widget.allFoodInfos
          .verifyAvailableBoxCount(context, _foodBoxRepository)) {
        if (mounted) {
          Navigator.pop(context);
          context.router
              .replace(OfferFoodOverviewRoute(foodInfos: widget.allFoodInfos));
        }
      } else {
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            ZOTemporarySnackBar(
              backgroundColor: Colors.red,
              message: context.l10n!.boxCountError,
            ),
          );
        }
      }
    } else {
      if (mounted) {
        Navigator.pop(context);
        _formValidationManager.scrollToFirstError();
      }
    }
  }

  void _onRemoveFoodPressed(bool removeConfirmed) {
    if (!removeConfirmed) {
      showDialog(
        context: context,
        builder: (context) {
          return ZODialog(
            criticalConfirmStyle: true,
            title: context.l10n!.offerFoodFormRemoveDialogTitle,
            content: context.l10n!.offerFoodFormRemoveDialogContent,
            confirmText: context.l10n!.offerFoodFormRemoveDialogConfirmAction,
            cancelText: context.l10n!.commonCancel,
            onConfirmPressed: () {
              Navigator.of(context).pop(false);
              _onRemoveFoodPressed(true);
            },
            onCancelPressed: () => Navigator.of(context).pop(false),
          );
        },
      );
      return;
    }

    widget.allFoodInfos.removeWhere(
      (element) => element.id == _foodInfoPending.id,
    );

    Navigator.pop(context);
    context.router
        .replace(OfferFoodOverviewRoute(foodInfos: widget.allFoodInfos));
  }
}
