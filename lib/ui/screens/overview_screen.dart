import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/common/helper_service.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/features/foodboxes/presentation/widget/box_data_table.dart';
import 'package:zachranobed/features/offeredfood/presentation/widget/card_list.dart';
import 'package:zachranobed/features/offeredfood/presentation/widget/donated_food_list.dart';
import 'package:zachranobed/models/canteen.dart';
import 'package:zachranobed/models/charity.dart';
import 'package:zachranobed/routes/app_router.gr.dart';
import 'package:zachranobed/ui/widgets/button.dart';
import 'package:zachranobed/ui/widgets/card_row.dart';
import 'package:zachranobed/ui/widgets/new_offer_floating_button.dart';
import 'package:zachranobed/ui/widgets/new_shipping_of_boxes_floating_button.dart';

import '../widgets/delivery_info_banner.dart';

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = HelperService.watchCurrentUser(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n!.overview),
        actions: [
          IconButton(
            onPressed: () {
              context.router.push(const MenuRoute());
            },
            icon: const Icon(Icons.person_outline),
          ),
        ],
      ),
      floatingActionButton: HelperService.getCurrentUser(context) is Canteen
          ? NewOfferFloatingButton()
          : const NewShippingOfBoxesFloatingButton(),
      body: CustomScrollView(
        slivers: [
          DeliveryInfoBanner(user: user!),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          SliverPadding(
            padding: const EdgeInsets.only(
              left: WidgetStyle.padding,
              right: WidgetStyle.padding,
              bottom: WidgetStyle.overviewBottomPadding,
            ),
            sliver: MultiSliver(
              children: [
                _buildActiveCanteen(context),
                CardList(user: user),
                const SizedBox(height: GapSize.m),
                BoxDataTable(user: user),
                const SizedBox(height: GapSize.m),
                _buildDonatedFoodList(context),
                const SizedBox(height: GapSize.xs),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDonatedFoodList(BuildContext context) {
    return DonatedFoodList(
      title: context.l10n!.lastDonated,
      itemsLimit: 5,
      alwaysShowTitle: false,
    );
  }

  Widget _buildActiveCanteen(BuildContext context) {
    final user = HelperService.watchCurrentUser(context);
    if (user is! Charity) {
      return const SizedBox();
    }
    return Column(
      children: [
        CardRow(
          label: context.l10n!.activePairCardCanteenLabel,
          title: user.activePair.donorEstablishmentName,
          action: (context) {
            if (!user.hasMultiplePairs) {
              return const SizedBox();
            }
            return ZOButton(
              text: context.l10n!.activePairCardChangeAction,
              type: ZOButtonType.secondary,
              height: 40.0,
              fullWidth: false,
              onPressed: () {
                context.router.push(const ChangeActivePairRoute());
              },
            );
          },
        ),
        const SizedBox(height: GapSize.xs),
      ],
    );
  }
}
