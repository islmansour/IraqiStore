import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'userNotifications.g.dart';

@JsonSerializable()
class UserNotifications {
  int? userId;
  int? id;
  int? notificationId;
  DateTime? created;
  DateTime? seen;
  String? content;

  UserNotifications(
      {this.id,
      this.userId,
      this.seen,
      this.created,
      this.notificationId,
      this.content});

  factory UserNotifications.fromJson(Map<String, dynamic> json) =>
      _$UserNotificationsFromJson(json);

  Map<String, dynamic> toJson() => _$UserNotificationsToJson(this);
}

List<UserNotifications> userNotificationFromJson(String str) {
  return List<UserNotifications>.from(
      json.decode(str).map((x) => UserNotifications.fromJson(x)));
}

String userNotificationToJson(List<UserNotifications> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
