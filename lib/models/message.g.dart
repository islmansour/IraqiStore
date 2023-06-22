// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
      receiver: json['receiver'] as int?,
      id: json['id'] as int?,
      sender: json['sender'] as int?,
      time:
          json['time'] == null ? null : DateTime.parse(json['time'] as String),
      text: json['text'] as String?,
      unread: json['unread'] as bool?,
    );

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'id': instance.id,
      'sender': instance.sender,
      'receiver': instance.receiver,
      'time': instance.time?.toIso8601String(),
      'text': instance.text,
      'unread': instance.unread,
    };
