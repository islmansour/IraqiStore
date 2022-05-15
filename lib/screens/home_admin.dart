import 'package:flutter/material.dart';
import 'package:hardwarestore/components/account.dart';
import 'package:hardwarestore/components/contact.dart';
import 'package:hardwarestore/components/quote.dart';
import 'package:hardwarestore/services/django_services.dart';
import '../components/delivery.dart';
import 'package:provider/provider.dart';

import '../components/navbaradmin.dart';
import '../components/order.dart';
import '../models/account.dart';
import '../models/contact.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({Key? key}) : super(key: key);

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  @override
  Widget build(BuildContext context) {
    _loadAccounts(context);
    _loadContacts(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: (() => {})),
      body: SingleChildScrollView(
          child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [OrdersList(), QuotesList(), DeliverysList()])),
      appBar: AppBar(
        title: const Text('עיראקי'),
      ),
      bottomNavigationBar: const AdminBottomNav(0),
    );
  }
}

void _loadAccounts(BuildContext context) async {
  List<Account>? _accounts = await DjangoServices().getAccounts();
  int? x = _accounts?.length;
  Provider.of<CurrentAccountsUpdate>(context, listen: false).accounts =
      _accounts;
  Provider.of<CurrentAccountsUpdate>(context, listen: false).accountsLoaded();
  return;
}

void _loadContacts(BuildContext context) async {
  List<Contact>? _contacts = await DjangoServices().getContacts();
  int? x = _contacts?.length;
  Provider.of<CurrentContactsUpdate>(context, listen: false).contacts =
      _contacts;
  Provider.of<CurrentContactsUpdate>(context, listen: false).contactsLoaded();
  return;
}
