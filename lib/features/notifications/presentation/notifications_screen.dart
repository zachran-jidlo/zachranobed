import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:zachranobed/common/domain/utils/date_time_utils.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/utils/helper_service.dart';
import 'package:zachranobed/common/presentation/utils/image_assets.dart';
import 'package:zachranobed/common/presentation/widget/page/error_page.dart';
import 'package:zachranobed/common/presentation/widget/page/info_page.dart';
import 'package:zachranobed/common/presentation/widget/page/loading_page.dart';
import 'package:zachranobed/common/presentation/widget/screen_scaffold.dart';
import 'package:zachranobed/common/presentation/widget/ui_app_bar.dart';
import 'package:zachranobed/common/presentation/widget/ui_list_tile.dart';
import 'package:zachranobed/features/notifications/domain/model/notification.dart' as domain;
import 'package:zachranobed/features/notifications/domain/usecase/mark_as_read_all_notifications_use_case.dart';
import 'package:zachranobed/features/notifications/domain/usecase/observe_notifications_use_case.dart';

/// A screen that displays a list of notifications.
class NotificationsScreen extends StatefulWidget {
  /// Creates a [NotificationsScreen].
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final _observeNotifications = GetIt.I<ObserveNotificationsUseCase>();
  final _markAsReadAllNotifications = GetIt.I<MarkAsReadAllNotificationsUseCase>();

  @override
  void initState() {
    super.initState();

    final user = HelperService.getCurrentUser(context);
    if (user != null) {
      _markAsReadAllNotifications.invoke(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = HelperService.watchCurrentUser(context);
    return ScreenScaffold.universalBuilder(
      appBar: UiAppBar(
        title: context.l10n.notificationsTitle,
      ),
      builder: (context) {
        return StreamBuilder<List<domain.Notification>>(
          stream: user != null ? _observeNotifications.invoke(user) : null,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingPage();
            }
            if (snapshot.hasError) {
              return ErrorPage();
            }
            final data = snapshot.data;
            if (data == null || data.isEmpty) {
              return InfoPage(
                image: ImageAssets.imageEmptyNotifications,
                title: context.l10n.notificationsEmptyTitle,
              );
            }
            return _notifications(data);
          },
        );
      },
    );
  }

  Widget _notifications(List<domain.Notification> notifications) {
    final todayNotifications = <domain.Notification>[];
    final otherNotifications = <domain.Notification>[];
    for (final notification in notifications) {
      if (DateTimeUtils.isToday(notification.timestamp)) {
        todayNotifications.add(notification);
      } else {
        otherNotifications.add(notification);
      }
    }

    final showHeaders = todayNotifications.isNotEmpty && otherNotifications.isNotEmpty;
    return CustomScrollView(
      slivers: showHeaders
          ? [
              _sectionHeader(
                context.l10n.commonToday,
                topPadding: 16.0,
              ),
              _notificationsSection(todayNotifications),
              _sectionHeader(
                context.l10n.notificationsLast7DaysTitle,
                topPadding: 8.0,
              ),
              _notificationsSection(otherNotifications),
            ]
          : [
              SliverToBoxAdapter(
                child: const SizedBox(height: 16.0),
              ),
              _notificationsSection(todayNotifications),
              _notificationsSection(otherNotifications),
            ],
    );
  }

  Widget _sectionHeader(String text, {required double topPadding}) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.only(
          top: topPadding,
          left: 16.0,
          right: 16.0,
          bottom: 8.0,
        ),
        child: Text(
          text,
          style: context.textStyles.titleMedium,
        ),
      ),
    );
  }

  Widget _notificationsSection(List<domain.Notification> notifications) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: notifications.length,
        (context, index) {
          final notification = notifications[index];
          return Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: 16.0,
            ),
            child: UiListTile(
              overline: _timeHeader(context, notification),
              title: notification.title,
              supportingText: notification.message,
            ),
          );
        },
      ),
    );
  }

  String _timeHeader(BuildContext context, domain.Notification notification) {
    final date = DateTimeUtils.isToday(notification.timestamp)
        ? context.l10n.commonToday
        : DateTimeUtils.formatDateTime(notification.timestamp, "d. M. yyyy");
    final time = DateTimeUtils.formatDateTime(notification.timestamp, "HH:mm");
    return "$date $time";
  }
}
