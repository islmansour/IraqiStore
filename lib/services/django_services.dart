import 'package:hardwarestore/models/account.dart';
import 'package:hardwarestore/models/contact.dart';
import 'package:hardwarestore/models/delivery.dart';
import 'package:hardwarestore/models/lov.dart';
import 'package:hardwarestore/models/news.dart';
import 'package:hardwarestore/models/order_item.dart';
import '../models/orders.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show jsonEncode, utf8;
import '../models/products.dart';
import '../models/quote.dart';
import '../models/quote_item.dart';
import '../models/user.dart';

class DjangoServices {
  static const headers = {
    'content-type': 'application/json',
  };

  String ipaddress = '127.0.0.1';
  //String ipaddress = '139.162.139.161';

  // Future<List<Order>?> getOrders() async {
  //   var client = http.Client();
  //   var uri = Uri.parse('http://$ipaddress:8000/IraqiStore/order_list');

  //   var response = await client.get(uri);
  //   if (response.statusCode == 200) {
  //     String json = response.body;
  //     json = utf8.decode(json.runes.toList());

  //     return orderFromJson(json);
  //   }
  //   return null;
  // }

  // Future<int>? upsertOrder(Order order) async {
  //   var client = http.Client();
  //   var uri = Uri.parse('http://$ipaddress:8000/IraqiStore/upsert_order/' +
  //       order.id.toString());
  //   var _id = -1;
  //   var response = await client
  //       .post(uri, headers: headers, body: jsonEncode(order.toJson()))
  //       .then((value) {
  //     if (value.statusCode == 200) {
  //       return int.parse(value.body);
  //     } else {
  //       print('Error occured: ' + value.statusCode.toString());
  //     }
  //   });

  //   return int.parse(response.toString());
  // }

  // Future<int>? upsertOrderItem(OrderItem orderItem) async {
  //   var client = http.Client();

  //   var uri = Uri.parse('http://$ipaddress:8000/IraqiStore/upsert_order_item/' +
  //       orderItem.id.toString());
  //   var _id = -1;
  //   var response = await client.post(uri,
  //       headers: headers, body: jsonEncode(orderItem.toJson()));

  //   if (response.statusCode > -10) {
  //     int result = -1;
  //     try {
  //       result = int.parse(response.body.toString());
  //     } catch (e) {
  //       print('Error getting ID of orderItem. API result is: ' + e.toString());
  //       result = -1;
  //     }
  //     return result;
  //   }
  //   return -1;
  // }

  // Future<bool> deleteOrderItem(int orderItem) async {
  //   var client = http.Client();
  //   var uri = Uri.parse('http://$ipaddress:8000/IraqiStore/delete_order_item/' +
  //       orderItem.toString());
  //   await client.post(
  //     uri,
  //     headers: headers,
  //   );

  //   return true;
  // }

  // Future<List<OrderItem>?> getOrderItems(int orderId) async {
  //   var client = http.Client();
  //   var uri = Uri.parse('http://$ipaddress:8000/IraqiStore/order_item_list/' +
  //       orderId.toString());

  //   var response = await client.get(uri);
  //   if (response.statusCode == 200) {
  //     String json = response.body;
  //     json = utf8.decode(json.runes.toList());
  //     return orderItemFromJson(json);
  //   }
  //   return null;
  // }

  // Future<List<Quote>?> getQuotes() async {
  //   var client = http.Client();
  //   var uri = Uri.parse('http://$ipaddress:8000/IraqiStore/quote_list');

  //   var response = await client.get(uri);
  //   if (response.statusCode == 200) {
  //     String json = response.body;
  //     json = utf8.decode(json.runes.toList());

  //     return quoteFromJson(json);
  //   }
  //   return null;
  // }

  // Future<bool>? upsertQuote(Quote quote) async {
  //   var client = http.Client();
  //   var uri = Uri.parse('http://$ipaddress:8000/IraqiStore/upsert_quote/' +
  //       quote.id.toString());

