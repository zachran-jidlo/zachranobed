import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:zachranobed/app/presentation/overview_screen.dart';
import 'package:zachranobed/common/domain/usecase/sign_out_usecase.dart';
import 'package:zachranobed/common/presentation/notifiers/user_notifier.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/utils/helper_service.dart';
import 'package:zachranobed/common/presentation/utils/image_assets.dart';
import 'package:zachranobed/common/presentation/utils/lifecycle_watcher.dart';
import 'package:zachranobed/common/presentation/utils/ui_constants.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_primary_button.dart';
import 'package:zachranobed/common/presentation/widget/graphics/ui_icon.dart';
import 'package:zachranobed/common/presentation/widget/layout/screen_scaffold.dart';
import 'package:zachranobed/common/presentation/widget/navigation/ui_nav_bar.dart';
import 'package:zachranobed/common/presentation/widget/navigation/ui_navigation_drawer_item.dart';
import 'package:zachranobed/features/faq/presentation/screen/faq_screen.dart';
import 'package:zachranobed/features/food/presentation/screens/history_screen.dart';
import 'package:zachranobed/features/notifications/domain/usecase/has_any_unread_notifications_use_case.dart';
import 'package:zachranobed/features/notifications/domain/usecase/update_notifications_token_use_case.dart';
import 'package:zachranobed/features/notifications/presentation/notifications_screen.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  final int initialTabIndex;

  const HomeScreen({super.key, this.initialTabIndex = 0});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with LifecycleWatcher, SingleTickerProviderStateMixin {
  final _updateNotificationsTokenUseCase = GetIt.I<UpdateNotificationsTokenUseCase>();

  /// The data for the tabs.
  final _tabs = [
    _TabScreenData(
      label: (context) => context.l10n.navigationLabelOverview,
      iconSpec: const UiIconSpec.data(Icons.home),
      content: (context) => const OverviewScreen(),
    ),
    _TabScreenData(
      label: (context) => context.l10n.navigationLabelFaq,
      iconSpec: const UiIconSpec.data(Icons.menu_book),
      content: (context) => const FaqScreen(),
    ),
    _TabScreenData(
      label: (context) => context.l10n.navigationLabelHistory,
      iconSpec: const UiIconSpec.svg(ImageAssets.iconHistory),
      content: (context) => const HistoryScreen(),
    ),
    _TabScreenData(
      label: (context) => context.l10n.navigationLabelNotifications,
      iconSpec: const UiIconSpec.data(Icons.notifications),
      content: (context) => const NotificationsScreen(),
      showIndicator: (context) {
        final user = HelperService.watchCurrentUser(context);
        final hasAnyUnreadNotifications = GetIt.I<HasAnyUnreadNotificationsUseCase>();
        return user != null ? hasAnyUnreadNotifications.invoke(user) : Stream.value(false);
      },
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

    _tabController = TabController(
      vsync: this,
      length: _tabs.length,
      initialIndex: widget.initialTabIndex,
    );
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

      _updateNotificationsTokenUseCase.invoke();
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
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialTabIndex != oldWidget.initialTabIndex) {
      _tabController.animateTo(widget.initialTabIndex);
    }
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
      systemNavigationBarColor: context.uiColors.surfaceWhite,
      web: (context) {
        return Row(
          children: [
            Material(
              color: context.uiColors.surfaceWhite,
              elevation: 12.0,
              child: SizedBox(
                width: LayoutStyle.navigationDrawerSize.toDouble(),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 42, 40, 40),
                      child: SvgPicture.asset(ImageAssets.imageLogo, width: 180),
                    ),
                    ..._tabs.mapIndexed(
                      (index, data) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: StreamBuilder(
                            stream: data.showIndicator?.call(context),
                            builder: (context, snapshot) {
                              return UiNavigationDrawerItem(
                                icon: data.iconSpec,
                                label: data.label(context),
                                selected: index == _selectedIndex,
                                showIndicator: snapshot.data == true,
                                onPressed: () {
                                  _tabController.animateTo(index);
                                },
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: SizedBox(width: LayoutStyle.webBreakpoint.toDouble(), child: _homeScreenContent()),
              ),
            ),
          ],
        );
      },
      mobile: (context) {
        return ScaffoldMessenger(
          child: Scaffold(
            body: _homeScreenContent(),
            bottomNavigationBar: UiNavBar(
              controller: _tabController,
              items: _tabs.map((data) {
                return StreamBuilder(
                  stream: data.showIndicator?.call(context),
                  builder: (context, snapshot) {
                    return UiNavBarItem(
                      icon: data.iconSpec,
                      label: data.label(context),
                      showIndicator: snapshot.data == true,
                    );
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _homeScreenContent() {
    if (context.watch<UserNotifier>().user == null) {
      final signOut = GetIt.I<SignOutUseCase>();
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            if (_showLogoutButton)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: UiPrimaryButton(
                  text: context.l10n.signOut,
                  onPressed: () async {
                    final entityId = HelperService.getCurrentUser(context)?.entityId;
                    await signOut.invoke(entityId);
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

class _TabScreenData {
  final String Function(BuildContext) label;
  final UiIconSpec iconSpec;
  final WidgetBuilder content;
  final Stream<bool> Function(BuildContext)? showIndicator;

  _TabScreenData({
    required this.label,
    required this.iconSpec,
    required this.content,
    this.showIndicator,
  });
}
