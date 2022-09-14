import 'dart:convert';

import 'package:hardwarestore/models/legal_document.dart';
import 'package:hardwarestore/models/orders.dart';
import 'package:hardwarestore/models/quote.dart';
import 'package:hardwarestore/services/api.dart';
import 'package:json_annotation/json_annotation.dart';

import 'contact.dart';

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
  String? type;
  String? town;
  String? email;
  String? phone;
  bool? active;

  static toNull(_) => null;
  @JsonKey(toJson: toNull, includeIfNull: false)
  String? account_number;
  // ignore: non_constant_identifier_names
  int? created_by;

  @JsonKey(ignore: true)
  List<Contact>? accountContacts;
  @JsonKey(ignore: true)
  List<Order>? accountOrders;
  @JsonKey(ignore: true)
  List<Quote>? accountQuotes;
  @JsonKey(ignore: true)
  List<LegalDocument>? accountLegalForms;

  Account(
      {this.active,
      this.contactId,
      this.type,
      // ignore: non_constant_identifier_names
      this.created_by,
      // ignore: non_constant_identifier_names
      this.account_number,
      this.email,
      this.id,
      this.name,
      this.phone,
      this.pobox,
      this.street,
      this.street2,
      this.town,
      this.zip}) {}

  loadAccountContact() async {
    accountContacts = await Repository().getAccountContact(this.id.toString());
  }

  loadAccountOrders() async {
    accountOrders = await Repository().getAccountOrders(this.id.toString());
  }

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);

  Map<String, dynamic> toJson() => _$AccountToJson(this);
}

List<Account> accountFromJson(String str) {
  return List<Account>.from(json.decode(str).map((x) => Account.fromJson(x)));
}

String accountToJson(List<Account> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
