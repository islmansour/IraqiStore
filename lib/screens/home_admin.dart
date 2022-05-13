import 'package:flutter/material.dart';
import 'package:hardwarestore/components/quote.dart';
import 'package:hardwarestore/models/delivery.dart';
import 'package:hardwarestore/models/quote.dart';
import '../components/bottomnav.dart';
import '../components/delivery.dart';
import '../components/news.dart';
import 'package:provider/provider.dart';

import '../components/order.dart';
import '../models/news.dart';
import '../models/orders.dart';

class HomeAdmin extends StatelessWidget {
  const HomeAdmin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: (() => {
                if (Provider.of<CurrentOrdersUpdate>(context, listen: false)
                        .orders
                        .length <=
                    Provider.of<CurrentQuotesUpdate>(context, listen: false)
                        .quotes
                        .length)
                  Provider.of<CurrentOrdersUpdate>(context, listen: false)
                      .updateOrder(Order(accountId: '123', contactId: '345,'))
                else
                  {
                    Provider.of<CurrentQuotesUpdate>(context, listen: false)
                        .updateQuote(
                            Quote(accountId: '123', contactId: '345,')),
                    Provider.of<CurrentDeliverysUpdate>(context, listen: false)
                        .updateDelivery(Delivery(id: '1', accountId: '2'))
                  }
              })),
      body: SingleChildScrollView(
          child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [OrdersList(), QuotesList(), DeliverysList()])),
      appBar: AppBar(
        title: const Text('עיראקי'),
      ),
      bottomNavigationBar: const BottomNav(0),
    );
  }
}
