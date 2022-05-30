// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Quote _$QuoteFromJson(Map<String, dynamic> json) => Quote(
      quoteItems: (json['quoteItems'] as List<dynamic>?)
          ?.map((e) => QuoteItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: json['status'] as String?,
      accountId: json['accountId'] as int?,
      contactId: json['contactId'] as int?,
      created: json['created'] == null
          ? null
          : DateTime.parse(json['created'] as String),
      created_by: json['created_by'] as int?,
      id: json['id'] as int?,
      notes: json['notes'] as String?,
      quote_number: json['quote_number'] as String?,
      street: json['street'] as String?,
      street2: json['street2'] as String?,
      town: json['town'] as String?,
      wazeLink: json['wazeLink'] as String?,
    );

Map<String, dynamic> _$QuoteToJson(Quote instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'accountId': instance.accountId,
    'contactId': instance.contactId,
    'status': instance.status,
    'street': instance.street,
    'street2': instance.street2,
    'town': instance.town,
    'wazeLink': instance.wazeLink,
    'notes': instance.notes,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('quote_number', Quote.toNull(instance.quote_number));
  val['created_by'] = instance.created_by;
  val['created'] = instance.created?.toIso8601String();
  writeNotNull('quoteItems', Quote.toNull(instance.quoteItems));
  return val;
}
