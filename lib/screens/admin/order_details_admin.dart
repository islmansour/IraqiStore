import 'package:flutter/material.dart';
import 'package:hardwarestore/components/admin/order_item_list_component.dart';
import 'package:hardwarestore/widgets/order_mini_admin.dart';

import '../../models/orders.dart';

class OrderDetailAdmin extends StatelessWidget {
  final Order item;
  const OrderDetailAdmin({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.max, children: [
        OrderMiniAdmin(
          item: item,
        ),
        OrderItemList(
          orderId: item.id.toString(),
        )
      ])),
      appBar: AppBar(
        title: Text('הזמנה מס ' + item.id.toString()),
      ),
      // bottomNavigationBar: const AdminBottomNav(1),
    );
  }
}
