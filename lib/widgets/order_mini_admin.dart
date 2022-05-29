import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:hardwarestore/components/account.dart';
import 'package:hardwarestore/components/contact.dart';
import 'package:hardwarestore/models/contact.dart';
import 'package:hardwarestore/models/orders.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../components/admin/lov.dart';
import '../models/account.dart';
import '../screens/admin/order_details_admin.dart';
import '../services/tools.dart';

class OrderMiniAdmin extends StatefulWidget {
  final Order item;

  const OrderMiniAdmin({Key? key, required this.item}) : super(key: key);

  @override
  State<OrderMiniAdmin> createState() => _OrderMiniAdminState();
}

class _OrderMiniAdminState extends State<OrderMiniAdmin> {
  @override
  Widget build(BuildContext context) {
    var format = NumberFormat.simpleCurrency(locale: 'he');
    String _status = "";
    try {
      _status = Provider.of<CurrentListOfValuesUpdates>(context)
          .getListOfValue('ORDER_STATUS', format.locale)
          .where((element) => element.name == widget.item.status)
          .first
          .value!;
    } catch (e) {}

    Account? orderAccount;
    Contact? orderContact;

    orderAccount = Provider.of<CurrentAccountsUpdate>(context)
        .accounts
        ?.where((f) => f.id == widget.item.accountId)
        .first;

    widget.item.contactId != null && widget.item.contactId != 0
        ? orderContact = Provider.of<CurrentContactsUpdate>(context)
            .contacts
            ?.where((f) => f.id == widget.item.contactId)
            .first
        : null;

    double sum = 0;

    widget.item.orderItems?.forEach(
      (element) {
        if (element.price != null) sum = sum + element.price!;
      },
    );
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OrderDetailAdmin(
                    item: widget.item,
                  )),
        );
        // Goto a single order screen with we display order details and bellow that the Order Items.
      },
      child: Card(
        child: SizedBox(
            height: 110,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  // padding: const EdgeInsets.only(right: 4, top: 3),
                  height: 20,
                  width: double.infinity,
                  color: Colors.lightBlue,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          // width: MediaQuery.of(context).size.width * 0.5,
                          child: Text(
                            widget.item.order_number.toString(),
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.2,
                          child: Text(
                            _status,
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: widget.item.created == null
                      ? Text('Now',
                          style: Theme.of(context).textTheme.labelSmall)
                      : Text(
                          DateFormat('dd/MM/yy hh:mm')
                              .format(widget.item.created!),
                          style: Theme.of(context).textTheme.labelSmall),
                ),
                //  Padding(
                //     padding: const EdgeInsets.only(right: 4.0, top: 4),
                // child:
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.only(right: 4.0, top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.40,
                          // height: 35,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.business,
                                    color: Colors.blue,
                                    size: 16,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.35,
                                    child: Text(orderAccount?.name ?? "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.person,
                                      size: 16,
                                      color: Colors.blue,
                                    ),
                                    Text(
                                        orderContact != null
                                            ? orderContact.first_name! +
                                                " " +
                                                orderContact.last_name!
                                            : "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium,
                                        overflow: TextOverflow.ellipsis),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          // width: MediaQuery.of(context).size.width * 0.28,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.phone_iphone,
                                    //size: 20,
                                    color: Colors.blue, size: 16,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.25,
                                    child: Text(orderAccount?.phone ?? "אין",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.phone_iphone,
                                      // size: 20,
                                      color: Colors.blue, size: 16,
                                    ),
                                    Text(
                                        orderContact != null &&
                                                orderContact.phone != null
                                            ? orderContact.phone!
                                            : "אין",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        //  SizedBox(
                        //   width: MediaQuery.of(context).size.width * 0.10,
                        //    child:
                        // Column(
                        //   mainAxisAlignment: MainAxisAlignment.end,
                        //   children: [
                        //     Padding(
                        //       padding: const EdgeInsets.all(4.0),
                        //       child: Consumer<OrderModification>(
                        //           builder: (context, repo, _) {
                        //         if (repo.order
                        //             .where((element) =>
                        //                 element.id == widget.item.id)
                        //             .isNotEmpty) {
                        //           return Text(
                        //               format.currencySymbol +
                        //                   ' ' +
                        //                   repo.order
                        //                       .where((element) =>
                        //                           element.id == widget.item.id)
                        //                       .first
                        //                       .totalAmount
                        //                       .toStringAsFixed(2)
                        //                       .toString(),
                        //               style: Theme.of(context)
                        //                   .textTheme
                        //                   .labelMedium);
                        //         } else {
                        //           return Text(
                        //               format.currencySymbol + ' ' + '0.0',
                        //               style: Theme.of(context)
                        //                   .textTheme
                        //                   .labelMedium);
                        //         }
                        //       }),
                        //     ),
                        //   ],
                        // ),
                        //   ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(flex: 7, child: Container()),
                    Flexible(
                      flex: 3,
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Consumer<OrderModification>(
                                  builder: (context, repo, _) {
                                if (repo.order
                                    .where((element) =>
                                        element.id == widget.item.id)
                                    .isNotEmpty) {
                                  return Text(
                                      format.currencySymbol +
                                          ' ' +
                                          repo.order
                                              .where((element) =>
                                                  element.id == widget.item.id)
                                              .first
                                              .totalAmount
                                              .toStringAsFixed(2)
                                              .toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium);
                                } else {
                                  return Text(
                                      format.currencySymbol + ' ' + '0.0',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium);
                                }
                              }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            )),
      ),
    );
  }
}

class OrderDetaulsNoInkWell extends StatefulWidget {
  final Order item;

  OrderDetaulsNoInkWell({Key? key, required this.item}) : super(key: key);

  @override
  State<OrderDetaulsNoInkWell> createState() => _OrderDetaulsNoInkWellState();
}

class _OrderDetaulsNoInkWellState extends State<OrderDetaulsNoInkWell> {
  @override
  Widget build(BuildContext context) {
    var format = NumberFormat.simpleCurrency(locale: 'he');
    String _status = "";
    try {
      _status = Provider.of<CurrentListOfValuesUpdates>(context)
          .getListOfValue('ORDER_STATUS', format.locale)
          .where((element) => element.name == widget.item.status)
          .first
          .value!;
    } catch (e) {}

    Account? orderAccount;
    Contact? orderContact;

    orderAccount = Provider.of<CurrentAccountsUpdate>(context)
        .accounts
        ?.where((f) => f.id == widget.item.accountId)
        .first;

    widget.item.contactId != null && widget.item.contactId != 0
        ? orderContact = Provider.of<CurrentContactsUpdate>(context)
            .contacts
            ?.where((f) => f.id == widget.item.contactId)
            .first
        : null;

    double sum = 0;

    widget.item.orderItems?.forEach(
      (element) {
        if (element.price != null) sum = sum + element.price!;
      },
    );
    return Card(
      child: SizedBox(
          height: 100,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                // padding: const EdgeInsets.only(right: 4, top: 3),
                height: 20,
                width: double.infinity,
                color: Colors.lightBlue,
                child: Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        // width: MediaQuery.of(context).size.width * 0.5,
                        child: Text(
                          widget.item.order_number.toString(),
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: Text(
                          _status,
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: widget.item.created == null
                    ? Text('Now', style: Theme.of(context).textTheme.labelSmall)
                    : Text(
                        DateFormat('dd/MM/yy hh:mm')
                            .format(widget.item.created!),
                        style: Theme.of(context).textTheme.labelSmall),
              ),
              //  Padding(
              //     padding: const EdgeInsets.only(right: 4.0, top: 4),
              // child:
              Flexible(
                child: Container(
                  padding: const EdgeInsets.only(right: 4.0, top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.40,
                        // height: 35,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.business,
                                  color: Colors.blue,
                                  size: 16,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
                                  child: Text(orderAccount?.name ?? "",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium,
                                      overflow: TextOverflow.ellipsis),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.person,
                                    size: 16,
                                    color: Colors.blue,
                                  ),
                                  Text(
                                      orderContact != null
                                          ? orderContact.first_name! +
                                              " " +
                                              orderContact.last_name!
                                          : "",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium,
                                      overflow: TextOverflow.ellipsis),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        // width: MediaQuery.of(context).size.width * 0.28,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.phone_iphone,
                                  //size: 20,
                                  color: Colors.blue, size: 16,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  child: Text(orderAccount?.phone ?? "אין",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.phone_iphone,
                                    // size: 20,
                                    color: Colors.blue, size: 16,
                                  ),
                                  Text(
                                      orderContact != null &&
                                              orderContact.phone != null
                                          ? orderContact.phone!
                                          : "אין",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      //  SizedBox(
                      //   width: MediaQuery.of(context).size.width * 0.10,
                      //    child:
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Consumer<OrderModification>(
                                builder: (context, repo, _) {
                              if (repo.order
                                  .where(
                                      (element) => element.id == widget.item.id)
                                  .isNotEmpty) {
                                return Text(
                                    format.currencySymbol +
                                        ' ' +
                                        repo.order
                                            .where((element) =>
                                                element.id == widget.item.id)
                                            .first
                                            .totalAmount
                                            .toStringAsFixed(2)
                                            .toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium);
                              } else {
                                return Text(format.currencySymbol + ' ' + '0.0',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium);
                              }
                            }),
                          ),
                        ],
                      ),
                      //   ),
                    ],
                  ),
                ),
              ),
              //  ),
            ],
          )),
    );
  }
}
