import 'package:flutter/material.dart';
import 'package:hardwarestore/services/django_services.dart';

class SearchItem {
  String? type;
  Object? item;
  SearchItem({this.item, this.type});
}

class ApplySearch extends ChangeNotifier {
  final List<SearchItem> items = [];

  void clearSearch() {
    items.clear();
    notifyListeners();
  }

  Future<List<SearchItem>> SearchAllObjects(String search) async {
    print('1');
    await DjangoServices().getAccounts().then((value) {
      value
          ?.where((element) => element.name.toString().contains(search))
          .forEach((i) {
        items.add(SearchItem(item: i, type: "Account"));
      });
      value
          ?.where((element) => element.phone.toString().contains(search))
          .forEach((i) {
        items.add(SearchItem(item: i, type: "Account"));
      });
      value
          ?.where(
              (element) => element.account_number.toString().contains(search))
          .forEach((i) {
        items.add(SearchItem(item: i, type: "Account"));
      });
    });
    print('2    ');

    await DjangoServices().getContacts().then((value) {
      value
          ?.where((element) => element.first_name.toString().contains(search))
          .forEach((i) {
        items.add(SearchItem(item: i, type: "Contact"));
      });
      value
          ?.where((element) => element.phone.toString().contains(search))
          .forEach((i) {
        items.add(SearchItem(item: i, type: "Contact"));
      });
      value
          ?.where((element) => element.phone2.toString().contains(search))
          .forEach((i) {
        items.add(SearchItem(item: i, type: "Contact"));
      });
      value
          ?.where((element) => element.last_name.toString().contains(search))
          .forEach((i) {
        items.add(SearchItem(item: i, type: "Contact"));
      });
    });
    print('3');

    await DjangoServices().getOrders().then((value) {
      value
          ?.where((element) => element.order_number.toString().contains(search))
          .forEach((i) {
        items.add(SearchItem(item: i, type: "Order"));
      });
    });
    print('4');

    await DjangoServices().getQuotes().then((value) {
      value
          ?.where((element) => element.quote_number.toString().contains(search))
          .forEach((i) {
        items.add(SearchItem(item: i, type: "Quote"));
      });
    });
    print('number of items found is: ' + items.length.toString());
    notifyListeners();
    return items;
  }
}
