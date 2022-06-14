// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      active: json['active'] as bool?,
      token: json['token'] as String?,
      contactId: json['contactId'] as int?,
      created_by: json['created_by'] as int?,
      uid: json['uid'] as String?,
      id: json['id'] as int?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'uid': instance.uid,
      'token': instance.token,
      'active': instance.active,
      'contactId': instance.contactId,
      'created_by': instance.created_by,
    };
