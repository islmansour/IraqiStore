import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hardwarestore/components/order.dart';
import 'package:hardwarestore/models/order_item.dart';
import 'package:hardwarestore/models/orders.dart';
import 'package:hardwarestore/services/django_services.dart';
import 'package:hardwarestore/widgets/order_item_admin.dart';
import 'package:provider/provider.dart';

import '../../screens/admin/order_details_admin.dart';
import '../../services/tools.dart';

class OrderItemList extends StatefulWidget {
  final int orderId;
  OrderItemList({Key? key, required this.orderId}) : super(key: key);

  @override
  State<OrderItemList> createState() => _OrderItemListState();
}

class _OrderItemListState extends State<OrderItemList> {
  List<OrderItem>? orderItems;
  var isLoaded = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<OrderItem>?>(
        future: DjangoServices().getOrderItems(widget.orderId),
        builder: (context, AsyncSnapshot<List<OrderItem>?> orderItemSnap) {
          if (orderItemSnap.connectionState == ConnectionState.none &&
              orderItemSnap.hasData == null) {
            return Container();
          }
          return SizedBox(
              height: MediaQuery.of(context).size.height * 0.75,
              child: Scrollbar(
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: orderItemSnap.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        Provider.of<CurrentOrderItemUpdate>(context)
                            .orderItems = orderItemSnap.data;
                        return Slidable(
                          key: ValueKey(index),
                          endActionPane: ActionPane(
                            // A motion is a widget used to control how the pane animates.
                            motion: const ScrollMotion(),

                            // A pane can dismiss the Slidable.
                            dismissible: DismissiblePane(onDismissed: () {
                              DjangoServices().deleteOrderItem(
                                  orderItemSnap.data![index].id!);

                              Provider.of<CurrentOrdersUpdate>(context,
                                      listen: false)
                                  .orders
                                  ?.where(
                                      (element) => element.id == widget.orderId)
                                  .first
                                  .orderItems!
                                  .forEach((item) {
                                if (item.id == orderItemSnap.data![index].id!) {
                                  Provider.of<CurrentOrdersUpdate>(context,
                                          listen: false)
                                      .orders
                                      ?.where((element) =>
                                          element.id == widget.orderId)
                                      .first
                                      .orderItems![index] = OrderItem();
                                }
                              });

                              String? out = Provider.of<CurrentOrdersUpdate>(
                                      context,
                                      listen: false)
                                  .orders
                                  ?.where(
                                      (element) => element.id == widget.orderId)
                                  .first
                                  .orderItems!
                                  .length
                                  .toString();
                              Order? x = Provider.of<CurrentOrdersUpdate>(
                                      context,
                                      listen: false)
                                  .orders
                                  ?.where(
                                      (element) => element.id == widget.orderId)
                                  .first;
                              Provider.of<OrderModification>(context,
                                      listen: false)
                                  .update(x!);
                            }),

                            // All actions are defined in the children parameter.
                            children: const [
                              // A SlidableAction can have an icon and/or a label.
                              SlidableAction(
                                onPressed: null,
                                backgroundColor: Color(0xFFFE4A49),
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'מחק',
                              ),
                            ],
                          ),
                          child: OrderItemAdmin(
                            item: orderItemSnap.data![index],
                            orderId: widget.orderId,
                          ),
                        );
                      })));
        });
  }
}

class CurrentOrderItemUpdate extends ChangeNotifier {
  List<OrderItem>? orderItems;
  void updateProduct(OrderItem item) {
    orderItems?.add((item));
    notifyListeners();
  }
}
