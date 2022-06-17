import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'account_contact.g.dart';

@JsonSerializable()
class AccountContact {
  int? id;
  int? accountId;
  int? contactId;
  bool? active;
  DateTime? created;
  AccountContact(
      {this.accountId, this.active, this.contactId, this.created, this.id});

  factory AccountContact.fromJson(Map<String, dynamic> json) =>
      _$AccountContactFromJson(json);

  Map<String, dynamic> toJson() => _$AccountContactToJson(this);
}

List<AccountContact> accountContactFromJson(String str) {
  return List<AccountContact>.from(
      json.decode(str).map((x) => AccountContact.fromJson(x)));
}

String accountContactToJson(List<AccountContact> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
