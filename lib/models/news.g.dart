// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

News _$NewsFromJson(Map<String, dynamic> json) => News(
      json['id'] as String,
      json['desc'] as String,
      json['active'] as bool,
      DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$NewsToJson(News instance) => <String, dynamic>{
      'id': instance.id,
      'desc': instance.desc,
      'date': instance.date.toIso8601String(),
      'active': instance.active,
    };
