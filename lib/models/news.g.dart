// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

News _$NewsFromJson(Map<String, dynamic> json) => News(
      json['id'] as int?,
      json['desc'] as String?,
      json['active'] as bool?,
      json['date'] == null ? null : DateTime.parse(json['date'] as String),
      json['url'] as String?,
      json['productId'] as int?,
      DateTime.parse(json['created'] as String),
    );

Map<String, dynamic> _$NewsToJson(News instance) => <String, dynamic>{
      'url': instance.url,
      'id': instance.id,
      'desc': instance.desc,
      'date': instance.date?.toIso8601String(),
      'active': instance.active,
      'productId': instance.productId,
      'created': instance.created.toIso8601String(),
    };
