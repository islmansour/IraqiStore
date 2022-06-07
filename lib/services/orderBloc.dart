import 'dart:async';

import 'package:hardwarestore/services/api.dart';

import '../models/orders.dart';

class OrderBloc {
  Repository? _repository;

  StreamController? _orderListController;

  StreamSink get movieListSink => _orderListController!.sink;

  Stream? get movieListStream => _orderListController?.stream;

  OrderBloc() {
    _orderListController = StreamController<ApiResponse<List<Order>>>();
    _repository = Repository();
    fetchOrderList();
  }

  fetchOrderList() async {
    movieListSink.add(ApiResponse.loading('Fetching Popular Movies'));
    try {
      List<Order>? orders = await _repository?.getOrders();
      movieListSink.add(ApiResponse.completed(orders));
    } catch (e) {
      movieListSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  dispose() {
    _orderListController?.close();
  }
}
