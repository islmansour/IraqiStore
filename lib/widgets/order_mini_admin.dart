import 'package:flutter/material.dart';
import 'package:hardwarestore/components/account.dart';
import 'package:hardwarestore/components/contact.dart';
import 'package:hardwarestore/models/contact.dart';
import 'package:hardwarestore/models/orders.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../components/order.dart';
import '../models/account.dart';
import '../screens/admin/order_details_admin.dart';

class OrderMiniAdmin extends StatelessWidget {
  final Order item;

  const OrderMiniAdmin({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var format = NumberFormat.simpleCurrency(locale: 'he');

    Account? orderAccount;
    Contact? orderContact;

    orderAccount = Provider.of<CurrentAccountsUpdate>(context)
        .accounts
        ?.where((f) => f.id == item.accountId)
        .first;

    item.contactId != null && item.contactId != 0
        ? orderContact = Provider.of<CurrentContactsUpdate>(context)
            .contacts
            ?.where((f) => f.id == item.contactId)
            .first
        : null;

    double sum = 0;
    // print(' item.orderItems' + item.orderItems!.length.toString());
    item.orderItems?.forEach(
      (element) {
        sum = sum + element.price!;
      },
    );

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OrderDetailAdmin(
                    item: item,
                  )),
        );
        // Goto a single order screen with we display order details and bellow that the Order Items.
      },
      child: SizedBox(
          height: 100,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(right: 4, top: 3),
                height: 20,
                width: double.infinity,
                color: Colors.grey.shade300,
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Text(
                        item.order_number.toString(),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: Text(
                        item.status,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: Text(
                        'delivery',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: Text(DateFormat('dd/MM/yy hh:mm').format(item.created!),
                    style: Theme.of(context).textTheme.labelSmall),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 4.0, top: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 35,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(orderAccount?.name ?? "",
                              style: Theme.of(context).textTheme.displayMedium,
                              overflow: TextOverflow.ellipsis),
                          Text(
                              orderContact != null
                                  ? orderContact.first_name! +
                                      " " +
                                      orderContact.last_name!
                                  : "",
                              style: Theme.of(context).textTheme.displayMedium,
                              overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: Column(
                        children: [
                          Text(orderAccount?.phone ?? "",
                              style: Theme.of(context).textTheme.displayMedium),
                          Text(
                              orderContact != null && orderContact.phone != null
                                  ? orderContact.phone!
                                  : "",
                              style: Theme.of(context).textTheme.displayMedium),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: Column(
                        children: [
                          Text(
                              format.currencySymbol +
                                  ' ' +
                                  sum.toString(), //  .data.toString(),
                              style: Theme.of(context).textTheme.displayMedium)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Container(
                        decoration: const BoxDecoration(
                            border: Border(
                          top: BorderSide(width: 2.0, color: Colors.lightBlue),
                        )),
                        child: Text('')),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
