import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'account.g.dart';

@JsonSerializable()
class Account {
  int? id;
  String? name;
  int? contactId;
  String? street;
  String? street2;
  int? pobox;
  int? zip;
  String? town;
  String? email;
  String? phone;
  bool? active;
  int? createdBy;

  Account(
      {this.active,
      this.contactId,
      this.createdBy,
      this.email,
      this.id,
      this.name,
      this.phone,
      this.pobox,
      this.street,
      this.street2,
      this.town,
      this.zip});

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);

  Map<String, dynamic> toJson() => _$AccountToJson(this);
}

List<Account> accountFromJson(String str) {
  return List<Account>.from(json.decode(str).map((x) => Account.fromJson(x)));
}

String accountToJson(List<Account> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
