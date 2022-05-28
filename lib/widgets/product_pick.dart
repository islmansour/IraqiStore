import 'package:flutter/material.dart';
import 'package:hardwarestore/components/order.dart';
import 'package:hardwarestore/components/user.dart';
import 'package:hardwarestore/models/order_item.dart';
import 'package:hardwarestore/models/products.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/orders.dart';

class ProductPick extends StatefulWidget {
  final Product item;
  final int orderId;

  const ProductPick({Key? key, required this.item, required this.orderId})
      : super(key: key);

  @override
  State<ProductPick> createState() => _ProductPickState();
}

class _ProductPickState extends State<ProductPick> {
  double quantity = 0;

  @override
  Widget build(BuildContext context) {
    var format = NumberFormat.simpleCurrency(locale: 'he');
    OrderItem? orderItem;
    Order? order = Provider.of<CurrentOrdersUpdate>(context)
        .orders
        ?.where((element) => element.id == widget.orderId)
        .first;

    if (order == null) {
      print('>>>> unable to find order.');
    }
    // if (order?.orderItems != null && order!.orderItems!.isNotEmpty) {
    //   orderItem = order.orderItems
    //       ?.where((element) => element.productId == widget.item.id)
    //       .first;
    // }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          decoration: BoxDecoration(
              border: Border.all(width: 0.5, color: Colors.lightBlue.shade400),
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                  topLeft: Radius.circular(20))),
          height: 90,
          width: double.infinity,
          child: Row(
            children: [
              Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.lightBlue,
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10))),
                      //   height: 75,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 34,
                            ),
                            tooltip: 'הוספה',
                            onPressed: () {
                              setState(() {
                                bool newItem = true;
                                if (quantity <= 0) return;
                                if (order == null) {
                                  print('Error receiving order.');
                                  return;
                                }
                                orderItem = OrderItem();
                                order.orderItems?.forEach((element) {
                                  if (element.productId == widget.item.id) {
                                    newItem = false;
                                    element.quantity =
                                        double.parse(quantity.toString());
                                  }
                                });
                                if (newItem) {
                                  orderItem?.id = 0;
                                  orderItem?.productId = widget.item.id;
                                  orderItem?.quantity = quantity.toDouble();
                                  orderItem?.price = (widget.item.price! -
                                          (widget.item.price! *
                                              (widget.item.discount!
                                                      .toDouble() /
                                                  100))) *
                                      quantity.toDouble();
                                  orderItem?.created_by =
                                      Provider.of<GetCurrentUser>(context,
                                              listen: false)
                                          .currentUser
                                          ?.id;
                                  orderItem?.orderId = order.id;

                                  Provider.of<CurrentOrdersUpdate>(context,
                                          listen: false)
                                      .orders
                                      ?.where(
                                          (element) => element.id == order.id)
                                      .first
                                      .orderItems ??= <OrderItem>[];
                                  //  order.orderItems!.add(orderItem!);
                                  if (Provider.of<CurrentOrdersUpdate>(context,
                                              listen: false)
                                          .orders ==
                                      null) {
                                    print(
                                        'error while adding items to an order, order is null');
                                    return;
                                  }
                                  Provider.of<CurrentOrdersUpdate>(context,
                                          listen: false)
                                      .orders
                                      ?.where(
                                          (element) => element.id == order.id)
                                      .first
                                      .orderItems
                                      ?.add(orderItem!);
                                }

                                print(Provider.of<CurrentOrdersUpdate>(context,
                                        listen: false)
                                    .orders
                                    ?.where((element) => element.id == order.id)
                                    .first
                                    .orderItems
                                    ?.length
                                    .toString());
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Text(
                                    widget.item.name.toString(),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                          widget.item.price.toString() +
                                              " " +
                                              format.currencySymbol +
                                              " ",
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayMedium),
                                      Text(
                                          "הנחה:" +
                                              ' ' +
                                              widget.item.discount.toString() +
                                              ' %',
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayMedium),
                                    ],
                                  ),
                                  Text(widget.item.desc.toString(),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall),
                                ],
                              ),
                            ),
                          ),
                          Container(
                              alignment: Alignment.center,
                              width: 40,
                              child: TextFormField(
                                initialValue: orderItem?.quantity.toString(),
                                onChanged: (value) {
                                  setState(() {
                                    if (value == "") value = "0";

                                    quantity = double.parse(value);
                                  });
                                },
                                keyboardType:
                                    const TextInputType.numberWithOptions(),
                                decoration: const InputDecoration(
                                  labelStyle: TextStyle(fontSize: 12),
                                  // border: OutlineInputBorder(),0
                                  labelText: 'כמות',
                                ),
                              ))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.lightBlue,
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10))),
                      //   height: 75,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.remove,
                              color: Colors.white,
                              size: 34,
                            ),
                            tooltip: 'הסרה',
                            onPressed: () {
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          )),
    );
  }
}
