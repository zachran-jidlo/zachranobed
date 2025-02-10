import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
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
import 'package:zachranobed/ui/widgets/screen_scaffold.dart';
import 'package:zachranobed/ui/widgets/svg_icon.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with LifecycleWatcher, SingleTickerProviderStateMixin {
  /// The data for the tabs.
  final _tabs = [
    _TabScreenData(
      label: (context) => Text(context.l10n!.overview),
      icon: (context) => const Icon(Icons.home_outlined),
      content: (context) => const OverviewScreen(),
    ),
    _TabScreenData(
      label: (context) => Text(context.l10n!.food),
      icon: (context) => const Icon(Icons.fastfood_outlined),
      content: (context) => const DonationsScreen(),
    ),
    _TabScreenData(
      label: (context) => Text(context.l10n!.boxes),
      icon: (context) => const SvgIcon(resource: ZOStrings.iconFoodBox),
      content: (context) => const BoxesScreen(),
    )
  ];

  /// The controller, which is used to sync state between TabBar and
  /// NavigationDrawer.
  late TabController _tabController;

  /// The index of the currently selected tab.
  late int _selectedIndex;

  /// Whether to show the logout button.
  bool _showLogoutButton = false;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(vsync: this, length: _tabs.length);
    _selectedIndex = _tabController.index;

    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });

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
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void onResume() {
    HelperService.loadUserInfo(context);
    super.onResume();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      centerWebLayout: false,
      web: (context) {
        return Row(
          children: [
            NavigationDrawer(
              indicatorColor: ZOColors.secondary,
              onDestinationSelected: (i) {
                _tabController.animateTo(i);
              },
              selectedIndex: _selectedIndex,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 42, 40, 52),
                  child: SvgPicture.asset(ZOStrings.zoLogoPath, width: 180),
                ),
                ..._tabs.map(
                  (data) {
                    return NavigationDrawerDestination(
                      label: DefaultTextStyle.merge(
                        style: const TextStyle(
                          color: ZOColors.onSecondary,
                        ),
                        child: data.label(context),
                      ),
                      icon: IconTheme.merge(
                        data: const IconThemeData(
                          size: 24.0,
                          color: ZOColors.onSecondary,
                        ),
                        child: data.icon(context),
                      ),
                    );
                  },
                ),
              ],
            ),
            Expanded(
              child: Center(
                child: SizedBox(
                    width: LayoutStyle.webBreakpoint.toDouble(),
                    child: _homeScreenContent()),
              ),
            ),
          ],
        );
      },
      mobile: (context) {
        return ScaffoldMessenger(
          child: Scaffold(
            body: _homeScreenContent(),
            bottomNavigationBar: SizedBox(
              height: 90.0,
              child: Material(
                color: ZOColors.primaryLight,
                child: TabBar(
                  controller: _tabController,
                  splashFactory: NoSplash.splashFactory,
                  overlayColor: WidgetStateProperty.resolveWith<Color?>(
                      (Set<WidgetState> states) {
                    return states.contains(WidgetState.focused)
                        ? null
                        : Colors.transparent;
                  }),
                  unselectedLabelColor: ZOColors.onPrimaryLight,
                  indicatorColor: Colors.transparent,
                  tabs: _tabs.map((data) {
                    return Tab(
                      icon: data.icon(context),
                      child: data.label(context),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _homeScreenContent() {
    if (context.watch<UserNotifier>().user == null) {
      final authService = GetIt.I<AuthService>();
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            if (_showLogoutButton)
              Padding(
                padding: const EdgeInsets.only(top: GapSize.m),
                child: ZOButton(
                  text: context.l10n!.signOut,
                  minimumSize: ZOButtonSize.tiny(),
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
      );
    }

    return TabBarView(
      controller: _tabController,
      physics: const NeverScrollableScrollPhysics(),
      children: _tabs.map((data) => data.content(context)).toList(),
    );
  }
}

/// Wrapper class for a single screen.
class _TabScreenData {
  /// The builder for the label in TabBar or NavigationDrawer.
  WidgetBuilder label;

  /// The builder for the icon in TabBar or NavigationDrawer.
  WidgetBuilder icon;

  /// The builder for the screen content.
  WidgetBuilder content;

  /// Creates a new [_TabScreenData] object.
  _TabScreenData({
    required this.label,
    required this.icon,
    required this.content,
  });
}
