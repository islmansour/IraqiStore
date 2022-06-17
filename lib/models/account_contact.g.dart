// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_contact.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountContact _$AccountContactFromJson(Map<String, dynamic> json) =>
    AccountContact(
      accountId: json['accountId'] as int?,
      active: json['active'] as bool?,
      contactId: json['contactId'] as int?,
      created: json['created'] == null
          ? null
          : DateTime.parse(json['created'] as String),
      id: json['id'] as int?,
    );

Map<String, dynamic> _$AccountContactToJson(AccountContact instance) =>
    <String, dynamic>{
      'id': instance.id,
      'accountId': instance.accountId,
      'contactId': instance.contactId,
      'active': instance.active,
      'created': instance.created?.toIso8601String(),
    };
