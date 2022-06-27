// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hardwarestore/models/account.dart';
import 'package:hardwarestore/models/quote_item.dart';
import 'package:hardwarestore/models/user.dart';
import 'package:hardwarestore/services/api.dart';

import '../models/contact.dart';
import '../models/delivery.dart';

import '../models/lov.dart';
import '../models/order_item.dart';
import '../models/orders.dart';
import '../models/products.dart';
import '../models/quote.dart';

class EntityModification extends ChangeNotifier {
  String? environmentIp;

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
    _order.sort((a, b) => a.order_number!.compareTo(b.order_number!));

    notifyListeners();
  }

  Future<List<OrderItem>?> getOrderItemsForOrder(int orderId) async {
    // return DjangoServices().getOrderItems(orderId);
    return Repository().getOrderItems(orderId);
  }

  refreshOrdersFromDB() async {
    _order = (await Repository().getOrders())!;
    notifyListeners();
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
    _quotes.sort((a, b) => a.quote_number!.compareTo(b.quote_number!));

    notifyListeners();
  }

  Future<List<QuoteItem>?> getQuoteItemsForOrder(int quoteId) async {
    //return DjangoServices().getQuoteItems(quoteId);
    return Repository().getQuoteItems(quoteId);
  }

  refreshQuotesFromDB() async {
    // _quotes = (await DjangoServices().getQuotes())!;\
    _quotes = (await Repository().getQuotes())!;
    notifyListeners();
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
    _products.sort((a, b) => a.product_number!.compareTo(b.product_number!));

    notifyListeners();
  }

  refreshProductsFromDB() async {
    _products = (await Repository().getProducts())!;
    notifyListeners();
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
    _accounts.sort((a, b) => a.account_number!.compareTo(b.account_number!));

    notifyListeners();
  }

  refreshAccountsFromDB() async {
    _accounts = (await Repository().getAccounts())!;
    notifyListeners();
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

  refreshContactsFromDB() async {
    _contacts = (await Repository().getContacts())!;
    notifyListeners();
  }

  List<AppUser> _users = <AppUser>[];
  refreshUsersFromDB() async {
    _users = (await Repository().getUsers())!;
    notifyListeners();
  }
  ///////////////////////////////////////////////////////////////////////////////////
  /// Delivery

  List<Delivery> _deliveries = <Delivery>[];
  List<Delivery> get deliveries =>
      _deliveries; // just a getter to access the local list of orders

  set deliveries(List<Delivery> initDeliviries) {
    // a setter to set the list of global orders.
    _deliveries = initDeliviries;
  }

  void updateDelivery(Delivery update) {
    _deliveries.removeWhere((element) => element.id == update.id);

    _deliveries.add(update);

    notifyListeners();
  }

  refreshDeliveriesFromDB() async {
    _deliveries = (await Repository().getDeliverys())!;
    notifyListeners();
  }

  ///////////////////////////////////////////////////////////////////////////////////
  /// LOV
  List<ListOfValues> _activeListOfValues = [];
  List<ListOfValues> get lov => _activeListOfValues;
  set lov(List<ListOfValues> initLOV) {
    // a setter to set the list of global orders.
    _activeListOfValues = initLOV;
  }

  refreshLOVFromDB() async {
    _activeListOfValues = (await Repository().getLOVs())!;
    notifyListeners();
  }

  String? getLovValue(String type, String name, String locale) {
    if (name == null || name.isEmpty || type == null || locale == null) {
      return '';
    } else {
      var _lovRecord = lov.where((element) => (element.type == type &&
          element.name == name &&
          element.language == locale &&
          element.active == true));
      if (_lovRecord != null && _lovRecord.isNotEmpty) {
        return _lovRecord.first.value;
      }
      return '';
    }
  }
}

class Environment extends ChangeNotifier {
  String? production;
  String? test;
  String? dev;

  Environment({this.dev, this.production, this.test});

  factory Environment.fromJson(Map<String, dynamic> json) {
    return Environment(
      test: json['test'] as String?,
      production: json['production'] as String?,
      dev: json['test'] as String?,
    );
  }
}

List<Environment> envFromJson(String str) {
  return List<Environment>.from(
      json.decode(str).map((x) => Environment.fromJson(x)));
}
