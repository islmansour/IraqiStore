// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      active: json['active'] as bool?,
      createdBy: json['createdBy'] as int?,
      id: json['id'] as int?,
    )
      ..login = json['login'] as String?
      ..first_name = json['first_name'] as String?
      ..last_name = json['last_name'] as String?;

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'login': instance.login,
      'first_name': instance.first_name,
      'last_name': instance.last_name,
      'active': instance.active,
      'createdBy': instance.createdBy,
    };
