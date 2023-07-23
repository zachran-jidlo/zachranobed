import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:provider/provider.dart';
import 'package:zachranobed/notifiers/delivery_notifier.dart';
import 'package:zachranobed/notifiers/user_notifier.dart';
import 'package:zachranobed/services/helper_service.dart';
import 'package:zachranobed/shared/constants.dart';
import 'package:zachranobed/ui/screens/donations_screen.dart';
import 'package:zachranobed/ui/screens/overview_screen.dart';
import 'package:zachranobed/ui/widgets/new_offer_floating_button.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    if (context.read<UserNotifier>().user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await HelperService.loadUserInfo(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: context.watch<DeliveryNotifier>().delivery != null
            ? TabBarView(children: [OverviewScreen(), const DonationsScreen()])
            : const Center(child: CircularProgressIndicator()),
        bottomNavigationBar: SizedBox(
          height: 90.0,
          child: Material(
            color: ZOColors.primaryLight,
            child: TabBar(
              splashFactory: NoSplash.splashFactory,
              overlayColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                return states.contains(MaterialState.focused)
                    ? null
                    : Colors.transparent;
              }),
              unselectedLabelColor: ZOColors.onPrimaryLight,
              indicatorColor: Colors.transparent,
              tabs: [
                Tab(
                    icon: const Icon(Icons.home_outlined),
                    text: AppLocalizations.of(context)!.overview),
                Tab(
                  icon: const Icon(MaterialSymbols.fastfood),
                  text: AppLocalizations.of(context)!.donations,
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: NewOfferFloatingButton(
          enabled: context.watch<DeliveryNotifier>().deliveryConfirmed(context),
        ),
      ),
    );
  }
}
