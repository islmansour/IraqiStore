import 'package:flutter/material.dart';
import 'package:hardwarestore/components/client/client_navbar.dart';
import 'package:hardwarestore/components/client/client_orders_list.dart';

class ClientOrdersScreen extends StatelessWidget {
  const ClientOrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: const Text('הזמנות'),
      ),
      body: ClientOrderList(),
      bottomNavigationBar: const ClientBottomNav(1),
    );
  }
}
