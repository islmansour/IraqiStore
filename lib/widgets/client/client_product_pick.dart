import 'package:flutter/material.dart';
import 'package:hardwarestore/components/user.dart';
import 'package:hardwarestore/models/order_item.dart';
import 'package:hardwarestore/models/products.dart';
import 'package:hardwarestore/services/tools.dart';
import 'package:hardwarestore/widgets/client/product_display_client.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/orders.dart';

class ClientProductPick extends StatefulWidget {
  final Product item;
  final Order stepperOrder;

  const ClientProductPick(
      {Key? key, required this.item, required this.stepperOrder})
      : super(key: key);

  @override
  State<ClientProductPick> createState() => _ProductPickState();
}

class _ProductPickState extends State<ClientProductPick> {
  double quantity = 0;

/*
 * ones a quantity is given, add the item to the current order (to orderItems). From the parent widget, we can then confirm and call django to add to db. 29.5
*/
  void addToOrderItem(Order order, OrderItem? orderItem) {
    try {
      // need to add error handling, can not be on this widget with no orders in the system.

      //  bool newItem = true;
      if (quantity < 0) return;

      // need to add error handling, can not be on this widget with no order in hand.
      if (order == null) {
        print('Error receiving order.');
        return;
      }

      // if product was already added to the order, simply update the quantity for this item.
      // order.orderItems!.forEach((i) {
      //   if (i.productId == orderItem!.productId) {
      //     i = orderItem;
      //     i.quantity = double.parse(quantity.toString());
      //     i.price = (widget.item.price! -
      //             (widget.item.price! * widget.item.discount! / 100)) *
      //         quantity.toDouble();
      //   }
      // });
      if (order.orderItems != null)
        order.orderItems!.remove((i) => i.productId == orderItem!.productId);
      else
        order.orderItems = <OrderItem>[];

      if (quantity == 0) return;

      orderItem = OrderItem();
      orderItem.id = 0;
      orderItem.productId = widget.item.id;
      orderItem.quantity = quantity.toDouble();
      orderItem.discount = widget.item.discount;
      orderItem.price = (widget.item.price! -
              (widget.item.price! * widget.item.discount! / 100)) *
          quantity.toDouble();
      orderItem.created_by =
          Provider.of<GetCurrentUser>(context, listen: false).currentUser?.id;

      order.orderItems!.add(orderItem);

      Provider.of<ClientEnvironment>(context, listen: false).currentOrder =
          order;

      setState(() {});
    } catch (e) {
      print(e);
      String err = AppLocalizations.of(context)!.errorCreatingProductScreen;
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(err)));
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var format = NumberFormat.simpleCurrency(locale: 'he');
    OrderItem? orderItem = OrderItem(productId: widget.item.id);
    var translation = AppLocalizations.of(context);

    Order? order = widget.stepperOrder;
    try {
      order = Provider.of<EntityModification>(context)
          .order
          .where((element) => element.id == widget.stepperOrder.id)
          .first;

      // if product is already in order, take it's data and put then in the instance of the orderItem in this widget.
      // This will allow showing the quantity that is already been added to the item.
      order.orderItems?.forEach(
        (item) {
          if (item.productId == widget.item.id) orderItem = item;
        },
      );
    } catch (e) {
      // Scaffold.of(context).showSnackBar(SnackBar(
      //     content:
      //         Text(AppLocalizations.of(context)!.errorCreatingProductScreen)));
    }

    String? currentImg = widget.item.img;

    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          DisplayProductClient(
            discount: widget.item.discount.toString(),
            img: currentImg,
          ),
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            width: MediaQuery.of(context).size.width * 0.80,
            child: Padding(
              padding: const EdgeInsets.only(right: 4.0, left: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.item.name.toString(),
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                      fontSize: 20.0,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        widget.item.price.toString() +
                            " " +
                            format.currencySymbol +
                            " ",
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 4,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: Colors.redAccent.withOpacity(0.3)),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      widget.item.desc.toString(),
                      maxLines: 6,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 10.0,
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 80,
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: Colors.redAccent.withOpacity(0.3)),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  width: MediaQuery.of(context).size.width * 0.15,
                  child: TextFormField(
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    initialValue: orderItem!.quantity == null
                        ? ""
                        : orderItem!.quantity.toString(),
                    onChanged: (value) {
                      setState(() {
                        try {
                          quantity = double.parse(value);
                        } catch (e) {
                          quantity = 0;
                        }
                        addToOrderItem(widget.stepperOrder, orderItem);
                        // recordChanged = true;
                      });
                    },
                    keyboardType: const TextInputType.numberWithOptions(),
                    decoration: InputDecoration(
                      border: InputBorder.none,

                      labelStyle: TextStyle(fontSize: 12),
                      // border: OutlineInputBorder(),0
                      labelText: '    ' + translation!.quantity,
                    ),
                  ),
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
