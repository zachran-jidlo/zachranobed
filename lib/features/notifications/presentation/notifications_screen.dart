import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/common/helper_service.dart';
import 'package:zachranobed/common/utils/date_time_utils.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/features/notifications/domain/model/notification.dart' as domain;
import 'package:zachranobed/features/notifications/domain/usecase/mark_as_read_all_notifications_use_case.dart';
import 'package:zachranobed/features/notifications/domain/usecase/observe_notifications_use_case.dart';
import 'package:zachranobed/ui/widgets/empty_page.dart';
import 'package:zachranobed/ui/widgets/error_content.dart';
import 'package:zachranobed/ui/widgets/screen_scaffold.dart';

/// A screen that displays a list of notifications.
@RoutePage()
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
      builder: (context) => Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(
                left: WidgetStyle.padding,
                right: WidgetStyle.padding,
                bottom: WidgetStyle.padding,
              ),
              alignment: Alignment.centerLeft,
              child: Text(
                context.l10n!.notificationsTitle,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.left,
                overflow: TextOverflow.clip,
              ),
            ),
            Expanded(
              child: StreamBuilder<List<domain.Notification>>(
                stream: user != null ? _observeNotifications.invoke(user) : null,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _loading();
                  }
                  if (snapshot.hasError) {
                    return _error(context);
                  }
                  final data = snapshot.data;
                  if (data == null || data.isEmpty) {
                    return _empty(context);
                  }
                  return _notifications(data);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _loading() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _error(BuildContext context) {
    return const SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(WidgetStyle.padding),
        child: ErrorContent(onRetryPressed: null),
      ),
    );
  }

  Widget _empty(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(WidgetStyle.padding),
        child: EmptyPage(
          vectorImagePath: ZOStrings.notificationsEmptyPath,
          title: context.l10n!.notificationsEmptyTitle,
        ),
      ),
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
      slivers: [
        if (showHeaders)
          _sectionHeader(
            context.l10n!.commonToday,
            hasTopPadding: false,
          ),
        _notificationsSection(todayNotifications),
        if (showHeaders)
          _sectionHeader(
            context.l10n!.notificationsLast7DaysTitle,
            hasTopPadding: true,
          ),
        _notificationsSection(otherNotifications),
      ],
    );
  }

  Widget _sectionHeader(String text, {required bool hasTopPadding}) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.only(
          top: hasTopPadding ? 16.0 : 0.0,
          left: 16.0,
          right: 16.0,
          bottom: 16.0,
        ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }

  Widget _notificationsSection(List<domain.Notification> notifications) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: notifications.length,
        (context, index) => Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: 16.0,
          ),
          child: _NotificationRow(notification: notifications[index]),
        ),
      ),
    );
  }
}

class _NotificationRow extends StatelessWidget {
  final domain.Notification notification;

  const _NotificationRow({required this.notification});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: ZOColors.borderColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _timeHeader(context),
            Text(
              notification.title,
              style: textTheme.bodyLarge?.copyWith(color: ZOColors.onSurface),
            ),
          ],
        ),
        subtitle: Text(
          notification.message,
          style: textTheme.bodyMedium?.copyWith(color: ZOColors.onPrimaryLight),
        ),
      ),
    );
  }

  Widget _timeHeader(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final textStyle = textTheme.bodyMedium?.copyWith(
      color: ZOColors.onPrimaryLight,
      fontStyle: FontStyle.italic,
    );
    final date = DateTimeUtils.isToday(notification.timestamp)
        ? context.l10n!.commonToday
        : DateTimeUtils.formatDateTime(notification.timestamp, "d. M. yyyy");
    final time = DateTimeUtils.formatDateTime(notification.timestamp, "HH:mm");

    return Row(
      children: [
        Text(date, style: textStyle),
        Padding(
          padding: const EdgeInsets.all(4),
          child: Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: ZOColors.secondary,
              shape: BoxShape.circle,
            ),
          ),
        ),
        Text(time, style: textStyle),
      ],
    );
  }
}
