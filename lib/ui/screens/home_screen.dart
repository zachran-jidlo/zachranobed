import 'dart:ui';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/common/helper_service.dart';
import 'package:zachranobed/common/lifecycle/lifecycle_watcher.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/features/foodboxes/presentation/screen/boxes_screen.dart';
import 'package:zachranobed/features/offeredfood/presentation/screens/donations_screen.dart';
import 'package:zachranobed/firebase/notifications.dart';
import 'package:zachranobed/notifiers/user_notifier.dart';
import 'package:zachranobed/routes/app_router.gr.dart';
import 'package:zachranobed/services/auth_service.dart';
import 'package:zachranobed/ui/screens/overview_screen.dart';
import 'package:zachranobed/ui/widgets/button.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with LifecycleWatcher {
  final _screens = [
    const OverviewScreen(),
    const DonationsScreen(),
    const BoxesScreen()
  ];

  bool _showLogoutButton = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (context.read<UserNotifier>().user == null) {
        await HelperService.loadUserInfo(context);
      }
      final notifications = Notifications();
      notifications.listenToTokenRefresh();
      await notifications.getFCMToken();
    });

    // Show logout button after 20 seconds if user is not loaded
    Future.delayed(const Duration(seconds: 20), () {
      if (mounted) {
        setState(() {
          _showLogoutButton = true;
        });
      }
    });
  }

  @override
  void onResume() {
    HelperService.loadUserInfo(context);
    super.onResume();
  }

  @override
  void didChangeViewFocus(ViewFocusEvent event) {
    // Do nothing
  }

  @override
  Widget build(BuildContext context) {
    final authService = GetIt.I<AuthService>();

    return DefaultTabController(
      length: _screens.length,
      child: Scaffold(
        body: context.watch<UserNotifier>().user != null
            ? TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: _screens,
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    if (_showLogoutButton)
                      Padding(
                        padding: const EdgeInsets.only(top: GapSize.m),
                        child: ZOButton(
                          text: context.l10n!.signOut,
                          fullWidth: false,
                          onPressed: () async {
                            await authService.signOut();
                            if (context.mounted) {
                              context.router.replaceAll([const LoginRoute()]);
                            }
                          },
                        ),
                      ),
                  ],
                ),
              ),
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
                  text: context.l10n!.food,
                ),
                Tab(
                  icon: customSvgIcon(ZOStrings.iconFoodBox),
                  text: context.l10n!.boxes,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget customSvgIcon(String resource) {
    return Builder(
      builder: (BuildContext context) {
        final iconTheme = IconTheme.of(context);
        return SvgPicture.asset(
          resource,
          width: iconTheme.size,
          height: iconTheme.size,
          colorFilter: ColorFilter.mode(
            iconTheme.color ?? Colors.transparent,
            BlendMode.srcIn,
          ),
        );
      },
    );
  }
}
