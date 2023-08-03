import 'package:auto_route/annotations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:provider/provider.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/models/donor.dart';
import 'package:zachranobed/models/recipient.dart';
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

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final _auth = FirebaseAuth.instance;
      final user = _auth.currentUser;
      final token = await user!.getIdTokenResult(false);
      final claims = token.claims;
      print(claims?.values);
      claims?.keys.forEach((claim) => print(claim));
      if (claims?["donor"] == true) {
        print("JSEM DÁRCE!");
      }
      if (claims?["recipient"] == true) {
        print("JSEM PŘÍJEMCE!");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: context.watch<DeliveryNotifier>().delivery != null ||
                HelperService.getCurrentUser(context) is Recipient
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
                    text: context.l10n!.overview),
                Tab(
                  icon: const Icon(MaterialSymbols.fastfood),
                  text: context.l10n!.donations,
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: HelperService.getCurrentUser(context) is Donor
            ? NewOfferFloatingButton(
                enabled: context
                    .watch<DeliveryNotifier>()
                    .deliveryConfirmed(context),
              )
            : null,
      ),
    );
  }
}
