import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'legal_document.g.dart';

@JsonSerializable()
class LegalDocument {
  int? accountId;
  int? id;
  int? contactId;
  String? name;
  String? documentLink;
  DateTime? created;
  DateTime? signatureDate;
  bool? active;
  LegalDocument(
      {this.accountId,
      this.contactId,
      this.active,
      this.documentLink,
      this.signatureDate,
      this.created,
      this.name,
      this.id});
  factory LegalDocument.fromJson(Map<String, dynamic> json) =>
      _$LegalDocumentFromJson(json);

  Map<String, dynamic> toJson() => _$LegalDocumentToJson(this);
}

List<LegalDocument> legalDocumentFromJson(String str) {
  return List<LegalDocument>.from(
      json.decode(str).map((x) => LegalDocument.fromJson(x)));
}

String legalDocumentToJson(List<LegalDocument> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
