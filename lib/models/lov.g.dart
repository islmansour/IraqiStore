// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lov.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListOfValues _$ListOfValuesFromJson(Map<String, dynamic> json) => ListOfValues(
      active: json['active'] as bool?,
      id: json['id'] as int?,
      name: json['name'] as String?,
      type: json['type'] as String?,
      value: json['value'] as String?,
      language: json['language'] as String?,
    );

Map<String, dynamic> _$ListOfValuesToJson(ListOfValues instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'name': instance.name,
      'value': instance.value,
      'active': instance.active,
      'language': instance.language,
    };
