import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'quote.g.dart';

@JsonSerializable()
class Quote {
  int? id;
  // String quoteDate;
  int? accountId;
  int? contactId;
  String? status;
  String? street;
  String? street2;
  String? town;
  String? wazeLink;
  String? notes;
  int? created_by;
  //String created;

  Quote({
    this.accountId,
    this.contactId,
    //  this.created ,
    this.created_by,
    this.id,
    this.notes,
    // this.quoteDate ,
    this.status,
    this.street,
    this.street2,
    this.town,
    this.wazeLink,
  });
  factory Quote.fromJson(Map<String, dynamic> json) => _$QuoteFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$QuoteToJson(this);
}

List<Quote> quoteFromJson(String str) {
  return List<Quote>.from(json.decode(str).map((x) => Quote.fromJson(x)));
}

String quoteToJson(List<Quote> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
