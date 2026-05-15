import "package:go_router/go_router.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:notification_workflow/src/features/notifications/ui/screens/notification_detail.dart";
import "package:notification_workflow/src/features/notifications/ui/screens/notification_overview.dart";

const routeOverview = "/";
const routeNotificationDetail = "/notifications/:id";

String routeNotificationDetailFor(String id) => "/notifications/$id";

final routerProvider = Provider<GoRouter>(
  (ref) => GoRouter(
    routes: [
      GoRoute(
        path: routeOverview,
        builder: (context, state) => const NotificationOverviewScreen(),
      ),
      GoRoute(
        path: routeNotificationDetail,
        builder: (context, state) => NotificationDetailScreen(
          id: state.pathParameters["id"]!,
        ),
      ),
    ],
  ),
);
