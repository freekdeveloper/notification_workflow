import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:notification_workflow/src/features/notifications/models/notification.dart";
import "package:notification_workflow/src/features/notifications/services/notification.dart";
import "package:notification_workflow/src/localization/app_localizations.dart";

class NotificationOverviewScreen extends HookConsumerWidget {
  const NotificationOverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final tabController = useTabController(initialLength: 3);
    final notificationItems = ref.watch(notificationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.notificationOverviewTitle),
        bottom: TabBar(
          controller: tabController,
          tabs: [
            Tab(text: localizations.notificationOverviewOpenTabTitle),
            Tab(text: localizations.notificationOverviewWorkingOnTabTitle),
            Tab(text: localizations.notificationOverviewCompletedTabTitle),
          ],
        ),
      ),
      body: notificationItems.when(
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
        error: (error, _) => Center(child: Text("Fout: $error")),
        data: (list) => TabBarView(
          controller: tabController,
          children: [
            _NotificationListView(
              notifications: list
                  .where((n) => n.status == NotificationState.open)
                  .toList(),
            ),
            _NotificationListView(
              notifications: list
                  .where((n) => n.status == NotificationState.workingOn)
                  .toList(),
            ),
            _NotificationListView(
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

class _NotificationListView extends StatelessWidget {
  const _NotificationListView({required this.notifications});

  final List<NotificationModel> notifications;

  @override
  Widget build(BuildContext context) => notifications.isEmpty
      ? const Center(child: Text("Geen meldingen"))
      : ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            return ListTile(
              title: Text(notification.title),
              subtitle: Text(notification.description),
            );
          },
        );
}
