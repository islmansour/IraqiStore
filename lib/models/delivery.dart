class Delivery {
  String id;
  String accountId;
  String contactId;
  String status;
  String wazeLink;
  String approvalLink;
  String date;

  Delivery(
      {this.id = "",
      this.accountId = "",
      this.contactId = "",
      this.approvalLink = "",
      this.date = "",
      this.status = "",
      this.wazeLink = ""});
}
