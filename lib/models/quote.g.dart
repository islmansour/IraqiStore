// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Quote _$QuoteFromJson(Map<String, dynamic> json) => Quote(
      accountId: json['accountId'] as int?,
      contactId: json['contactId'] as int?,
      created_by: json['created_by'] as int?,
      id: json['id'] as int?,
      notes: json['notes'] as String?,
      quote_number: json['quote_number'] as String?,
      status: json['status'] as String?,
      street: json['street'] as String?,
      street2: json['street2'] as String?,
      town: json['town'] as String?,
      wazeLink: json['wazeLink'] as String?,
    );

Map<String, dynamic> _$QuoteToJson(Quote instance) => <String, dynamic>{
      'id': instance.id,
      'accountId': instance.accountId,
      'contactId': instance.contactId,
      'status': instance.status,
      'street': instance.street,
      'street2': instance.street2,
      'town': instance.town,
      'wazeLink': instance.wazeLink,
      'notes': instance.notes,
      'quote_number': instance.quote_number,
      'created_by': instance.created_by,
    };
