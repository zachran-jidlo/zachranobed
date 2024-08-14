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
import 'package:zachranobed/ui/widgets/clickable_text.dart';
import 'package:zachranobed/ui/widgets/food_section_fields.dart';
import 'package:zachranobed/ui/widgets/form/form_validation_manager.dart';
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
  late FoodInfo foodInfo;
  late List<FoodInfo> allFoodInfos;
  final _foodBoxRepository = GetIt.I<FoodBoxRepository>();
  final _formValidationManager = FormValidationManager();
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _consumeByControllers = [
    TextEditingController()
  ];
  final List<bool> _checkboxValues = [true];
  final List<FoodBoxType> _foodBoxTypes = [];

  @override
  void initState() {
    super.initState();
    foodInfo = widget.editedFoodInfo;
    allFoodInfos = widget.allFoodInfos;

    _foodBoxRepository.getTypes(includeDisposable: true).then((value) {
      setState(() {
        _foodBoxTypes.clear();
        _foodBoxTypes.addAll(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final foodSections = <FoodInfo>[foodInfo];

    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
            child: Column(children: [
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
                child: Column(children: [
                  FoodSectionFields(
                      formValidationManager: _formValidationManager,
                      foodSections: foodSections,
                      controllers: _consumeByControllers,
                      checkboxValues: _checkboxValues,
                      boxTypes: _foodBoxTypes),
                  const SizedBox(height: GapSize.m),
                  ZOButton(
                    text: context.l10n!.offerFoodDetailSaveButton,
                    onPressed: () async {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) =>
                            const Center(child: CircularProgressIndicator()),
                      );

                      int index = allFoodInfos
                          .indexWhere((element) => element.id == foodInfo.id);
                      if (index > -1) {
                        allFoodInfos[index] = foodSections.first;
                      }

                      if (_formKey.currentState!.validate()) {
                        if (await allFoodInfos.verifyAvailableBoxCount(
                            context, _foodBoxRepository)) {
                          if (context.mounted) {
                            Navigator.pop(context);
                            context.router.replace(OfferFoodOverviewRoute(
                                foodInfos: allFoodInfos));
                          }
                        } else {
                          if (context.mounted) {
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
                    },
                  ),
                  const SizedBox(height: GapSize.l),
                  ZOClickableText(
                      clickableText: context.l10n!.cancel,
                      underline: false,
                      color: ZOColors.primary,
                      onTap: () {
                        context.back();
                      }),
                  const SizedBox(height: GapSize.l),
                ]),
              ))
        ])));
  }
}
