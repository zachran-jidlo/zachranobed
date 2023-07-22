import 'package:flutter/material.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:zachranobed/notifiers/delivery_notifier.dart';
import 'package:zachranobed/notifiers/user_notifier.dart';
import 'package:zachranobed/services/auth_service.dart';
import 'package:zachranobed/services/delivery_service.dart';
import 'package:zachranobed/services/helper_service.dart';
import 'package:zachranobed/shared/constants.dart';
import 'package:zachranobed/ui/screens/donations.dart';
import 'package:zachranobed/ui/screens/overview.dart';
import 'package:zachranobed/ui/widgets/new_offer_floating_button.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _authService = GetIt.I<AuthService>();
  final _deliveryService = GetIt.I<DeliveryService>();

  _loadUserInfo() async {
    final user = await _authService.getUserData();
    if (mounted) {
      final userNotifier = Provider.of<UserNotifier>(context, listen: false);
      userNotifier.user = user;

      final date = HelperService.getDateTimeOfCurrentDelivery(user!.pickUpFrom);

      final deliveryNotifier =
          Provider.of<DeliveryNotifier>(context, listen: false);
      deliveryNotifier.delivery = await _deliveryService.getDelivery(
        date,
        user.establishmentName,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadUserInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: context.watch<DeliveryNotifier>().delivery != null
            ? TabBarView(children: [Overview(), const Donations()])
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
              tabs: const [
                Tab(icon: Icon(Icons.home_outlined), text: ZOStrings.overview),
                Tab(
                  icon: Icon(MaterialSymbols.fastfood),
                  text: ZOStrings.donations,
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: NewOfferFloatingButton(
          enabled: context.watch<DeliveryNotifier>().deliveryConfirmed(),
        ),
      ),
    );
  }
}
