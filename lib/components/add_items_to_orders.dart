import 'package:flutter/material.dart';
import 'package:hardwarestore/components/order.dart';
import 'package:hardwarestore/models/orders.dart';
import 'package:hardwarestore/models/products.dart';
import 'package:hardwarestore/services/django_services.dart';
import 'package:hardwarestore/services/tools.dart';
import 'package:provider/provider.dart';

import '../../widgets/product_pick.dart';

class AddItemToOrder extends StatefulWidget {
  final int? orderId;
  const AddItemToOrder({Key? key, required this.orderId}) : super(key: key);

  @override
  State<AddItemToOrder> createState() => _AddItemToOrderState();
}

class _AddItemToOrderState extends State<AddItemToOrder> {
  List<Product>? myProducts;
  var isLoaded = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        floatingActionButton: IconButton(
          icon: const Icon(Icons.done),
          onPressed: () {
            Provider.of<CurrentOrdersUpdate>(context, listen: false)
                .orders
                ?.where((element) => element.id == widget.orderId)
                .first
                .orderItems
                ?.forEach((item) {
              DjangoServices().upsertOrderItem(item);
              Order? x =
                  Provider.of<CurrentOrdersUpdate>(context, listen: false)
                      .orders
                      ?.where((element) => element.id == widget.orderId)
                      .first;
              Provider.of<OrderModification>(context, listen: false).update(x!);
              Navigator.pop(context);
            });
          },
        ),
        body: FutureBuilder<List<Product>?>(
            future: DjangoServices().getProducts(),
            builder: (context, AsyncSnapshot<List<Product>?> productSnap) {
              if (productSnap.connectionState == ConnectionState.none &&
                  productSnap.hasData == null) {
                return Container();
              }

              return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.90,
                  child: Scrollbar(
                      child: ListView.builder(
                          physics: const ScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: productSnap.data?.length ?? 0,
                          itemBuilder: (context, index) {
                            return ProductPick(
                                item: productSnap.data![index],
                                orderId: widget.orderId!);
                          })));
            }),
      ),
    );
  }
}
