import 'package:flutter/material.dart';
import 'package:hardwarestore/components/account.dart';
import 'package:hardwarestore/components/contact.dart';
import 'package:hardwarestore/components/quote.dart';
import 'package:hardwarestore/models/orders.dart';
import 'package:hardwarestore/models/quote.dart';
import 'package:hardwarestore/services/django_services.dart';
import 'package:hardwarestore/services/search.dart';
import 'package:hardwarestore/widgets/account_min_admin.dart';
import 'package:hardwarestore/widgets/contact_mini_admin.dart';
import 'package:hardwarestore/widgets/order_mini_admin.dart';
import 'package:hardwarestore/widgets/quote_mini_admin.dart';
import '../components/delivery.dart';
import 'package:provider/provider.dart';
import '../components/navbaradmin.dart';
import '../components/order.dart';
import '../models/account.dart';
import '../models/contact.dart';
import '../widgets/admin_bubble_button.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({Key? key}) : super(key: key);

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  bool _searching = false;
  String _newSearch = "";

  @override
  Widget build(BuildContext context) {
    _loadAccounts(context);
    _loadContacts(context);
    return Scaffold(
      floatingActionButton: AdminBubbleButtons(),
      body: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.max, children: [
        Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 300,
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      if (value.isEmpty) {
                        _searching = false;
                      } else {
                        _searching = true;
                      }
                      _newSearch = value;
                    });
                  },
                  decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 200, 200, 200)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 200, 200, 200)),
                    ),
                    hintText: "חפש...",
                    hintStyle: TextStyle(
                      color: Color.fromARGB(255, 191, 190, 190),
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                    ),
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(
                    color: Colors.blue,
                  ),
                ),
              )
            ],
          ),
        ),
        if (_searching == false) OrdersList(),
        if (_searching == false) QuotesList(),
        if (_searching == false) DeliverysList(),
        if (_searching == true && _newSearch.length >= 3)
          FutureBuilder<List<SearchItem>?>(
              future: ApplySearch().SearchAllObjects(_newSearch),
              builder: (context, AsyncSnapshot<List<SearchItem>?> searchSnap) {
                if (searchSnap.connectionState == ConnectionState.none &&
                    searchSnap.hasData == null) {
                  return Container();
                }

                return SizedBox(
                    height: MediaQuery.of(context).size.height / 2,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0, left: 8),
                      child: Scrollbar(
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: searchSnap.data?.length,
                              itemBuilder: (context, index) {
                                String type = "";
                                Widget output = Text('');
                                if (searchSnap.data != null) {
                                  type =
                                      searchSnap.data![index].type.toString();

                                  switch (type) {
                                    case "Account":
                                      output = AccountMiniAdmin(
                                          item: searchSnap.data![index].item
                                              as Account);
                                      break;
                                    case "Contact":
                                      output = ContactMiniAdmin(
                                          item: searchSnap.data![index].item
                                              as Contact);
                                      break;

                                    case "Order":
                                      output = OrderMiniAdmin(
                                          item: searchSnap.data![index].item
                                              as Order);
                                      break;
                                    case "Quote":
                                      output = QuoteMiniAdmin(
                                          item: searchSnap.data![index].item
                                              as Quote);
                                      break;
                                  }
                                }
                                return output;
                              })),
                    ));
              }),
      ])),
      appBar: AppBar(
        title: const Text('עיראקי'),
      ),
      bottomNavigationBar: const AdminBottomNav(0),
    );
  }
}

void _loadAccounts(BuildContext context) async {
  List<Account>? _accounts = await DjangoServices().getAccounts();
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
