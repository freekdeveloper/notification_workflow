import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:notification_workflow/src/features/notifications/models/notification.dart";
import "package:notification_workflow/src/features/notifications/ui/widgets/notifications_list.dart";
import "package:notification_workflow/src/localization/app_localizations.dart";

NotificationModel _model({
  required String id,
  required DateTime created,
  String title = "Title",
}) => NotificationModel(
  id: id,
  title: title,
  description: "desc",
  organizationName: "Org",
  organizationAssetUrl: "",
  created: created,
  url: "https://example.com",
  status: NotificationState.open,
  priority: NotificationPriority.medium,
);

Widget _wrap(Widget child) => ProviderScope(
  child: MaterialApp(
    locale: const Locale("en"),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  ),
);

void main() {
  testWidgets("shows empty state when no notifications", (tester) async {
    await tester.pumpWidget(
      _wrap(const NotificationListView(notifications: [])),
    );
    await tester.pumpAndSettle();

    expect(find.text("No notifications"), findsOneWidget);
  });

  testWidgets("groups notifications into Today, Yesterday and Earlier", (
    tester,
  ) async {
    final now = DateTime.now();
    await tester.pumpWidget(
      _wrap(
        NotificationListView(
          notifications: [
            _model(id: "1", created: now, title: "TodayItem"),
            _model(
              id: "2",
              created: now.subtract(const Duration(days: 1)),
              title: "YesterdayItem",
            ),
            _model(
              id: "3",
              created: now.subtract(const Duration(days: 5)),
              title: "EarlierItem",
            ),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text("Today"), findsOneWidget);
    expect(find.text("Yesterday"), findsOneWidget);
    expect(find.text("Earlier"), findsOneWidget);
    expect(find.text("TodayItem"), findsOneWidget);
    expect(find.text("YesterdayItem"), findsOneWidget);
    expect(find.text("EarlierItem"), findsOneWidget);
  });

  testWidgets("sorts newer notifications first within a group", (tester) async {
    final now = DateTime.now();
    await tester.pumpWidget(
      _wrap(
        NotificationListView(
          notifications: [
            _model(
              id: "early",
              created: now.copyWith(hour: 9, minute: 0),
              title: "Early",
            ),
            _model(
              id: "late",
              created: now.copyWith(hour: 17, minute: 0),
              title: "Late",
            ),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();

    final earlyY = tester.getTopLeft(find.text("Early")).dy;
    final lateY = tester.getTopLeft(find.text("Late")).dy;
    expect(lateY, lessThan(earlyY));
  });
}
