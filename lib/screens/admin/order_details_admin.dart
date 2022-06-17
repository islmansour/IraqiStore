import 'package:flutter/material.dart';
import 'package:hardwarestore/components/admin/order_item_list_component.dart';
import 'package:hardwarestore/widgets/order_mini_admin.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      floatingActionButton: OrderBubbleButtons(order: widget.item),
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
        title: Text(AppLocalizations.of(context)!.orderNum +
            " " +
            widget.item.order_number.toString()),
      ),
      // bottomNavigationBar: const AdminBottomNav(1),
    );
  }
}
