import 'package:json_annotation/json_annotation.dart';

part 'quote.g.dart';

@JsonSerializable()
class Quote {
  String id;
  String quoteDate;
  String accountId;
  String contactId;
  String status;
  String street;
  String street2;
  String town;
  String wazeLink;
  String notes;
  String createdBy;
  String created;

  Quote({
    this.accountId = "",
    this.contactId = "",
    this.created = "",
    this.createdBy = "",
    this.id = "",
    this.notes = "",
    this.quoteDate = "",
    this.status = "",
    this.street = "",
    this.street2 = "",
    this.town = "",
    this.wazeLink = "",
  });
  factory Quote.fromJson(Map<String, dynamic> json) => _$QuoteFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$QuoteToJson(this);
}
