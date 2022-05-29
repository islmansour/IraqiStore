import 'package:flutter/material.dart';
import 'package:hardwarestore/components/order.dart';
import 'package:hardwarestore/services/django_services.dart';
import 'package:hardwarestore/services/tools.dart';
import 'package:provider/provider.dart';

import '../models/order_item.dart';
import '../models/orders.dart';

class OrderItemsList extends StatefulWidget {
  final Order order;

  OrderItemsList({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderItemsList> createState() => _OrderItemsListState();
}

class _OrderItemsListState extends State<OrderItemsList> {
  List<OrderItem>? myOrderItems;
  var isLoaded = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<OrderItem>?>(
        future: DjangoServices().getOrderItems(widget.order.id),
        builder: (context, AsyncSnapshot<List<OrderItem>?> orderItemsSnap) {
          if (orderItemsSnap.connectionState == ConnectionState.none &&
              // ignore: unnecessary_null_comparison
              orderItemsSnap.hasData == null) {
            return Container();
          }
          int len = orderItemsSnap.data?.length ?? 0;
          double? sum = 0;

          Provider.of<OrderModification>(context)
              .order
              .where(
                (element) => element.id == widget.order.id,
              )
              .first
              .orderItems = orderItemsSnap.data;
          orderItemsSnap.data?.forEach(
            (element) {
              sum = element.price! + sum!;
            },
          );

          return Container();
        });
  }
}
