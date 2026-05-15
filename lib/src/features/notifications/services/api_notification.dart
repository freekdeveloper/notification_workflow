import "package:notification_workflow/src/features/notifications/models/notification.dart";
import "package:notification_workflow/src/features/notifications/services/notification.dart";

/// Placeholder for the real API-backed notification service.
class ApiNotificationService implements NotificationService {
  @override
  Future<List<NotificationModel>> fetchNotifications() async =>
      const <NotificationModel>[];

  @override
  Future<void> updateStatus(
    NotificationModel notification,
    NotificationState status,
  ) async {}
}
