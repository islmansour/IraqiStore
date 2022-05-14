import 'package:hardwarestore/models/order_item.dart';

import '../models/orders.dart';
import 'package:http/http.dart' as http;

class DjangoServices {
  Future<List<Order>?> getOrders() async {
    var client = http.Client();
    var uri = Uri.parse('http://139.162.139.161:8000/IraqiStore/order_list');

    var response = await client.get(uri);
    if (response.statusCode == 200) {
      String json = response.body;
      return orderFromJson(json);
    }
    return null;
  }

  Future<List<OrderItem>?> getOrderItems() async {
    var client = http.Client();
    var uri =
        Uri.parse('http://139.162.139.161:8000/IraqiStore/order_item_listt');

    var response = await client.get(uri);
    if (response.statusCode == 200) {
      String json = response.body;
      return orderItemFromJson(json);
    }

    return null;
  }
}
