import 'package:flutter/material.dart';
import 'package:hardwarestore/components/user.dart';
import 'package:hardwarestore/models/order_item.dart';
import 'package:hardwarestore/models/products.dart';
import 'package:hardwarestore/services/tools.dart';
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

/*
 * ones a quantity is given, add the item to the current order (to orderItems). From the parent widget, we can then confirm and call django to add to db. 29.5
*/
  void addToOrderItem(Order order, OrderItem? orderItem) {
    try {
      // need to add error handling, can not be on this widget with no orders in the system.
      if (Provider.of<EntityModification>(context, listen: false).order ==
          null) {
        print('error while adding items to an order, order is null');
        return;
      }

      setState(() {
        bool newItem = true;
        if (quantity < 0) return;

        // need to add error handling, can not be on this widget with no order in hand.
        if (order == null) {
          print('Error receiving order.');
          return;
        }

        // if product was already added to the order, simply update the quantity for this item.
        order.tmpItems?.forEach((element) {
          if (element.productId == widget.item.id) {
            newItem = false;
            element.quantity = double.parse(quantity.toString());
            Provider.of<EntityModification>(context, listen: false)
                .order
                .where((element) => element.id == order.id)
                .first
                .tmpItems
                ?.forEach((i) {
              if (i.productId == element.productId) {
                i.quantity = double.parse(quantity.toString());
                i.price = (widget.item.price! -
                        (widget.item.price! * widget.item.discount! / 100)) *
                    quantity.toDouble();
              }
            });
          }
        });

        // adding a new product to the order items of the order.
        if (newItem) {
          if (quantity == 0) return;

          orderItem = OrderItem();
          orderItem?.id = 0;
          orderItem?.productId = widget.item.id;
          orderItem?.quantity = quantity.toDouble();
          orderItem?.discount = widget.item.discount;
          orderItem?.price = (widget.item.price! -
                  (widget.item.price! * widget.item.discount! / 100)) *
              quantity.toDouble();
          orderItem?.created_by =
              Provider.of<GetCurrentUser>(context, listen: false)
                  .currentUser
                  ?.id;
          orderItem?.orderId = order.id;

          // if Order has a null orderItems, initiate it.
          Provider.of<EntityModification>(context, listen: false)
              .order
              .where((element) => element.id == order.id)
              .first
              .tmpItems ??= <OrderItem>[];

          //once the new item is ready, add it to the order we are working on.
          Provider.of<EntityModification>(context, listen: false)
              .order
              .where((element) => element.id == order.id)
              .first
              .tmpItems
              ?.add(orderItem!);
        }
      });
    } catch (e) {
      Scaffold.of(context).showSnackBar(
          const SnackBar(content: Text("התרחשה תקלה בהכנת מסך מוצרים.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    // this is used to determine the currency
    var format = NumberFormat.simpleCurrency(locale: 'he');
    OrderItem? orderItem;
    Order? order;
    try {
      order = Provider.of<EntityModification>(context)
          .order
          .where((element) => element.id == widget.orderId)
          .first;

      // if product is already in order, take it's data and put then in the instance of the orderItem in this widget.
      // This will allow showing the quantity that is already been added to the item.
      order.orderItems?.forEach(
        (item) {
          if (item.productId == widget.item.id) orderItem = item;
        },
      );
    } catch (e) {
      Scaffold.of(context).showSnackBar(
          const SnackBar(content: Text("התרחשה תקלה בהכנת מסך מוצרים.")));
    }

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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [],
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                            .bodyMedium),
                                    Text(
                                        "הנחה:" +
                                            ' ' +
                                            widget.item.discount.toString() +
                                            ' %',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium),
                                  ],
                                ),
                                Text(widget.item.desc.toString(),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        Theme.of(context).textTheme.bodySmall),
                              ],
                            ),
                          ),
                          Container(
                              alignment: Alignment.center,
                              width: 40,
                              child: TextFormField(
                                enabled:
                                    orderItem?.id != null && orderItem?.id != 0
                                        ? false
                                        : true,
                                initialValue: orderItem?.quantity.toString(),
                                onChanged: (value) {
                                  try {
                                    setState(() {
                                      if (value == "" ||
                                          double.parse(value) == 0) {
                                        value = "0";
                                        //this will make item disappear from UI , and if calling django to delete - it will be deleted from DB.
                                        //after that we need to notify listeners that this order was modified, so we call the Provider update.
                                        // int? orderItemId = order.tmpItems
                                        //     ?.where((element) =>
                                        //         element.productId ==
                                        //         widget.item.id)
                                        //     .first
                                        //     .id;
                                        //////////////////////////// -------   NEED TO FIX --------------------
                                        // DjangoServices()
                                        //     .deleteOrderItem(orderItemId!);
                                        //////////////////////////// -------   NEED TO FIX --------------------

                                        order?.tmpItems?.removeWhere(
                                            (element) =>
                                                element.productId ==
                                                widget.item.id);
                                        // Informing listeners of the change made to the order.
                                        //////////////////////////// -------   NEED TO FIX --------------------
                                        // DjangoServices()
                                        //     .deleteOrderItem(orderItemId!);
                                        //////////////////////////// -------   NEED TO FIX --------------------
                                        // Provider.of<EntityModification>(context,
                                        //         listen: false)
                                        //     .update(order);
                                      }

                                      quantity = double.parse(value);
                                    });
                                    addToOrderItem(order!, orderItem);
                                  } catch (e) {
                                    Scaffold.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "פעולה נכשלה,הערך שבחרת לא תקין.")));
                                  }
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
                      decoration: BoxDecoration(
                          color: quantity == 0 ? Colors.grey : Colors.lightBlue,
                          borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10))),
                      //   height: 75,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [],
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
