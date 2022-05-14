import 'dart:math';

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

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({Key? key}) : super(key: key);

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  @override
  Widget build(BuildContext context) {
    Random random = new Random();
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
                      .updateOrder(Order(
                          accountId: random.nextInt(100),
                          contactId: random.nextInt(100)))
                else
                  {
                    Provider.of<CurrentQuotesUpdate>(context, listen: false)
                        .updateQuote(Quote(
                            accountId: random.nextInt(100).toString(),
                            contactId: random.nextInt(100).toString())),
                    Provider.of<CurrentDeliverysUpdate>(context, listen: false)
                        .updateDelivery(Delivery(
                            id: random.nextInt(100).toString(),
                            accountId: random.nextInt(100).toString()))
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
