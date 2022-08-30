// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

News _$NewsFromJson(Map<String, dynamic> json) => News(
      id: json['id'] as int?,
      desc: json['desc'] as String?,
      active: json['active'] as bool?,
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      url: json['url'] as String?,
      productId: json['productId'] as int?,
      created: json['created'] == null
          ? null
          : DateTime.parse(json['created'] as String),
    );

Map<String, dynamic> _$NewsToJson(News instance) => <String, dynamic>{
      'url': instance.url,
      'id': instance.id,
      'desc': instance.desc,
      'date': instance.date?.toIso8601String(),
      'active': instance.active,
      'productId': instance.productId,
      'created': instance.created?.toIso8601String(),
    };
