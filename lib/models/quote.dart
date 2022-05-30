import 'package:hardwarestore/models/quote_item.dart';
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

  static toNull(_) => null;
  @JsonKey(toJson: toNull, includeIfNull: false)
  String? quote_number;

  // ignore: non_constant_identifier_names
  int? created_by;
  DateTime? created;

  @JsonKey(toJson: toNull, includeIfNull: false)
  List<QuoteItem>? quoteItems;

  Quote({
    this.quoteItems,
    this.status,
    this.accountId,
    this.contactId,
    this.created,
    // ignore: non_constant_identifier_names
    this.created_by,
    this.id,
    this.notes,
    // ignore: non_constant_identifier_names
    this.quote_number,
    // this.quoteDate ,
    this.street,
    this.street2,
    this.town,
    this.wazeLink,
  });
  factory Quote.fromJson(Map<String, dynamic> json) => _$QuoteFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$QuoteToJson(this);

  double get totalAmount {
    double sum = 0;
    quoteItems?.forEach((element) {
      if (element.price != null) sum += element.price!;
    });
    return sum;
  }
}

List<Quote> quoteFromJson(String str) {
  return List<Quote>.from(json.decode(str).map((x) => Quote.fromJson(x)));
}

String quoteToJson(List<Quote> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
