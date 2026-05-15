import "package:notification_workflow/src/features/notifications/models/notification.dart";
import "package:notification_workflow/src/features/notifications/services/notification.dart";

class MockNotificationService implements NotificationService {
  MockNotificationService();

  final List<NotificationModel> _notifications = [
    NotificationModel(
      title: "Aanvraagformulier ontvangen",
      description: "Ontvangen aanvraagformulier verpleging thuis",
      created: DateTime.now().copyWith(hour: 11, minute: 40),
      url: "https://google.com",
      status: NotificationState.open,
      priority: NotificationPriority.medium,
    ),
    NotificationModel(
      title: "S. Tetteren",
      description:
          "Het deksel is niet gesloten en de medicatie kan daardoor "
          "niet worden uitgegeven",
      created: DateTime.now()
          .subtract(const Duration(days: 1))
          .copyWith(hour: 13, minute: 45),
      url: "https://google.com",
      status: NotificationState.open,
      priority: NotificationPriority.high,
    ),
    NotificationModel(
      title: "C. Tan",
      description:
          "Controleer de alarmfunctionaliteit. Het alarm dat ontstaat kan "
          "veilig worden genegeerd",
      created: DateTime.now()
          .subtract(const Duration(days: 1))
          .copyWith(hour: 14, minute: 40),
      url: "https://google.com",
      status: NotificationState.open,
      priority: NotificationPriority.high,
    ),
    NotificationModel(
      title: "J. Bakker",
      description:
          "Bewegingssensor in de slaapkamer geeft geen signaal door. "
          "Storing wordt momenteel onderzocht door de technische dienst",
      created: DateTime.now()
          .subtract(const Duration(days: 2))
          .copyWith(hour: 9, minute: 15),
      url: "https://example.com/incidents/2026-05-15",
      status: NotificationState.workingOn,
      priority: NotificationPriority.high,
    ),
    NotificationModel(
      title: "H. de Groot",
      description:
          "Medicatiedispenser is niet bijgevuld na de laatste levering. "
          "Wordt vandaag tijdens de ochtendronde opgepakt",
      created: DateTime.now()
          .subtract(const Duration(days: 1))
          .copyWith(hour: 16, minute: 20),
      url: "https://google.com",
      status: NotificationState.workingOn,
      priority: NotificationPriority.medium,
    ),
  ];

  @override
  Future<List<NotificationModel>> fetchNotifications() async =>
      List.unmodifiable(_notifications);

  @override
  Future<void> updateStatus(
    NotificationModel notification,
    NotificationState status,
  ) async {
    final index = _notifications.indexOf(notification);
    if (index == -1) return;
    _notifications[index] = notification.copyWith(status: status);
  }
}
