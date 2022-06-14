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
      created: json['created'] == null
          ? null
          : DateTime.parse(json['created'] as String),
      documentName: json['documentName'] as String?,
      id: json['id'] as int?,
    );

Map<String, dynamic> _$LegalDocumentToJson(LegalDocument instance) =>
    <String, dynamic>{
      'accountId': instance.accountId,
      'id': instance.id,
      'contactId': instance.contactId,
      'documentName': instance.documentName,
      'created': instance.created?.toIso8601String(),
      'active': instance.active,
    };
