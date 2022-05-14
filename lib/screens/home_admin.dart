import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hardwarestore/components/account.dart';
import 'package:hardwarestore/components/quote.dart';
import 'package:hardwarestore/models/delivery.dart';
import 'package:hardwarestore/models/quote.dart';
import 'package:hardwarestore/services/django_services.dart';
import '../components/bottomnav.dart';
import '../components/delivery.dart';
import '../components/news.dart';
import 'package:provider/provider.dart';

import '../components/order.dart';
import '../models/account.dart';
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
    loadAccounts(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: (() => {})),
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

void loadAccounts(BuildContext context) async {
  List<Account>? _accounts = await DjangoServices().getAccounts();
  int? x = _accounts?.length;
  Provider.of<CurrentAccountsUpdate>(context, listen: false).accounts =
      _accounts;
  Provider.of<CurrentAccountsUpdate>(context, listen: false).accountsLoaded();
  return;
}
