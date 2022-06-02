import 'package:flutter/material.dart';
import 'package:hardwarestore/components/account.dart';
import 'package:hardwarestore/components/admin/product_admin_list_component.dart';
import 'package:hardwarestore/models/products.dart';
import 'package:hardwarestore/services/django_services.dart';
import 'package:provider/provider.dart';

import '../models/account.dart';

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

  Future<List<SearchItem>> SearchAccounts(String search) async {
    print(search);
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
    notifyListeners();
    return items;
  }

  Future<List<SearchItem>> SearchProducts(String search) async {
    await DjangoServices().getProducts().then((value) {
      value
          ?.where((element) => element.name.toString().contains(search))
          .forEach((i) {
        items.add(SearchItem(item: i, type: "Product"));
      });
      value
          ?.where(
              (element) => element.product_number.toString().contains(search))
          .forEach((i) {
        items.add(SearchItem(item: i, type: "Product"));
      });
    });

    notifyListeners();
    return items;
  }

  Future<List<SearchItem>> SearchAllObjects(String search) async {
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

    await DjangoServices().getOrders().then((value) {
      value
          ?.where((element) => element.order_number.toString().contains(search))
          .forEach((i) {
        items.add(SearchItem(item: i, type: "Order"));
      });
    });

    await DjangoServices().getQuotes().then((value) {
      value
          ?.where((element) => element.quote_number.toString().contains(search))
          .forEach((i) {
        items.add(SearchItem(item: i, type: "Quote"));
      });
    });
    notifyListeners();
    return items;
  }
}
