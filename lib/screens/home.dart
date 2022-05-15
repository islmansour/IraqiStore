import 'package:flutter/material.dart';
import 'package:hardwarestore/models/orders.dart';
import '../components/bottomnav.dart';
import '../components/news.dart';
import 'package:provider/provider.dart';
import '../components/order.dart';
import '../models/news.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: (() => {
                Provider.of<CurrentOrdersUpdate>(context, listen: false)
                    .updateOrder(Order(accountId: 123, contactId: 345))
              })),
      body: OrdersList(), //NewsList(),
      appBar: AppBar(
        title: const Text('עיראקי'),
      ),
      bottomNavigationBar: const BottomNav(0),
    );
  }
}
