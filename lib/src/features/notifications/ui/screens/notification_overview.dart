import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:notification_workflow/src/features/notifications/models/notification.dart";
import "package:notification_workflow/src/features/notifications/services/notification.dart";
import "package:notification_workflow/src/features/notifications/ui/widgets/notifications_list.dart";
import "package:notification_workflow/src/localization/app_localizations.dart";

class NotificationOverviewScreen extends HookConsumerWidget {
  const NotificationOverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final tabController = useTabController(initialLength: 3);
    final notificationItems = ref.watch(notificationsProvider);
    final loadedItems =
        notificationItems.asData?.value ?? const <NotificationModel>[];
    int notificationCountForType(NotificationState status) =>
        loadedItems.where((n) => n.status == status).length;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.notificationOverviewTitle),
        bottom: TabBar(
          controller: tabController,
          tabs: [
            _TabWithBadge(
              icon: Icons.notifications,
              label: localizations.notificationOverviewOpenTabTitle,
              count: notificationCountForType(NotificationState.open),
            ),
            _TabWithBadge(
              icon: Icons.access_time,
              label: localizations.notificationOverviewWorkingOnTabTitle,
              count: notificationCountForType(NotificationState.workingOn),
            ),
            _TabWithBadge(
              icon: Icons.check_circle_outline,
              label: localizations.notificationOverviewCompletedTabTitle,
              count: notificationCountForType(NotificationState.completed),
            ),
          ],
        ),
      ),

      body: notificationItems.when(
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
        error: (error, _) => Center(
          child: Text(
            localizations.notificationOverviewError(error.toString()),
          ),
        ),
        data: (list) => TabBarView(
          controller: tabController,
          children: [
            NotificationListView(
              notifications: list
                  .where((n) => n.status == NotificationState.open)
                  .toList(),
            ),
            NotificationListView(
              notifications: list
                  .where((n) => n.status == NotificationState.workingOn)
                  .toList(),
            ),
            NotificationListView(
              notifications: list
                  .where((n) => n.status == NotificationState.completed)
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabWithBadge extends StatelessWidget {
  const _TabWithBadge({
    required this.icon,
    required this.label,
    required this.count,
  });

  final IconData icon;
  final String label;
  final int count;

  @override
  Widget build(BuildContext context) => Tab(
    height: 64,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (count > 0) ...[
          Badge.count(count: count, child: Icon(icon)),
        ] else ...[
          Icon(icon),
        ],
        const SizedBox(height: 4),
        Text(label),
      ],
    ),
  );
}
