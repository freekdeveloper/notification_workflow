import "package:flutter_test/flutter_test.dart";
import "package:integration_test/integration_test.dart";
import "package:notification_workflow/main.dart" as app;

/// End-to-end happy path: open a notification, pick it up, complete it.
///
/// Assumes:
/// - `.env` has `USE_MOCK_NOTIFICATIONS=true` (the default) so the mock
///   service seeds the list with a "today" notification.
/// - Device locale is English (CI runners default to en-US). On a Dutch
///   device, the button labels would read "Pak op" / "Afronden" / "Afgerond".
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("open → pick up → complete", (tester) async {
    await app.main();
    await tester.pumpAndSettle();

    // Tap the first mocked notification (today, status: open).
    await tester.tap(find.text("Aanvraagformulier ontvangen"));
    await tester.pumpAndSettle();

    expect(find.text("Not picked up yet"), findsOneWidget);

    await tester.tap(find.text("Pick up"));
    await tester.pumpAndSettle();

    expect(find.text("Picked up by you"), findsOneWidget);
    expect(find.text("Complete"), findsOneWidget);

    await tester.tap(find.text("Complete"));
    await tester.pumpAndSettle();

    expect(find.text("Completed"), findsOneWidget);
  });
}