  //   var response = await client
  //       .post(uri, headers: headers, body: jsonEncode(quote.toJson()))
  //       .then((value) {
  //     if (value.statusCode == 201) {
  //       return true;
  //     } else {
  //       print('Error occured: ' + value.statusCode.toString());
  //     }
  //   });

  //   return true;
  // }

  // Future<List<QuoteItem>?> getQuoteItems(int quoteId) async {
  //   var client = http.Client();
  //   var uri = Uri.parse(
  //       'http://$ipaddress:8000/IraqiStore/quote_item_list_by_quote/' +
  //           quoteId.toString());

  //   var response = await client.get(uri);
  //   if (response.statusCode == 200) {
  //     String json = response.body;
  //     json = utf8.decode(json.runes.toList());
  //     return quoteItemFromJson(json);
  //   }
  //   return null;
  // }

  // Future<int>? upsertQuoteItem(QuoteItem quoteItem) async {
  //   var client = http.Client();

  //   var uri = Uri.parse('http://$ipaddress:8000/IraqiStore/upsert_quote_item/' +
  //       quoteItem.id.toString());
  //   var _id = -1;
  //   var response = await client.post(uri,
  //       headers: headers, body: jsonEncode(quoteItem.toJson()));

  //   if (response.statusCode > -10) {
  //     int result = -1;
  //     try {
  //       result = int.parse(response.body.toString());
  //     } catch (e) {
  //       print('Error getting ID of quoteitem. API result is: ' + e.toString());
  //       result = -1;
  //     }
  //     return result;
  //   }
  //   return -1;
  // }

  // Future<bool> deleteQuoteItem(int qutoeItem) async {
  //   var client = http.Client();
  //   var uri = Uri.parse('http://$ipaddress:8000/IraqiStore/delete_quote_item/' +
  //       qutoeItem.toString());
  //   await client.post(
  //     uri,
  //     headers: headers,
  //   );

  //   return true;
  // }

  // Future<List<Product>?> getProducts() async {
  //   var client = http.Client();
  //   var uri = Uri.parse('http://$ipaddress:8000/IraqiStore/product_list');

  //   var response = await client.get(uri);
  //   if (response.statusCode == 200) {
  //     String json = response.body;
  //     json = utf8.decode(json.runes.toList());
  //     return productFromJson(json);
  //   }
  //   return null;
  // }

  // Future<bool>? upsertProduct(Product product) async {
  //   var client = http.Client();
  //   var uri = Uri.parse('http://$ipaddress:8000/IraqiStore/upsert_product/' +
  //       product.id.toString());

  //   var response = await client
  //       .post(uri, headers: headers, body: jsonEncode(product.toJson()))
  //       .then((value) {
  //     if (value.statusCode == 201) {
  //       return true;
  //     } else {
  //       print('Error occured:L ' + value.statusCode.toString());
  //     }
  //   });

  //   return true;
  // }

  // Future<List<News>?> getNews() async {
  //   var client = http.Client();
  //   var uri = Uri.parse('http://$ipaddress:8000/IraqiStore/news_list');

  //   var response = await client.get(uri);
  //   if (response.statusCode == 200) {
  //     String json = response.body;
  //     json = utf8.decode(json.runes.toList());
  //     return newsFromJson(json);
  //   }
  //   return null;
  // }

  // Future<List<Delivery>?> getDeliverys() async {
  //   var client = http.Client();
  //   var uri = Uri.parse('http://$ipaddress:8000/IraqiStore/news_delivery');

  //   var response = await client.get(uri);
  //   if (response.statusCode == 200) {
  //     String json = response.body;
  //     json = utf8.decode(json.runes.toList());
  //     return deliveryFromJson(json);
  //   }
  //   return null;
  // }

  // Future<List<Contact>?> getAccountContact(String _account) async {
  //   var client = http.Client();
  //   var uri = Uri.parse(
  //       'http://$ipaddress:8000/IraqiStore/get_account_contacts/' + _account);

