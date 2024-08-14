import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/common/logger/zo_logger.dart';
import 'package:zachranobed/common/utils/iterable_utils.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/features/foodboxes/domain/model/food_box_type.dart';
import 'package:zachranobed/features/foodboxes/domain/repository/food_box_repository.dart';
import 'package:zachranobed/features/offeredfood/domain/model/food_info.dart';
import 'package:zachranobed/features/offeredfood/domain/repository/offered_food_repository.dart';
import 'package:zachranobed/notifiers/delivery_notifier.dart';
import 'package:zachranobed/routes/app_router.gr.dart';
import 'package:zachranobed/ui/widgets/button.dart';
import 'package:zachranobed/ui/widgets/info_text_banner.dart';
import 'package:zachranobed/ui/widgets/snackbar/temporary_snackbar.dart';
import 'package:zachranobed/ui/widgets/trailing_icon_row.dart';

@RoutePage()
class OfferFoodOverviewScreen extends StatefulWidget {
  final List<FoodInfo> foodInfos;

  const OfferFoodOverviewScreen({
    super.key,
    required this.foodInfos,
  });

  @override
  State<OfferFoodOverviewScreen> createState() =>
      _OfferFoodOverviewScreenState();
}

class _OfferFoodOverviewScreenState extends State<OfferFoodOverviewScreen> {
  late List<FoodInfo> foodInfos;
  final _offeredFoodRepository = GetIt.I<OfferedFoodRepository>();
  final _foodBoxRepository = GetIt.I<FoodBoxRepository>();
  final _foodBoxTypes = <FoodBoxType>[];

  @override
  void initState() {
    super.initState();
    foodInfos = widget.foodInfos;
    ZOLogger.logMessage("OfferFoodOverviewScreen: $foodInfos");

    _foodBoxRepository.getTypes().then((value) {
      setState(() {
        _foodBoxTypes.clear();
        _foodBoxTypes.addAll(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(children: [
          Container(
            padding: const EdgeInsets.all(WidgetStyle.padding),
            alignment: Alignment.centerLeft,
            child: Text(
              context.l10n!.offerFoodOverviewScreenTitle,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.left,
              overflow: TextOverflow.clip,
            ),
          ),
          InfoTextBanner(message: context.l10n!.offerFoodOverviewBanner),
          const SizedBox(height: GapSize.m),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: WidgetStyle.padding,
            ),
            child: Column(children: [
              _offerFoodListSection(context,
                  foodInfos: foodInfos, foodBoxTypes: _foodBoxTypes),
              const SizedBox(height: GapSize.m),
              ZOButton(
                  text: context.l10n!.offerFood,
                  onPressed: () async {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) =>
                          const Center(child: CircularProgressIndicator()),
                    );

                    if (await foodInfos.verifyAvailableBoxCount(
                        context, _foodBoxRepository)) {
                      final isSuccess = await _offerFood();
                      if (context.mounted) {
                        context.router.replace(ThankYouRoute(
                          isSuccess: isSuccess,
                          message: context.l10n!.foodDonationConfirmation,
                        ));
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
                  })
            ]),
          )
        ]));
  }

  Future<bool> _offerFood() async {
    final delivery = context.read<DeliveryNotifier>().delivery;
    if (delivery == null) {
      return false;
    }
    return _offeredFoodRepository.createOffer(
      delivery: delivery,
      foodInfo: foodInfos,
    );
  }
}

/// Builds a section within offer food list.
Widget _offerFoodListSection(
  BuildContext context, {
  required List<FoodInfo> foodInfos,
  required List<FoodBoxType> foodBoxTypes,
}) {
  if (foodInfos.isEmpty) {
    return const SizedBox();
  }
  return OfferFoodOverviewSection(
    items: foodInfos
        .mapIndexed((index, food) {
          return TrailingIconRow(
              title: food.dishName.toString(),
              description:
                  "${food.numberOfBoxes ?? food.numberOfServings}x ${foodBoxTypes.getById(food.foodBoxId ?? "")?.name}",
              trailInfo: "${food.numberOfServings} ks",
              trailingIcon: Icons.edit,
              onTap: () {
                context.router.navigate(OfferFoodDetailRoute(
                    editedFoodInfo: food, allFoodInfos: foodInfos));
              });
        })
        .separated(const SizedBox(height: 8.0))
        .toList(),
  );
}

class OfferFoodOverviewSection extends StatelessWidget {
  final List<Widget> items;

  const OfferFoodOverviewSection({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var item in items) item,
        const SizedBox(height: GapSize.m),
      ],
    );
  }
}
