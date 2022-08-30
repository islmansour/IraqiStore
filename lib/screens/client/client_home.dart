import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hardwarestore/components/user.dart';
import 'package:hardwarestore/models/user.dart';
import 'package:hardwarestore/screens/settings.dart';
import 'package:hardwarestore/services/api.dart';
import 'package:hardwarestore/services/tools.dart';
import 'package:hardwarestore/widgets/client/client_home_news.dart';
import 'package:provider/provider.dart';

import '../../components/client/client_navbar.dart';
import '../../components/client/client_new_order.dart';

class ClientHome extends StatefulWidget {
  ClientHome({Key? key}) : super(key: key);

  @override
  State<ClientHome> createState() => _ClientHomeState();
}

class _ClientHomeState extends State<ClientHome> {
  @override
  void initState() {
    try {
      FirebaseMessaging.instance.getToken().then((value) {
        AppUser? _user =
            Provider.of<GetCurrentUser>(context, listen: false).currentUser;
        if (_user != null) {
          _user.token = value;
          Provider.of<GetCurrentUser>(context, listen: false).updateUser(_user);
          value;
          Repository().upsertUser(_user);
        }
      });
    } catch (e) {
      print(e);
    }
    setState(() {
      setState(() {
        _loadActiveNews(context);
        _loadAccounts(context);

        _loadContacts(context);
        _loadUsers(context);
        _loadProductss(context);
        _loadOrders(context);
        _loadLovs(context);
        _loadQuotes(context);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.redAccent,
          leading: IconButton(
            icon: Icon(Icons.portrait_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
          title: Text(AppLocalizations.of(context)!.business),
        ),
        bottomNavigationBar: const ClientBottomNav(0),
        resizeToAvoidBottomInset: false,
        body: Container(
            height: double.infinity,
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(children: [
                if (Provider.of<ClientEnvironment>(context).theCurrentOrder ==
                    null)
                  Row(
                    children: [ClientHomeNews()],
                  ), //operational row
                Row(
                  children: [],
                ), //News

                Row(
                  children: [NewOrderStepper()],
                ), //latest orders
              ]),
            )),
      ),
    );
  }
}

void _loadAccounts(BuildContext context) async {
  try {
    await Provider.of<EntityModification>(context, listen: false)
        .refreshAccountsByUserFromDB(
            Provider.of<GetCurrentUser>(context, listen: false).currentUser!);
  } catch (e) {}
  return;
}

void _loadProductss(BuildContext context) async {
  await Provider.of<EntityModification>(context, listen: false)
      .refreshProductsFromDB();
  return;
}

void _loadContacts(BuildContext context) async {
  await Provider.of<EntityModification>(context, listen: false)
      .refreshContactsFromDB();
  return;
}

void _loadOrders(BuildContext context) async {
  await Provider.of<EntityModification>(context, listen: false)
      .refreshOrdersFromDB();
}

void _loadQuotes(BuildContext context) async {
  await Provider.of<EntityModification>(context, listen: false)
      .refreshQuotesFromDB();
}

void _loadUsers(BuildContext context) async {
  await Provider.of<EntityModification>(context, listen: false)
      .refreshUsersFromDB();
}

void _loadLovs(BuildContext context) async {
  await Provider.of<EntityModification>(context, listen: false)
      .refreshLOVFromDB();
}

void _loadActiveNews(BuildContext context) async {
  await Provider.of<EntityModification>(context, listen: false)
      .refreshActiveNewsFromDB();
}
