import 'package:badges/badges.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hardwarestore/components/admin/homepage_news.dart';
import 'package:hardwarestore/components/user.dart';
import 'package:hardwarestore/models/orders.dart';
import 'package:hardwarestore/models/user.dart';
import 'package:hardwarestore/models/userNotifications.dart';
import 'package:hardwarestore/screens/settings.dart';
import 'package:hardwarestore/screens/usernotification_screen.dart';
import 'package:hardwarestore/services/api.dart';
import 'package:hardwarestore/services/search.dart';
import 'package:hardwarestore/services/tools.dart';
import 'package:hardwarestore/widgets/account_min_admin.dart';
import 'package:hardwarestore/widgets/contact_mini_admin.dart';
import 'package:hardwarestore/widgets/order_mini_admin.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/navbaradmin.dart';
import '../components/order.dart';
import '../models/account.dart';
import '../models/contact.dart';
import '../widgets/admin_bubble_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:io' show Platform;

bool data_loaded = false;

class HomeAdmin extends StatefulWidget {
  final userPref;
  const HomeAdmin({Key? key, this.userPref}) : super(key: key);

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  bool _searching = false;
  String _newSearch = "";

  @override
  void initState() {
    // try {
    //   FirebaseMessaging.instance.getToken().then((value) {
    //     AppUser? _user =
    //         Provider.of<GetCurrentUser>(context, listen: false).currentUser;
    //     if (_user != null) {
    //       _user.token = value;
    //       Provider.of<GetCurrentUser>(context, listen: false).updateUser(_user);
    //       value;
    //       print('_HomeAdminState upsertUser');
    //       Repository().upsertUser(_user);
    //     }
    //   });
    // } catch (e) {
    //   print(e);
    // }
    _pullRefresh();
    super.initState();
  }

  Future<void> _pullRefresh() async {
    var pref = await SharedPreferences.getInstance();
    User? user = await FirebaseAuth.instance.currentUser;

    if (user != null) {
      List<AppUser>? users = await Repository()
          .getUserByLogin("0" + user.phoneNumber!.substring(4));
      if (users!.isNotEmpty) {
        try {
          Provider.of<GetCurrentUser>(context, listen: false)
              .updateUser(users.first);
        } catch (e) {
          throw "$e";
        }
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
      _loadNews(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    // try {
    //   if (widget.userPref.getString('username') != null &&
    //       widget.userPref.getString('username') != "") {
    //     if (Provider.of<EntityModification>(context, listen: false)
    //         .accounts
    //         .isEmpty) _loadAccounts(context);
    //     print('loaded accounts...');
    //     if (Provider.of<EntityModification>(context, listen: false)
    //         .contacts
    //         .isEmpty) {
    //       _loadContacts(context);
    //       _loadUsers(context);
    //       print('loaded contacts & users...');
    //     }
    //     if (Provider.of<EntityModification>(context, listen: false)
    //         .products
    //         .isEmpty) _loadProductss(context);
    //     print('loaded products...');

    //     if (Provider.of<EntityModification>(context, listen: false)
    //         .order
    //         .isEmpty) {
    //       _loadOrders(context);
    //     }
    //     if (Provider.of<EntityModification>(context, listen: false)
    //         .quotes
    //         .isEmpty) {
    //       _loadQuotes(context);
    //     }

    //     if (Provider.of<EntityModification>(context, listen: false)
    //         .lov
    //         .isEmpty) {
    //       _loadLovs(context);
    //     }
    //     if (Provider.of<EntityModification>(context).allNews.isEmpty) {
    //       _loadNews(context);
    //     }
    //   }
    //   data_loaded = true;
    // } catch (e) {}

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
            if (_searching == false) NewssList(),
            // if (_searching == false) const QuotesListHome(),
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
                                        // case "Quote":
                                        //   output = QuoteMiniAdmin(
                                        //       item: searchSnap.data![index].item
                                        //           as Quote);
                                        //   break;
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
        leadingWidth: 100,
        leading: Container(
          child: Row(
            //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: IconButton(
                  icon: Icon(
                    Icons.portrait_outlined,
                    size: 30,
                  ),
                  onPressed: () {
                    try {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SettingsScreen()),
                      );
                    } catch (e) {}
                  },
                ),
              ),
              FutureBuilder<List<UserNotifications>?>(
                  future: Repository().getUserNotifications(
                      Provider.of<GetCurrentUser>(context).currentUser!),
                  builder: (context,
                      AsyncSnapshot<List<UserNotifications>?>
                          userNotificationSnap) {
                    if (userNotificationSnap.connectionState ==
                            ConnectionState.none &&
                        // ignore: unnecessary_null_comparison
                        userNotificationSnap.hasData == null) {
                      return Container();
                    }
                    int len = 0;
                    if (userNotificationSnap.data != null)
                      len = userNotificationSnap.data!
                          .where((element) => element.seen == null)
                          .length;

                    return InkWell(
                        onTap: () {
                          //UserNotificationsSceeen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    UserNotificationsSceeen()),
                          );
                        },
                        child: Badge(
                            badgeContent: Text(
                              len.toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                            child: Icon(
                              Icons.notifications,
                              size: 30,
                            )));
                  }),
            ],
          ),
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

void _loadNews(BuildContext context) async {
  try {
    await Provider.of<EntityModification>(context, listen: false)
        .refreshActiveNewsFromDB();
    await Provider.of<EntityModification>(context, listen: false)
        .refreshAllNewsFromDB();
  } catch (e) {}
}
