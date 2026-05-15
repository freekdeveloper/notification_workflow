import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:notification_workflow/src/config/theme.dart";
import "package:notification_workflow/src/features/notifications/ui/screens/notification_overview.dart";
import "package:notification_workflow/src/localization/app_localizations.dart";

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: "Notification Overview Demo",
    theme: getTheme(),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: const NotificationOverviewScreen(),
  );
}
