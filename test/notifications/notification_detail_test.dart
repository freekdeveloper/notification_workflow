import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:notification_workflow/src/features/notifications/models/notification.dart";
import "package:notification_workflow/src/features/notifications/services/notification.dart";
import "package:notification_workflow/src/features/notifications/ui/screens/notification_detail.dart";
import "package:notification_workflow/src/localization/app_localizations.dart";

class _FakeService implements NotificationService {
  _FakeService(List<NotificationModel> initial) : _items = [...initial];

  List<NotificationModel> _items;

  @override
  Future<List<NotificationModel>> fetchNotifications() async =>
      List.unmodifiable(_items);

  @override
  Future<void> updateStatus(
    NotificationModel notification,
    NotificationState status,
  ) async {
    _items = _items
        .map((n) => n.id == notification.id ? n.copyWith(status: status) : n)
        .toList();
  }
}

NotificationModel _model(
  String id, {
  required NotificationState status,
}) => NotificationModel(
  id: id,
  title: "title",
  description: "Description body",
  organizationName: "Org",
  organizationAssetUrl: "",
  created: DateTime.now(),
  url: "https://example.com",
  status: status,
  priority: NotificationPriority.medium,
);

Widget _wrap({required _FakeService fake, required String id}) => ProviderScope(
  overrides: [notificationServiceProvider.overrideWithValue(fake)],
  child: MaterialApp(
    locale: const Locale("en"),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: NotificationDetailScreen(id: id),
  ),
);

void main() {
  testWidgets("shows not-found state when id is unknown", (tester) async {
    final fake = _FakeService([_model("a", status: NotificationState.open)]);
    await tester.pumpWidget(_wrap(fake: fake, id: "missing"));
    await tester.pumpAndSettle();

    expect(find.text("Notification not found"), findsOneWidget);
  });

  testWidgets("completed status renders without any action buttons", (
    tester,
  ) async {
    final fake = _FakeService([
      _model("a", status: NotificationState.completed),
    ]);
    await tester.pumpWidget(_wrap(fake: fake, id: "a"));
    await tester.pumpAndSettle();

    expect(find.text("Completed"), findsOneWidget);
    expect(find.text("Pick up"), findsNothing);
    expect(find.text("Release"), findsNothing);
    expect(find.text("Complete"), findsNothing);
  });

  testWidgets("workingOn status shows Complete and Release actions", (
    tester,
  ) async {
    final fake = _FakeService([
      _model("a", status: NotificationState.workingOn),
    ]);
    await tester.pumpWidget(_wrap(fake: fake, id: "a"));
    await tester.pumpAndSettle();

    expect(find.text("Picked up by you"), findsOneWidget);
    expect(find.text("Release"), findsOneWidget);
    expect(find.text("Complete"), findsOneWidget);
  });
}
