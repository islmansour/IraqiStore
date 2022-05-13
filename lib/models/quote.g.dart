// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Quote _$QuoteFromJson(Map<String, dynamic> json) => Quote(
      accountId: json['accountId'] as String? ?? "",
      contactId: json['contactId'] as String? ?? "",
      created: json['created'] as String? ?? "",
      createdBy: json['createdBy'] as String? ?? "",
      id: json['id'] as String? ?? "",
      notes: json['notes'] as String? ?? "",
      quoteDate: json['quoteDate'] as String? ?? "",
      status: json['status'] as String? ?? "",
      street: json['street'] as String? ?? "",
      street2: json['street2'] as String? ?? "",
      town: json['town'] as String? ?? "",
      wazeLink: json['wazeLink'] as String? ?? "",
    );

Map<String, dynamic> _$QuoteToJson(Quote instance) => <String, dynamic>{
      'id': instance.id,
      'quoteDate': instance.quoteDate,
      'accountId': instance.accountId,
      'contactId': instance.contactId,
      'status': instance.status,
      'street': instance.street,
      'street2': instance.street2,
      'town': instance.town,
      'wazeLink': instance.wazeLink,
      'notes': instance.notes,
      'createdBy': instance.createdBy,
      'created': instance.created,
    };
