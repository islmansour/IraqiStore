import 'package:flutter/material.dart';

import '../models/orders.dart';

class OrderModification extends ChangeNotifier {
  List<Order> _order = <Order>[];
  List<Order> get order => _order;

  void set orders(List<Order> initOrdersSet) {
    _order = initOrdersSet;
  }

  void update(Order update) {
    bool _new = true;
    if (update.orderItems!.isNotEmpty) {
      update.orderItems!.forEach(
        (element) {
          if (element.price != null)
            print('price is: ' + element.price.toString());
        },
      );
      print('should be one less, number of items is : ' +
          update.orderItems!.length.toString());
    } else
      print('start upd: empty');

    _order.removeWhere((element) => element.id == update.id);
    if (_new) _order.add(update);

    notifyListeners();
  }
}
