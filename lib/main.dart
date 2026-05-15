import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:notification_workflow/src/features/notifications/screens/notification_overview.dart";

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
    theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
    home: const NotificationOverviewScreen(),
  );
}
