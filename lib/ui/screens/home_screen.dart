import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:provider/provider.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/firebase/notifications.dart';
import 'package:zachranobed/models/canteen.dart';
import 'package:zachranobed/notifiers/delivery_notifier.dart';
import 'package:zachranobed/notifiers/user_notifier.dart';
import 'package:zachranobed/services/helper_service.dart';
import 'package:zachranobed/ui/screens/boxes_screen.dart';
import 'package:zachranobed/ui/screens/donations_screen.dart';
import 'package:zachranobed/ui/screens/overview_screen.dart';
import 'package:zachranobed/ui/widgets/new_offer_floating_button.dart';
import 'package:zachranobed/ui/widgets/new_shipping_of_boxes_floating_button.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _screens = [
    OverviewScreen(),
    const DonationsScreen(),
    const BoxesScreen()
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (context.read<UserNotifier>().user == null) {
        await HelperService.loadUserInfo(context);
      }
      await Notifications().getFCMToken();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _screens.length,
      child: Scaffold(
        body: context.watch<DeliveryNotifier>().delivery != null
            ? TabBarView(children: _screens)
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
                    text: context.l10n!.overview),
                Tab(
                  icon: const Icon(MaterialSymbols.fastfood),
                  text: context.l10n!.donations,
                ),
                Tab(
                  icon: const Icon(Icons.takeout_dining_outlined),
                  text: context.l10n!.boxes,
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: HelperService.getCurrentUser(context) is Canteen
            ? NewOfferFloatingButton(
                enabled: context
                    .watch<DeliveryNotifier>()
                    .deliveryConfirmed(context),
              )
            : const NewShippingOfBoxesFloatingButton(),
      ),
    );
  }
}
