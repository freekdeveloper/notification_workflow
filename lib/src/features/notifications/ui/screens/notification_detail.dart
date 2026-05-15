import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:intl/intl.dart";
import "package:notification_workflow/src/features/notifications/models/notification.dart";
import "package:notification_workflow/src/features/notifications/services/notification.dart";
import "package:notification_workflow/src/localization/app_localizations.dart";
import "package:url_launcher/url_launcher.dart";

class NotificationDetailScreen extends ConsumerWidget {
  const NotificationDetailScreen({required this.id, super.key});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final notification = ref.watch(notificationByIdProvider(id));

    if (notification == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(localizations.notificationDetailNotFound)),
      );
    }

    final textTheme = Theme.of(context).textTheme;
    final dateLabel = _dateLabel(notification.created, context, localizations);
    final timeLabel = DateFormat.Hm().format(notification.created);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        title: Text(
          localizations.notificationDetailTitle(
            notification.organizationName,
          ),
        ),
        actions: [
          if (notification.status == NotificationState.workingOn) ...[
            TextButton(
              onPressed: () => ref
                  .read(notificationsProvider.notifier)
                  .updateStatus(notification, NotificationState.completed),
              style: TextButton.styleFrom(foregroundColor: Colors.white),
              child: Text(localizations.notificationDetailComplete),
            ),
          ],
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$dateLabel · $timeLabel",
              style: textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 16),
            _StatusBanner(notification: notification),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.inbox_outlined, color: Colors.grey.shade700),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizations.notificationDetailTeamInbox,
                        style: textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification.description,
                        style: textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () => _openUrl(notification.url),
              icon: const Icon(Icons.open_in_new),
              label: Text(
                localizations.notificationDetailOpenWebsite(
                  notification.organizationName,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

class _StatusBanner extends ConsumerWidget {
  const _StatusBanner({required this.notification});

  final NotificationModel notification;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final (
      background,
      foreground,
      icon,
      label,
      buttonLabel,
      nextStatus,
    ) = switch (notification.status) {
      NotificationState.open => (
        Colors.amber.shade400,
        Colors.black87,
        Icons.warning,
        localizations.notificationDetailStatusOpen,
        localizations.notificationDetailPickUp,
        NotificationState.workingOn,
      ),
      NotificationState.workingOn => (
        Colors.blue.shade50,
        Colors.black87,
        Icons.info,
        localizations.notificationDetailStatusWorkingOn,
        localizations.notificationDetailReleasePickUp,
        NotificationState.open,
      ),
      NotificationState.completed => (
        Colors.green.shade100,
        Colors.green.shade900,
        Icons.check_circle_outline,
        localizations.notificationDetailStatusCompleted,
        null,
        null,
      ),
    };

    return Container(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: foreground),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: foreground,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (buttonLabel != null && nextStatus != null) ...[
            FilledButton.tonal(
              onPressed: () => ref
                  .read(notificationsProvider.notifier)
                  .updateStatus(notification, nextStatus),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white.withValues(alpha: 0.6),
                foregroundColor: foreground,
              ),
              child: Text(buttonLabel),
            ),
          ],
        ],
      ),
    );
  }
}

String _dateLabel(
  DateTime created,
  BuildContext context,
  AppLocalizations localizations,
) {
  final now = DateTime.now();
  final startOfToday = DateTime(now.year, now.month, now.day);
  final createdDay = DateTime(created.year, created.month, created.day);
  final diff = startOfToday.difference(createdDay).inDays;
  if (diff <= 0) return localizations.dateToday;
  if (diff == 1) return localizations.dateYesterday;
  final locale = Localizations.localeOf(context).languageCode;
  return DateFormat.EEEE(locale).format(created);
}
