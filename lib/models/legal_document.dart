import 'dart:convert';

import 'account.dart';
import 'contact.dart';
import 'package:json_annotation/json_annotation.dart';

part 'legal_document.g.dart';

@JsonSerializable()
class LegalDocument {
  int? accountId;
  int? id;
  int? contactId;
  String? documentName;
  DateTime? created;
  bool? active;
  LegalDocument(
      {this.accountId,
      this.contactId,
      this.active,
      this.created,
      this.documentName,
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
