import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:intl/intl.dart";
import "package:notification_workflow/src/features/notifications/models/notification.dart";
import "package:notification_workflow/src/localization/app_localizations.dart";
import "package:notification_workflow/src/routing/router.dart";

class NotificationListView extends StatelessWidget {
  const NotificationListView({required this.notifications, super.key});

  final List<NotificationModel> notifications;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    if (notifications.isEmpty) {
      return Center(
        child: Text(localizations.notificationOverviewNoNotifications),
      );
    }

    final sorted = [...notifications]
      ..sort((a, b) => b.created.compareTo(a.created));
    final grouped = <_DateGroup, List<NotificationModel>>{
      _DateGroup.today: [],
      _DateGroup.yesterday: [],
      _DateGroup.earlier: [],
    };
    for (final notification in sorted) {
      grouped[_dateGroupFor(notification.created)]!.add(notification);
    }

    final items = <Widget>[];
    for (final group in _DateGroup.values) {
      final groupItems = grouped[group]!;
      if (groupItems.isEmpty) continue;
      items.add(
        _GroupHeader(label: _dateGroupLabel(group, localizations)),
      );
      for (final notification in groupItems) {
        items.add(_TimeLabel(time: notification.created));
        items.add(_NotificationCard(notification: notification));
      }
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      children: items,
    );
  }
}

class _GroupHeader extends StatelessWidget {
  const _GroupHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 16, bottom: 4),
    child: Text(
      label,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
    ),
  );
}

class _TimeLabel extends StatelessWidget {
  const _TimeLabel({required this.time});

  final DateTime time;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 8),
    child: Text(
      DateFormat.Hm().format(time),
      style: Theme.of(
        context,
      ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
    ),
  );
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({required this.notification});

  final NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final priorityColor = _priorityColor(notification.priority);
    final icon = _priorityIcon(notification.priority);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(routeNotificationDetailFor(notification.id)),
        child: Container(
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: priorityColor, width: 6)),
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(
                icon,
                color: priorityColor,
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // TODO(freek): add logo of organization
                        Icon(
                          Icons.label_outline,
                          size: 18,
                          color: Colors.grey.shade500,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.description,
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right, color: Colors.grey.shade500),
            ],
          ),
        ),
      ),
    );
  }
}

enum _DateGroup { today, yesterday, earlier }

_DateGroup _dateGroupFor(DateTime created) {
  final now = DateTime.now();
  final startOfToday = DateTime(now.year, now.month, now.day);
  final createdDay = DateTime(created.year, created.month, created.day);
  final diff = startOfToday.difference(createdDay).inDays;
  if (diff <= 0) return _DateGroup.today;
  if (diff == 1) return _DateGroup.yesterday;
  return _DateGroup.earlier;
}

String _dateGroupLabel(_DateGroup group, AppLocalizations localizations) =>
    switch (group) {
      _DateGroup.today => localizations.dateToday,
      _DateGroup.yesterday => localizations.dateYesterday,
      _DateGroup.earlier => localizations.dateEarlier,
    };

Color _priorityColor(NotificationPriority priority) => switch (priority) {
  NotificationPriority.low => Colors.green,
  NotificationPriority.medium => Colors.amber,
  NotificationPriority.high => Colors.red,
};

IconData _priorityIcon(NotificationPriority priority) => switch (priority) {
  NotificationPriority.low => Icons.notifications_outlined,
  NotificationPriority.medium => Icons.notifications_active_outlined,
  NotificationPriority.high => Icons.notification_important_outlined,
};
