import 'package:hardwarestore/components/order.dart';
import 'package:hardwarestore/models/account.dart';
import 'package:hardwarestore/models/contact.dart';
import 'package:hardwarestore/models/delivery.dart';
import 'package:hardwarestore/models/lov.dart';
import 'package:hardwarestore/models/news.dart';
import 'package:hardwarestore/models/order_item.dart';
import '../models/orders.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show utf8;
import '../models/products.dart';
import '../models/quote.dart';
import '../models/quote_item.dart';

class DjangoServices {
  Future<List<Order>?> getOrders() async {
    var client = http.Client();
    var uri = Uri.parse('http://139.162.139.161:8000/IraqiStore/order_list');

    var response = await client.get(uri);
    if (response.statusCode == 200) {
      String json = response.body;
      json = utf8.decode(json.runes.toList());
      return orderFromJson(json);
    }
    return null;
  }

  Future<List<OrderItem>?> getOrderItems() async {
    var client = http.Client();
    var uri =
        Uri.parse('http://139.162.139.161:8000/IraqiStore/order_item_list');

    var response = await client.get(uri);
    if (response.statusCode == 200) {
      String json = response.body;
      json = utf8.decode(json.runes.toList());
      return orderItemFromJson(json);
    }
    return null;
  }

  Future<List<Quote>?> getQuotes() async {
    var client = http.Client();
    var uri = Uri.parse('http://139.162.139.161:8000/IraqiStore/quote_list');

    var response = await client.get(uri);
    if (response.statusCode == 200) {
      String json = response.body;
      json = utf8.decode(json.runes.toList());
      return quoteFromJson(json);
    }
    return null;
  }

  Future<List<QuoteItem>?> getQuoteItems() async {
    var client = http.Client();
    var uri =
        Uri.parse('http://139.162.139.161:8000/IraqiStore/quote_item_list');

    var response = await client.get(uri);
    if (response.statusCode == 200) {
      String json = response.body;
      json = utf8.decode(json.runes.toList());
      return quoteItemFromJson(json);
    }
    return null;
  }

  Future<List<Product>?> getProducts() async {
    var client = http.Client();
    var uri = Uri.parse('http://139.162.139.161:8000/IraqiStore/product_list');

    var response = await client.get(uri);
    if (response.statusCode == 200) {
      String json = response.body;
      json = utf8.decode(json.runes.toList());
      return productFromJson(json);
    }
    return null;
  }

  Future<List<News>?> getNews() async {
    var client = http.Client();
    var uri = Uri.parse('http://139.162.139.161:8000/IraqiStore/news_list');

    var response = await client.get(uri);
    if (response.statusCode == 200) {
      String json = response.body;
      json = utf8.decode(json.runes.toList());
      return newsFromJson(json);
    }
    return null;
  }

  Future<List<Delivery>?> getDeliverys() async {
    var client = http.Client();
    var uri = Uri.parse('http://139.162.139.161:8000/IraqiStore/news_delivery');

    var response = await client.get(uri);
    if (response.statusCode == 200) {
      String json = response.body;
      json = utf8.decode(json.runes.toList());
      return deliveryFromJson(json);
    }
    return null;
  }

  Future<List<Account>?> getAccounts() async {
    var client = http.Client();
    var uri = Uri.parse('http://139.162.139.161:8000/IraqiStore/account_list');

    var response = await client.get(uri);
    if (response.statusCode == 200) {
      String json = response.body;
      json = utf8.decode(json.runes.toList());
      return accountFromJson(json);
    }
    return null;
  }

  Future<List<Contact>?> getContacts() async {
    var client = http.Client();
    var uri = Uri.parse('http://139.162.139.161:8000/IraqiStore/contact_list');

    var response = await client.get(uri);
    if (response.statusCode == 200) {
      String json = response.body;
      json = utf8.decode(json.runes.toList());
      return contactFromJson(json);
    }
    return null;
  }

  Future<List<ListOfValues>?> getLOVs() async {
    var client = http.Client();
    var uri = Uri.parse('http://139.162.139.161:8000/IraqiStore/lov');

    var response = await client.get(uri);
    if (response.statusCode == 200) {
      String json = response.body;
      json = utf8.decode(json.runes.toList());
      return lovFromJson(json);
    }
    return null;
  }
}
