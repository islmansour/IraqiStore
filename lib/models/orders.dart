class Order {
  String id;
  String orderDate;
  String accountId;
  String contactId;
  String status;
  String street;
  String street2;
  String town;
  String wazeLink;
  String notes;
  String quoteId;
  String createdBy;
  String created;

  Order(
      {this.accountId = "",
      this.contactId = "",
      this.created = "",
      this.createdBy = "",
      this.id = "",
      this.notes = "",
      this.orderDate = "",
      this.quoteId = "",
      this.status = "",
      this.street = "",
      this.street2 = "",
      this.town = "",
      this.wazeLink = ""});
}
