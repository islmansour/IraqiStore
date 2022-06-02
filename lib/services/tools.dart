import 'package:flutter/material.dart';
import 'package:hardwarestore/models/account.dart';
import 'package:hardwarestore/models/quote_item.dart';
import 'package:hardwarestore/services/django_services.dart';

import '../models/contact.dart';
import '../models/order_item.dart';
import '../models/orders.dart';
import '../models/products.dart';
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

///////////////////////////////////////////////////////////////////////////////////
  /// Products
  List<Product> _products = <Product>[];
  List<Product> get products =>
      _products; // just a getter to access the local list of orders

  set products(List<Product> initProductSet) {
    // a setter to set the list of global orders.
    _products = initProductSet;
  }

  void updateProduct(Product update) {
    _products.removeWhere((element) => element.id == update.id);

    _products.add(update);

    notifyListeners();
  }

  void refreshProductsFromDB() async {
    _products = (await DjangoServices().getProducts())!;
  }

  ///////////////////////////////////////////////////////////////////////////////////
  /// Accounts
  List<Account> _accounts = <Account>[];
  List<Account> get accounts =>
      _accounts; // just a getter to access the local list of orders

  set accounts(List<Account> initAccounts) {
    // a setter to set the list of global orders.
    _accounts = initAccounts;
  }

  void updateAccount(Account update) {
    _accounts.removeWhere((element) => element.id == update.id);

    _accounts.add(update);

    notifyListeners();
  }

  void refreshAccountsFromDB() async {
    _accounts = (await DjangoServices().getAccounts())!;
  }

  ///////////////////////////////////////////////////////////////////////////////////
  /// Contacts
  List<Contact> _contacts = <Contact>[];
  List<Contact> get contacts =>
      _contacts; // just a getter to access the local list of orders

  set contacts(List<Contact> initContacts) {
    // a setter to set the list of global orders.
    _contacts = initContacts;
  }

  void updateContact(Contact update) {
    _contacts.removeWhere((element) => element.id == update.id);

    _contacts.add(update);

    notifyListeners();
  }

  void refreshContactsFromDB() async {
    _contacts = (await DjangoServices().getContacts())!;
  }
}
