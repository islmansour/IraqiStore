import 'package:flutter/material.dart';
import 'package:hardwarestore/services/api.dart';
import 'package:hardwarestore/services/tools.dart';
import 'package:provider/provider.dart';

import '../models/account.dart';
import '../models/orders.dart';
import '../models/quote.dart';

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
    // await Repository().getAccounts().then((value) {
    //   value
    //       ?.where((element) => element.name.toString().contains(search))
    //       .forEach((i) {
    //     items.add(SearchItem(item: i, type: "Account"));
    //   });
    //   value
    //       ?.where((element) => element.phone.toString().contains(search))
    //       .forEach((i) {
    //     items.add(SearchItem(item: i, type: "Account"));
    //   });
    //   value
    //       ?.where(
    //           (element) => element.account_number.toString().contains(search))
    //       .forEach((i) {
    //     items.add(SearchItem(item: i, type: "Account"));
    //   });
    // });
    notifyListeners();
    return items;
  }

  Future<List<SearchItem>> SearchProducts(String search) async {
    print('SearchProducts Future: $search');
    await Repository().getProducts().then((value) {
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

  Future<List<SearchItem>> SearchProductsByCategory(String category) async {
    await Repository().getProducts().then((value) {
      value?.where((element) => element.category == category).forEach((i) {
        items.add(SearchItem(item: i, type: "Product"));
      });
    });

    notifyListeners();
    return items;
  }

  Future<List<SearchItem>> SearchQuote(
      BuildContext context, String search) async {
    //  await DjangoServices().getQuotes().then((value) {
    List<Quote> value = Provider.of<EntityModification>(context).quotes;
    try {
      value
          .where((element) => element.quote_number.toString().contains(search))
          .forEach((i) {
        items.add(SearchItem(item: i, type: "Quote"));
      });

      value.forEach((quote) {
        Provider.of<EntityModification>(context, listen: false)
            .accounts
            .where((account) => account.id == quote.accountId)
            .forEach((element) {
          if (element.name!.contains(search)) {
            items.add(SearchItem(item: quote, type: "Quote"));
          }
        });
      });

      value.forEach((quote) {
        Provider.of<EntityModification>(context, listen: false)
            .accounts
            .where((account) => account.id == quote.accountId)
            .forEach((element) {
          if (element.phone != null && element.phone!.contains(search)) {
            items.add(SearchItem(item: quote, type: "Quote"));
          }
        });
      });

      value.forEach((quote) {
        Provider.of<EntityModification>(context, listen: false)
            .contacts
            .where((contact) => contact.id == quote.contactId)
            .forEach((element) {
          if (element.first_name!.contains(search)) {
            items.add(SearchItem(item: quote, type: "Quote"));
          }
        });
      });

      value.forEach((quote) {
        Provider.of<EntityModification>(context, listen: false)
            .contacts
            .where((contact) => contact.id == quote.contactId)
            .forEach((element) {
          if (element.last_name!.contains(search)) {
            items.add(SearchItem(item: quote, type: "Quote"));
          }
        });
      });

      value.forEach((quote) {
        Provider.of<EntityModification>(context, listen: false)
            .contacts
            .where((contact) => contact.id == quote.contactId)
            .forEach((element) {
          if (element.phone != null && element.phone!.contains(search)) {
            items.add(SearchItem(item: quote, type: "Quote"));
          }
        });
      });
    } catch (e) {
      print(e.toString());
    }

    notifyListeners();
    return items;
  }

  Future<List<SearchItem>> SearchOrder(
      BuildContext context, String search) async {
    //await DjangoServices().getOrders().then((value) {
    List<Order> value = Provider.of<EntityModification>(context).order;
    try {
      value
          .where((element) => element.order_number.toString().contains(search))
          .forEach((i) {
        items.add(SearchItem(item: i, type: "Order"));
      });

      value.forEach((order) {
        Provider.of<EntityModification>(context, listen: false)
            .accounts
            .where((account) => account.id == order.accountId)
            .forEach((element) {
          if (element.name!.contains(search)) {
            items.add(SearchItem(item: order, type: "Order"));
          }
        });
      });

      value.forEach((order) {
        Provider.of<EntityModification>(context, listen: false)
            .accounts
            .where((account) => account.id == order.accountId)
            .forEach((element) {
          if (element.phone != null && element.phone!.contains(search)) {
            items.add(SearchItem(item: order, type: "Order"));
          }
        });
      });

      value.forEach((order) {
        Provider.of<EntityModification>(context, listen: false)
            .contacts
            .where((contact) => contact.id == order.contactId)
            .forEach((element) {
          if (element.first_name!.contains(search)) {
            items.add(SearchItem(item: order, type: "Order"));
          }
        });
      });

      value.forEach((order) {
        Provider.of<EntityModification>(context, listen: false)
            .contacts
            .where((contact) => contact.id == order.contactId)
            .forEach((element) {
          if (element.last_name!.contains(search)) {
            items.add(SearchItem(item: order, type: "Order"));
          }
        });
      });

      value.forEach((order) {
        Provider.of<EntityModification>(context, listen: false)
            .contacts
            .where((contact) => contact.id == order.contactId)
            .forEach((element) {
          if (element.phone != null && element.phone!.contains(search)) {
            items.add(SearchItem(item: order, type: "Order"));
          }
        });
      });
    } catch (e) {
      print(e.toString());
    }

    notifyListeners();
    return items;
  }

  Future<List<SearchItem>> SearchAllObjects(
      BuildContext context, String search) async {
    List<Account> _accounts = Provider.of<EntityModification>(context).accounts;
    _accounts
        .where((element) => element.name.toString().contains(search))
        .forEach((i) {
      items.add(SearchItem(item: i, type: "Account"));
    });
    _accounts
        .where((element) => element.phone.toString().contains(search))
        .forEach((i) {
      items.add(SearchItem(item: i, type: "Account"));
    });
    _accounts
        .where((element) => element.account_number.toString().contains(search))
        .forEach((i) {
      items.add(SearchItem(item: i, type: "Account"));
    });

    await Repository().getContacts().then((value) {
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

    await Repository().getOrders().then((value) {
      value
          ?.where((element) => element.order_number.toString().contains(search))
          .forEach((i) {
        items.add(SearchItem(item: i, type: "Order"));
      });
    });

    await Repository().getQuotes().then((value) {
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
