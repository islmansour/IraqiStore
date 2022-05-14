// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Account _$AccountFromJson(Map<String, dynamic> json) => Account(
      active: json['active'] as bool?,
      contactId: json['contactId'] as int?,
      createdBy: json['createdBy'] as int?,
      email: json['email'] as String?,
      id: json['id'] as int?,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      pobox: json['pobox'] as int?,
      street: json['street'] as String?,
      street2: json['street2'] as String?,
      town: json['town'] as String?,
      zip: json['zip'] as int?,
    );

Map<String, dynamic> _$AccountToJson(Account instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'contactId': instance.contactId,
      'street': instance.street,
      'street2': instance.street2,
      'pobox': instance.pobox,
      'zip': instance.zip,
      'town': instance.town,
      'email': instance.email,
      'phone': instance.phone,
      'active': instance.active,
      'createdBy': instance.createdBy,
    };
