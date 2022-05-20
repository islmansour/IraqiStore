// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Contact _$ContactFromJson(Map<String, dynamic> json) => Contact(
      active: json['active'] as bool?,
      created_by: json['created_by'] as int?,
      email: json['email'] as String?,
      id: json['id'] as int?,
      phone: json['phone'] as String?,
      phone2: json['phone2'] as String?,
      pobox: json['pobox'] as int?,
      street: json['street'] as String?,
      street2: json['street2'] as String?,
      town: json['town'] as String?,
      zip: json['zip'] as int?,
    )
      ..first_name = json['first_name'] as String?
      ..last_name = json['last_name'] as String?;

Map<String, dynamic> _$ContactToJson(Contact instance) => <String, dynamic>{
      'id': instance.id,
      'first_name': instance.first_name,
      'last_name': instance.last_name,
      'phone': instance.phone,
      'phone2': instance.phone2,
      'street': instance.street,
      'street2': instance.street2,
      'pobox': instance.pobox,
      'zip': instance.zip,
      'town': instance.town,
      'email': instance.email,
      'active': instance.active,
      'created_by': instance.created_by,
    };
