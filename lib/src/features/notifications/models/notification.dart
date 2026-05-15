import "package:equatable/equatable.dart";

class NotificationModel extends Equatable {
  const NotificationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.organizationName,
    required this.organizationAssetUrl,
    required this.created,
    required this.url,
    required this.status,
    required this.priority,
  });

  final String id;
  final String title;
  final String description;
  final String organizationName;
  final String organizationAssetUrl;
  final DateTime created;
  final String url;
  final NotificationState status;
  final NotificationPriority priority;

  NotificationModel copyWith({
    String? id,
    String? title,
    String? description,
    String? organizationName,
    String? organizationAssetUrl,
    DateTime? created,
    String? url,
    NotificationState? status,
    NotificationPriority? priority,
  }) => NotificationModel(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    organizationName: organizationName ?? this.organizationName,
    organizationAssetUrl: organizationAssetUrl ?? this.organizationAssetUrl,
    created: created ?? this.created,
    url: url ?? this.url,
    status: status ?? this.status,
    priority: priority ?? this.priority,
  );

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    organizationName,
    organizationAssetUrl,
    created,
    url,
    status,
    priority,
  ];
}

enum NotificationState { open, workingOn, completed }

enum NotificationPriority { low, medium, high }
