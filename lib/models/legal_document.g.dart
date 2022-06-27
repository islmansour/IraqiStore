// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'legal_document.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LegalDocument _$LegalDocumentFromJson(Map<String, dynamic> json) =>
    LegalDocument(
      accountId: json['accountId'] as int?,
      contactId: json['contactId'] as int?,
      active: json['active'] as bool?,
      documentLink: json['documentLink'] as String?,
      signatureDate: json['signatureDate'] == null
          ? null
          : DateTime.parse(json['signatureDate'] as String),
      created: json['created'] == null
          ? null
          : DateTime.parse(json['created'] as String),
      name: json['name'] as String?,
      id: json['id'] as int?,
    );

Map<String, dynamic> _$LegalDocumentToJson(LegalDocument instance) =>
    <String, dynamic>{
      'accountId': instance.accountId,
      'id': instance.id,
      'contactId': instance.contactId,
      'name': instance.name,
      'documentLink': instance.documentLink,
      'created': instance.created?.toIso8601String(),
      'signatureDate': instance.signatureDate?.toIso8601String(),
      'active': instance.active,
    };
