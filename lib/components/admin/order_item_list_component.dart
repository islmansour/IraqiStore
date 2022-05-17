import 'package:flutter/material.dart';
import 'package:hardwarestore/models/order_item.dart';
import 'package:hardwarestore/models/products.dart';
import 'package:hardwarestore/services/django_services.dart';
import 'package:hardwarestore/widgets/order_item_admin.dart';
import 'package:provider/provider.dart';

import '../../models/orders.dart';
import '../../widgets/product_mini_admin.dart';

class OrderItemList extends StatefulWidget {
  final String orderId;
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
          int len = orderItemSnap.data?.length ?? 0;

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
                        return OrderItemAdmin(item: orderItemSnap.data![index]);
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