  //   var response = await client.get(uri);

  //   if (response.statusCode == 200) {
  //     String json = response.body;
  //     json = utf8.decode(json.runes.toList());
  //     return contactFromJson(json);
  //   }
  //   return null;
  // }

  // Future<List<Order>?> getAccountOrders(String _account) async {
  //   var client = http.Client();
  //   var uri = Uri.parse(
  //       'http://$ipaddress:8000/IraqiStore/order_list_by_account/' + _account);

  //   var response = await client.get(uri);

  //   if (response.statusCode == 200) {
  //     String json = response.body;
  //     json = utf8.decode(json.runes.toList());
  //     return orderFromJson(json);
  //   }
  //   return null;
  // }

  // Future<List<Quote>?> getAccountQuotes(String _account) async {
  //   var client = http.Client();
  //   var uri = Uri.parse(
  //       'http://$ipaddress:8000/IraqiStore/quote_list_by_account/' + _account);

  //   var response = await client.get(uri);

  //   if (response.statusCode == 200) {
  //     String json = response.body;
  //     json = utf8.decode(json.runes.toList());
  //     return quoteFromJson(json);
  //   }
  //   return null;
  // }

  // Future<List<Account>?> getAccounts() async {
  //   print('called..${DateTime.now()}');
  //   var client = http.Client();
  //   var uri = Uri.parse('http://$ipaddress:8000/IraqiStore/account_list');

  //   var response = await client.get(uri);
  //   if (response.statusCode == 200) {
  //     String json = response.body;
  //     json = utf8.decode(json.runes.toList());
  //     List<Account> _results = accountFromJson(json);
  //     _results.forEach((element) async {
  //       element.accountContacts = <Contact>[];
  //       element.accountContacts =
  //           await getAccountContact(element.id.toString());

  //       element.accountOrders = await getAccountOrders(element.id.toString());
  //       element.accountQuotes = await getAccountQuotes(element.id.toString());
  //     });

  //     return _results;
  //   }
  //   return null;
  // }

  // Future<bool>? upsertAccount(Account account) async {
  //   var client = http.Client();
  //   var uri = Uri.parse('http://$ipaddress:8000/IraqiStore/upsert_account/' +
  //       account.id.toString());

  //   var response = await client
  //       .post(uri, headers: headers, body: jsonEncode(account.toJson()))
  //       .then((value) {
  //     if (value.statusCode == 200) {
  //       print('success 200');
  //       return true;
  //     } else {
  //       print('Error occured:L ' + value.statusCode.toString());
  //     }
  //   });

  //   return true;
  // }

  // Future<List<Contact>?> getContacts() async {
  //   var client = http.Client();
  //   var uri = Uri.parse('http://$ipaddress:8000/IraqiStore/contact_list');

  //   var response = await client.get(uri);
  //   if (response.statusCode == 200) {
  //     String json = response.body;
  //     json = utf8.decode(json.runes.toList());
  //     return contactFromJson(json);
  //   }
  //   return null;
  // }

  // Future<List<User>?> getUser(String id) async {
  //   var client = http.Client();
  //   var uri = Uri.parse('http://${ipaddress}:8000/IraqiStore/get_user/' + id);

  //   var response = await client.get(uri);
  //   if (response.statusCode == 200) {
  //     String json = response.body;
  //     print(json.toString());
  //     json = utf8.decode(json.runes.toList());
  //     return userFromJson(json);
  //   }
  //   return null;
  // }

  // Future<List<ListOfValues>?> getLOVs() async {
  //   var client = http.Client();
  //   var uri = Uri.parse('http://$ipaddress:8000/IraqiStore/lov');

  //   var response = await client.get(uri);
  //   if (response.statusCode == 200) {
  //     String json = response.body;
  //     json = utf8.decode(json.runes.toList());
  //     return lovFromJson(json);
  //   }
  //   return null;
  // }
}
