import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hardwarestore/components/quote.dart';
import 'package:hardwarestore/components/user.dart';
import 'package:hardwarestore/models/orders.dart';
import 'package:hardwarestore/models/quote.dart';
import 'package:hardwarestore/models/user.dart';
import 'package:hardwarestore/screens/settings.dart';
import 'package:hardwarestore/services/api.dart';
import 'package:hardwarestore/services/search.dart';
import 'package:hardwarestore/services/tools.dart';
import 'package:hardwarestore/widgets/account_min_admin.dart';
import 'package:hardwarestore/widgets/contact_mini_admin.dart';
import 'package:hardwarestore/widgets/order_mini_admin.dart';
import 'package:hardwarestore/widgets/quote_mini_admin.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/navbaradmin.dart';
import '../components/order.dart';
import '../models/account.dart';
import '../models/contact.dart';
import '../widgets/admin_bubble_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:io' show Platform;

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({Key? key}) : super(key: key);

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  bool _searching = false;
  String _newSearch = "";

  @override
  void initState() {
    super.initState();
  }

  Future<void> _pullRefresh() async {
    var pref = await SharedPreferences.getInstance();
    User? user = await FirebaseAuth.instance.currentUser;

    if (user != null) {
      List<AppUser>? users = await Repository()
          .getUserByLogin("0" + user.phoneNumber!.substring(4));
      if (users!.isNotEmpty) {
        Provider.of<GetCurrentUser>(context, listen: false)
            .updateUser(users.first);
      }
    }
    String _env = 'production';
    if (Provider.of<GetCurrentUser>(context, listen: false).currentUser !=
            null &&
        Provider.of<GetCurrentUser>(context, listen: false)
                .currentUser!
                .userType !=
            null) {
      _env = Provider.of<GetCurrentUser>(context, listen: false)
          .currentUser!
          .userType
          .toString();
    }
    switch (_env) {
      case 'dev':
        if (Platform.isIOS)
          pref.setString('ipAddress', 'http://127.0.0.1:8000');
        else
          pref.setString('ipAddress', 'http://10.0.2.2:8000');
        break;
      case 'test':
        pref.setString('ipAddress', 'http://139.162.139.161:8000');
        break;
      default:
        pref.setString('ipAddress', 'http://www.arabapps.biz:8000');
    }

    setState(() {
      _loadAccounts(context);

      _loadContacts(context);
      _loadUsers(context);
      _loadProductss(context);
      _loadOrders(context);
      _loadLovs(context);
      _loadQuotes(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (Provider.of<GetCurrentUser>(context).currentUser != null) {
      if (Provider.of<EntityModification>(context, listen: false)
          .accounts
          .isEmpty) _loadAccounts(context);
      if (Provider.of<EntityModification>(context, listen: false)
          .contacts
          .isEmpty) {
        _loadContacts(context);
        _loadUsers(context);
      }
      if (Provider.of<EntityModification>(context, listen: false)
          .products
          .isEmpty) _loadProductss(context);
      if (Provider.of<EntityModification>(context, listen: false)
          .order
          .isEmpty) {
        _loadOrders(context);
      }
      if (Provider.of<EntityModification>(context, listen: false)
          .quotes
          .isEmpty) {
        _loadQuotes(context);
      }

      if (Provider.of<EntityModification>(context, listen: false).lov.isEmpty) {
        _loadLovs(context);
      }
    }
    return Scaffold(
      floatingActionButton: const AdminBubbleButtons(),
      body: RefreshIndicator(
        onRefresh: _pullRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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
                      decoration: InputDecoration(
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 200, 200, 200)),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 200, 200, 200)),
                        ),
                        hintText: AppLocalizations.of(context)!.search,
                        hintStyle: const TextStyle(
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
            if (_searching == false) const OrdersListHome(),
            if (_searching == false) const QuotesListHome(),
            // if (_searching == false) DeliverysList(),
            if (_searching == true && _newSearch.length >= 3)
              FutureBuilder<List<SearchItem>?>(
                  future: ApplySearch().SearchAllObjects(context, _newSearch),
                  builder:
                      (context, AsyncSnapshot<List<SearchItem>?> searchSnap) {
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
                                      type = searchSnap.data![index].type
                                          .toString();

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
          ]),
        ),
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.portrait_outlined),
          onPressed: () {
            try {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            } catch (e) {}
          },
        ),
        title: Text(AppLocalizations.of(context)!.business),
      ),
      bottomNavigationBar: const AdminBottomNav(0),
    );
  }
}

void _loadAccounts(BuildContext context) async {
  await Provider.of<EntityModification>(context, listen: false)
      .refreshAccountsFromDB();
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
