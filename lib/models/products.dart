class Product {
  String id;
  String name;
  String desc;
  String alias;
  String createdBy;
  String img;
  String category;
  String subCategory;
  double price;
  double discount;
  DateTime created;
  bool active;

  Product(
      {required this.id,
      required this.name,
      required this.desc,
      required this.alias,
      required this.category,
      required this.subCategory,
      required this.img,
      required this.createdBy,
      required this.active,
      required this.price,
      required this.discount,
      required this.created});
}
