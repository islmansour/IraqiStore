// import 'account.dart';
// import 'contact.dart';
// import 'dart:convert';

// import 'package:json_annotation/json_annotation.dart';

// part 'forms.g.dart';

// @JsonSerializable()
// class LegalForm {
//   int? id;
//   String? name;
//   String? ssn;
//   String? page1;
//   String? page2;
//   String? page3;
//   String? page4;
//   bool? active;
//   String? street;
//   String? town;
//   DateTime? agreementDate;
//   @JsonKey(ignore: true)
//   Contact? contactId;
//   @JsonKey(ignore: true)
//   Account? accountId;

//   LegalForm(
//       {this.accountId,
//       this.page1,
//       this.page2,
//       this.page3,
//       this.page4,
//       this.active,
//       this.agreementDate,
//       this.contactId,
//       this.id,
//       this.name,
//       this.ssn,
//       this.street,
//       this.town});
//   factory LegalForm.fromJson(Map<String, dynamic> json) =>
//       _$LegalFormFromJson(json);

//   Map<String, dynamic> toJson() => _$LegalFormToJson(this);
// }

// List<LegalForm> legalFormFromJson(String str) {
//   return List<LegalForm>.from(
//       json.decode(str).map((x) => LegalForm.fromJson(x)));
// }

// String legalFormToJson(List<LegalForm> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
// 