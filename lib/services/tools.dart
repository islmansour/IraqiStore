import 'package:flutter/material.dart';
import 'package:hardwarestore/services/django_services.dart';

import '../models/order_item.dart';
import '../models/orders.dart';

class OrderModification extends ChangeNotifier {
  // a global orders
  List<Order> _order = <Order>[];
  List<Order> get order =>
      _order; // just a getter to access the local list of orders

  void set orders(List<Order> initOrdersSet) {
    // a setter to set the list of global orders.
    _order = initOrdersSet;
  }

// once we have a new order, or an order (or one of it's attributes was changed),
// update the global oders list, and notify the listeners in the app, for example
// places were we display total amount of the order.
  void update(Order update) {
    _order.removeWhere((element) => element.id == update.id);

    _order.add(update);

    notifyListeners();
  }

  Future<List<OrderItem>?> getOrderItemsForOrder(int orderId) async {
    return DjangoServices().getOrderItems(orderId);
  }

  void refreshOrdersFromDB() async {
    _order = (await DjangoServices().getOrders())!;
  }
}
