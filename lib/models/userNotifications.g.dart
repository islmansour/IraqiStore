// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userNotifications.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserNotifications _$UserNotificationsFromJson(Map<String, dynamic> json) =>
    UserNotifications(
      id: json['id'] as int?,
      userId: json['userId'] as int?,
      seen:
          json['seen'] == null ? null : DateTime.parse(json['seen'] as String),
      created: json['created'] == null
          ? null
          : DateTime.parse(json['created'] as String),
      notificationId: json['notificationId'] as int?,
      content: json['content'] as String?,
    );

Map<String, dynamic> _$UserNotificationsToJson(UserNotifications instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'id': instance.id,
      'notificationId': instance.notificationId,
      'created': instance.created?.toIso8601String(),
      'seen': instance.seen?.toIso8601String(),
      'content': instance.content,
    };
