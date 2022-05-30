import 'package:flutter/material.dart';
import 'package:hardwarestore/models/quote_item.dart';
import 'package:hardwarestore/services/django_services.dart';

import '../models/order_item.dart';
import '../models/orders.dart';
import '../models/quote.dart';

class EntityModification extends ChangeNotifier {
  // a global orders
  List<Order> _order = <Order>[];
  List<Order> get order =>
      _order; // just a getter to access the local list of orders

  set orders(List<Order> initOrdersSet) {
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

  List<Quote> _quotes = <Quote>[];
  List<Quote> get quotes =>
      _quotes; // just a getter to access the local list of orders

  set quotes(List<Quote> initOrdersSet) {
    // a setter to set the list of global orders.
    _quotes = initOrdersSet;
  }

  void updateQuote(Quote update) {
    _quotes.removeWhere((element) => element.id == update.id);

    _quotes.add(update);

    notifyListeners();
  }

  Future<List<QuoteItem>?> getQuoteItemsForOrder(int quoteId) async {
    return DjangoServices().getQuoteItems(quoteId);
  }

  void refreshQuotesFromDB() async {
    _quotes = (await DjangoServices().getQuotes())!;
  }
}
