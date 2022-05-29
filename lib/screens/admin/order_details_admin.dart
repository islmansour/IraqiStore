import 'package:flutter/material.dart';
import 'package:hardwarestore/components/admin/order_item_list_component.dart';
import 'package:hardwarestore/widgets/order_mini_admin.dart';

import '../../models/orders.dart';
import '../../widgets/admin_bubble_order.dart';

class OrderDetailAdmin extends StatefulWidget {
  final Order item;
  const OrderDetailAdmin({Key? key, required this.item}) : super(key: key);

  @override
  State<OrderDetailAdmin> createState() => _OrderDetailAdminState();
}

class _OrderDetailAdminState extends State<OrderDetailAdmin> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: OrderBubbleButtons(orderId: widget.item.id),
      body: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.max, children: [
        OrderDetaulsNoInkWell(
          item: widget.item,
        ),
        OrderItemList(
          orderId: widget.item.id,
        ),
      ])),
      appBar: AppBar(
        title: Text('הזמנה מס ' + widget.item.id.toString()),
      ),
      // bottomNavigationBar: const AdminBottomNav(1),
    );
  }
}
