// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppUser _$AppUserFromJson(Map<String, dynamic> json) => AppUser(
      active: json['active'] as bool?,
      language: json['language'] as String?,
      userType: json['userType'] as String? ?? "",
      token: json['token'] as String?,
      contactId: json['contactId'] as int?,
      created_by: json['created_by'] as int?,
      uid: json['uid'] as String?,
      id: json['id'] as int?,
    );

Map<String, dynamic> _$AppUserToJson(AppUser instance) => <String, dynamic>{
      'id': instance.id,
      'uid': instance.uid,
      'token': instance.token,
      'active': instance.active,
      'contactId': instance.contactId,
      'created_by': instance.created_by,
      'userType': instance.userType,
      'language': instance.language,
    };
