import 'package:flutter/material.dart';
import 'package:hardwarestore/components/admin/product_admin_list_component.dart';
import 'package:hardwarestore/components/order.dart';
import 'package:hardwarestore/models/order_item.dart';
import 'package:hardwarestore/models/products.dart';
import 'package:hardwarestore/services/django_services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/orders.dart';

class OrderItemAdmin extends StatefulWidget {
  final OrderItem item;
  final int orderId;

  const OrderItemAdmin({Key? key, required this.item, required this.orderId})
      : super(key: key);

  @override
  State<OrderItemAdmin> createState() => _OrderItemAdminState();
}

class _OrderItemAdminState extends State<OrderItemAdmin> {
  double quantity = 0;

  @override
  Widget build(BuildContext context) {
    var format = NumberFormat.simpleCurrency(locale: 'he');

    Product? _product;

    _product = Provider.of<CurrentProductsUpdate>(context)
        .products
        ?.where((f) => f.id == widget.item.productId)
        .first;

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
                              color: Colors.yellow,
                              size: 34,
                            ),
                            tooltip: 'הוספה',
                            onPressed: () {
                              setState(() {
                                if (quantity <= 0) return;

                                Provider.of<CurrentOrdersUpdate>(context,
                                            listen: false)
                                        .orders
                                        ?.where((element) =>
                                            element.id == widget.orderId)
                                        .first
                                        .orderItems!
                                        .where((it) => it.id == widget.item.id)
                                        .first
                                        .quantity ==
                                    quantity;
                                widget.item.quantity = quantity;
                                DjangoServices().upsertOrderItem(widget.item);
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
                                    _product!.name.toString(),
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
                                              _product.discount.toString() +
                                              ' %',
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayMedium),
                                    ],
                                  ),
                                  Text(_product.desc.toString(),
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
                                initialValue: widget.item.quantity.toString(),
                                onChanged: (value) {
                                  setState(() {
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
                              )),
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
                              color: Colors.yellow,
                              size: 34,
                            ),
                            tooltip: 'הסרה',
                            onPressed: () {
                              setState(() {
                                DjangoServices()
                                    .deleteOrderItem(widget.item.id!);
                              });
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
