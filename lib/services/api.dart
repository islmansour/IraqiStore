import 'dart:io';

import 'package:hardwarestore/models/account_contact.dart';
import 'package:hardwarestore/models/legal_document.dart';
import 'package:hardwarestore/models/orders.dart';
import 'package:hardwarestore/models/products.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' show json, jsonEncode, utf8;
import 'dart:async';

import '../models/account.dart';
import '../models/contact.dart';
import '../models/delivery.dart';
import '../models/lov.dart';
import '../models/order_item.dart';
import '../models/quote.dart';
import '../models/quote_item.dart';
import '../models/user.dart';

class ApiBaseHelper {
  late String? _baseUrl;
  Map<String, String> headers = {
    'content-type': 'application/json',
  };

  String get apiURL => _baseUrl!;

  //String ipaddress = '139.162.139.161';
  //final String _baseUrl = 'http://127.0.0.1:8000';
  //final String _baseUrl = 'http://139.162.139.161:8000';

  Future<dynamic> get(String url) async {
    var _pref = await SharedPreferences.getInstance();
    _baseUrl = _pref.get('ipAddress').toString();

    try {
      if (!url.contains('get_user_by_uid')) {
        final String? userId = _pref.getString('username');
        headers['UID'] = userId!;
      } else {}
    } catch (e) {
      print('API 001 error: $e');
    }

    var responseJson;
    try {
      final response =
          await http.get(Uri.parse(_baseUrl! + url), headers: headers);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> post(String url, {Object? body}) async {
    var _pref = await SharedPreferences.getInstance();
    _baseUrl = _pref.get('ipAddress').toString();
    var responseJson;
    try {
      final response = await http.post(Uri.parse(_baseUrl! + url),
          headers: headers, body: jsonEncode(body));
      // final response = await http.get(Uri.parse(_baseUrl + url));
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = utf8.decode(response.body.runes.toList());
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}

class AppException implements Exception {
  final _message;
  final _prefix;

  AppException([this._message, this._prefix]);

  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends AppException {
  FetchDataException([String? message])
      : super(message, "Error During Communication: ");
}

class BadRequestException extends AppException {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

class UnauthorisedException extends AppException {
  UnauthorisedException([message]) : super(message, "Unauthorised: ");
}

class InvalidInputException extends AppException {
  InvalidInputException([String? message]) : super(message, "Invalid Input: ");
}

class ApiResponse<T> {
  Status? status;
  T? data;
  String? message;

  ApiResponse.loading(this.message) : status = Status.LOADING;
  ApiResponse.completed(this.data) : status = Status.COMPLETED;
  ApiResponse.error(this.message) : status = Status.ERROR;

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $data";
  }
}

enum Status { LOADING, COMPLETED, ERROR } // TO BE USED IN BLOC

class Repository {
  final ApiBaseHelper _helper = ApiBaseHelper();
/////////////////////////// START QUOTES
  Future<List<Quote>?> getQuotes() async {
    final response = await _helper.get("/IraqiStore/quote_list");
    return quoteFromJson(response);
  }

  Future<int>? upsertQuote(Quote quote) async {
    final response = await _helper.post(
        '/IraqiStore/upsert_quote/' + quote.id.toString(),
        body: quote.toJson());

    return int.parse(response.toString());
  }

  Future<int>? upsertQuoteItem(QuoteItem quoteItem) async {
    var response = await _helper.post(
        '/IraqiStore/upsert_quote_item/' + quoteItem.id.toString(),
        body: quoteItem.toJson());
    return int.parse(response.toString());
  }

  Future<bool> deleteQuoteItem(int quoteItem) async {
    await _helper.post('/IraqiStore/delete_quote_item/' + quoteItem.toString());
    return true;
  }

  Future<List<QuoteItem>?> getQuoteItems(int quoteId) async {
    final response =
        await _helper.get("/IraqiStore/quote_item_list" + quoteId.toString());
    return quoteItemFromJson(response);
  }
  /////////////////////////// END QUOTES

/////////////////////////// START ORDERS
  Future<List<Order>?> getOrders() async {
    final response = await _helper.get("/IraqiStore/order_list");
    return orderFromJson(response);
  }

  Future<int>? upsertOrder(Order order) async {
    final response = await _helper.post(
        '/IraqiStore/upsert_order/' + order.id.toString(),
        body: order.toJson());

    return int.parse(response.toString());
  }

  Future<int>? upsertOrderV2(Order order) async {
    final response = await _helper.post(
        '/IraqiStore/upsert_order/' + order.id.toString(),
        body: order.toJson());

    if (order.orderItems != null)
      order.orderItems!.forEach((element) {
        element.orderId = int.parse(response.toString());
        upsertOrderItem(element);
      });

    return int.parse(response.toString());
  }

  Future<int>? upsertOrderItem(OrderItem orderItem) async {
    var response = await _helper.post(
        '/IraqiStore/upsert_order_item/' + orderItem.id.toString(),
        body: orderItem.toJson());
    return int.parse(response.toString());
  }

  Future<bool> deleteOrderItem(int orderItem) async {
    await _helper.post('/IraqiStore/upsert_order_item/' + orderItem.toString());
    return true;
  }

  Future<List<OrderItem>?> getOrderItems(int orderId) async {
    final response =
        await _helper.get("/IraqiStore/order_item_list" + orderId.toString());
    return orderItemFromJson(response);
  }

/////////////////////////// END ORDERS
  ///
/////////////////////////// START Product
  Future<List<Product>?> getProducts() async {
    final response = await _helper.get("/IraqiStore/product_list");
    return productFromJson(response);
  }

  Future<int>? upsertProduct(Product product) async {
    final response = await _helper.post(
        '/IraqiStore/upsert_product/' + product.id.toString(),
        body: product.toJson());

    return int.parse(response.toString());
  }

  /////////////////////////// END PRODUCT

  /////////////////////////// START ACCOUNT
  Future<List<Account>?> getAccountByUser(String contactId) async {
    try {
      final response =
          await _helper.get("/IraqiStore/get_accounts_by_user/$contactId");

      List<Account> _results = accountFromJson(response);
      _results.forEach((element) async {
        element.accountContacts = <Contact>[];
        element.accountContacts =
            await getAccountContact(element.id.toString());

        element.accountOrders = await getAccountOrders(element.id.toString());
        element.accountQuotes = await getAccountQuotes(element.id.toString());
      });

      return _results;
    } catch (e) {}
    return <Account>[];
  }

  Future<List<Account>?> getAccounts() async {
    final response = await _helper.get("/IraqiStore/account_list");
    try {
      List<Account> _results = accountFromJson(response);
      _results.forEach((element) async {
        element.accountContacts = <Contact>[];
        element.accountContacts =
            await getAccountContact(element.id.toString());

        element.accountOrders = await getAccountOrders(element.id.toString());
        element.accountQuotes = await getAccountQuotes(element.id.toString());
      });

      return _results;
    } catch (e) {}
    return <Account>[];
  }

  Future<int>? upsertAccount(Account account) async {
    final response = await _helper.post(
        '/IraqiStore/upsert_account/' + account.id.toString(),
        body: account.toJson());

    return int.parse(response.toString());
  }

  /////////////////////////// END ACCOUNT

  /////////////////////////// START CONTACT

  Future<List<Contact>?> getContacts() async {
    final response = await _helper.get("/IraqiStore/contact_list");

    return contactFromJson(response);
  }

  Future<Contact?> getSingleContact(String contactId) async {
    try {
      final response =
          await _helper.get("/IraqiStore/single_contact/" + contactId);

      if (contactFromJson(response).isNotEmpty)
        return contactFromJson(response).first;
      else
        return null;
    } catch (e) {}
    return null;
  }

  Future<int>? upsertContact(Contact contact) async {
    final response = await _helper.post(
        '/IraqiStore/upsert_contact/' + contact.id.toString(),
        body: contact.toJson());

    return int.parse(response.toString());
  }

  /////////////////////////// END ACCOUNT

  /////////////////////////// START RELATED ENTITIES
  ///
  Future<List<Contact>?> getAccountContact(String _account) async {
    final response =
        await _helper.get("/IraqiStore/get_account_contacts/" + _account);
    return contactFromJson(response);
  }

  Future<int>? insertAccountContact(AccountContact ac) async {
    final response = await _helper.post('/IraqiStore/insert_account_contact/',
        body: ac.toJson());

    return int.parse(response.toString());
  }

  Future<bool> deleteAccountContact(int? accountId, int? contactId) async {
    await _helper.post(
        '/IraqiStore/delete_account_contact/${accountId.toString()}/${contactId.toString()}');
    return true;
  }

  Future<List<Order>?> getAccountOrders(String _account) async {
    final response =
        await _helper.get("/IraqiStore/order_list_by_account/" + _account);
    return orderFromJson(response);
  }

  Future<List<Quote>?> getAccountQuotes(String _account) async {
    final response =
        await _helper.get("/IraqiStore/quote_list_by_account/" + _account);
    return quoteFromJson(response);
  }

  Future<List<LegalDocument>?> getFormsByAccount(String _account) async {
    final response =
        await _helper.get("/IraqiStore/get_legal_docs_by_account/" + _account);
    return legalDocumentFromJson(response);
  }

  Future<List<LegalDocument>?> getFormsByContact(String _contact) async {
    final response =
        await _helper.get("/IraqiStore/get_legal_docs_by_contact/" + _contact);
    return legalDocumentFromJson(response);
  }

  /////////////////////////// END RELATED ENTITIES
  /// LEGEL DOC
  ///
  Future<int>? upsertLegalDocument(LegalDocument doc) async {
    final response = await _helper.post(
        '/IraqiStore/upsert_legal_document/' + doc.id.toString(),
        body: doc.toJson());
    return int.parse(response.toString());
  }

  /////////////////////////// START RELATED LIST OF VALUES
  Future<List<ListOfValues>?> getLOVs() async {
    final response = await _helper.get("/IraqiStore/lov");
    return lovFromJson(response);
  }
  /////////////////////////// END RELATED LIST OF VALUES

  /////////////////////////// START USERS
  Future<List<AppUser>?> getUser(String id) async {
    String _ip = "";
    SharedPreferences.getInstance().then((value) {
      _ip = value.get('ipAddress').toString();
      value.setString('ipAddress', 'http://www.arabapps.biz:8000');
    });
    final response = await _helper.get("/IraqiStore/get_single_user/" + id);
    SharedPreferences.getInstance().then((value) {
      if (_ip == null || _ip == "") {
        value.setString('ipAddress', 'http://www.arabapps.biz:8000');
      } else
        value.setString('ipAddress', _ip);
    });
    return userFromJson(response);
  }

  Future<List<AppUser>?> getUsers() async {
    final response = await _helper.get("/IraqiStore/get_users");
    return userFromJson(response);
  }

  Future<List<AppUser>?> getUserByLogin(String login) async {
    String _ip = "";
    SharedPreferences.getInstance().then((value) {
      _ip = value.get('ipAddress').toString();
      value.setString('ipAddress', 'http://www.arabapps.biz:8000');
    });
    final response = await _helper.get("/IraqiStore/get_user_by_uid/" + login);

    SharedPreferences.getInstance().then((value) {
      if (_ip == null || _ip == "") {
        value.setString('ipAddress', 'http://www.arabapps.biz:8000');
      } else
        value.setString('ipAddress', _ip);
    });
    return userFromJson(response);
  }

  Future<int>? upsertUser(AppUser user) async {
    var _pref = await SharedPreferences.getInstance();
    var _baseUrl = _pref.get('ipAddress').toString();
    _pref.setString('ipAddress', 'http://arabapps.biz:8000');
    final response = await _helper.post(
        '/IraqiStore/upsert_user/' + user.id.toString(),
        body: user.toJson());
    _pref.setString('ipAddress', _baseUrl);

    return int.parse(response.toString());
  }

  /////////////////////////// END USERS
  Future<List<Delivery>?> getDeliverys() async {
    final response = await _helper.get("/IraqiStore/delivery_list");
    return deliveryFromJson(response);
  }

  Future<int>? upsertDelivery(Delivery delivery) async {
    final response = await _helper.post(
        '/IraqiStore/upsert_delivery/' + delivery.id.toString(),
        body: delivery.toJson());

    return int.parse(response.toString());
  }
}
