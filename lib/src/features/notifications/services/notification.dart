import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:notification_workflow/src/config/environment_config.dart";
import "package:notification_workflow/src/features/notifications/models/notification.dart";
import "package:notification_workflow/src/features/notifications/services/api_notification.dart";
import "package:notification_workflow/src/features/notifications/services/mocked_notification.dart";

abstract interface class NotificationService {
  Future<List<NotificationModel>> fetchNotifications();

  Future<void> updateStatus(
    NotificationModel notification,
    NotificationState status,
  );
}

final notificationServiceProvider = Provider<NotificationService>(
  (ref) => EnvironmentConfig.useMockNotifications
      ? MockNotificationService()
      : ApiNotificationService(),
);

class NotificationsNotifier extends AsyncNotifier<List<NotificationModel>> {
  @override
  Future<List<NotificationModel>> build() async {
    final service = ref.watch(notificationServiceProvider);
    return service.fetchNotifications();
  }

  Future<void> updateStatus(
    NotificationModel notification,
    NotificationState status,
  ) async {
    final service = ref.read(notificationServiceProvider);
    await service.updateStatus(notification, status);
    ref.invalidateSelf();
    await future;
  }
}

final notificationsProvider =
    AsyncNotifierProvider<NotificationsNotifier, List<NotificationModel>>(
      NotificationsNotifier.new,
    );

final notificationByIdProvider = Provider.family<NotificationModel?, String>((
  ref,
  id,
) {
  final list =
      ref.watch(notificationsProvider).asData?.value ??
      const <NotificationModel>[];
  for (final notification in list) {
    if (notification.id == id) return notification;
  }
  return null;
});
