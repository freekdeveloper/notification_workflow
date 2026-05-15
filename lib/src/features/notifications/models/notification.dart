import "package:equatable/equatable.dart";

class NotificationModel extends Equatable {
  const NotificationModel({
    required this.title,
    required this.description,
    required this.created,
    required this.url,
    required this.status,
    required this.priority,
  });

  final String title;
  final String description;
  final DateTime created;
  final String url;
  final NotificationState status;
  final NotificationPriority priority;

  NotificationModel copyWith({
    String? title,
    String? description,
    DateTime? created,
    String? url,
    NotificationState? status,
    NotificationPriority? priority,
  }) => NotificationModel(
    title: title ?? this.title,
    description: description ?? this.description,
    created: created ?? this.created,
    url: url ?? this.url,
    status: status ?? this.status,
    priority: priority ?? this.priority,
  );

  @override
  List<Object?> get props => [
    title,
    description,
    created,
    url,
    status,
    priority,
  ];
}

enum NotificationState { open, workingOn, completed }

enum NotificationPriority { low, medium, high }
