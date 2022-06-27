import 'package:flutter/material.dart';
import 'package:hardwarestore/components/navbaradmin.dart';
import 'package:hardwarestore/screens/admin/accounts_screen.dart';
import 'package:hardwarestore/screens/admin/all_quotes_screen.dart';
import 'package:hardwarestore/screens/admin/users_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hardwarestore/screens/screens.dart';
import 'all_deliveries.dart';
import 'all_orders_screen.dart';
import 'contacts_screen.dart';

class ManageAdminScreen extends StatefulWidget {
  const ManageAdminScreen({Key? key}) : super(key: key);

  @override
  State<ManageAdminScreen> createState() => _ManageAdminScreenState();
}

class _ManageAdminScreenState extends State<ManageAdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          // AccountsList(), ContactsList()
          Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(150),
                  ),
                  child: Column(
                    children: [
                      Container(
                          child: IconButton(
                            icon: const Icon(
                              Icons.business_rounded,
                              color: Colors.blue,
                              size: 40,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ManageAccountScreen()),
                              );
                            },
                          ),
                          width: 80,
                          height: 45,
                          decoration: const BoxDecoration(
                              // The child of a round Card should be in round shape
                              shape: BoxShape.circle,
                              color: Colors.white)),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6.0),
                        child: Text(
                          AppLocalizations.of(context)!.accounts,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      )
                    ],
                  )),
              Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(150),
                  ),
                  child: Column(
                    children: [
                      Container(
                          child: IconButton(
                            icon: const Icon(
                              Icons.shopping_cart,
                              color: Colors.blue,
                              size: 40,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const AllOrdersScreen()),
                              );
                              //
                            },
                          ),
                          width: 80,
                          height: 45,
                          decoration: const BoxDecoration(
                              // The child of a round Card should be in round shape
                              shape: BoxShape.circle,
                              color: Colors.white)),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6.0),
                        child: Text(
                          AppLocalizations.of(context)!.orders,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      )
                    ],
                  )),
              Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Column(
                    children: [
                      Container(
                          child: IconButton(
                            icon: const Icon(
                              Icons.shopping_basket,
                              color: Colors.blue,
                              size: 40,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const AllQuotesScreen()),
                              );
                              //
                            },
                          ),
                          width: 80,
                          height: 45,
                          decoration: const BoxDecoration(
                              // The child of a round Card should be in round shape
                              shape: BoxShape.circle,
                              color: Colors.white)),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6.0),
                        child: Text(
                          AppLocalizations.of(context)!.quote,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      )
                    ],
                  )),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(150),
                  ),
                  child: Column(
                    children: [
                      Container(
                          child: IconButton(
                            icon: const Icon(
                              Icons.people,
                              color: Colors.blue,
                              size: 40,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ManageContactScreen()),
                              );
                              //ManageContactScreen
                            },
                          ),
                          width: 80,
                          height: 45,
                          decoration: const BoxDecoration(
                              // The child of a round Card should be in round shape
                              shape: BoxShape.circle,
                              color: Colors.white)),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6.0),
                        child: Text(
                          AppLocalizations.of(context)!.contacts,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      )
                    ],
                  )),
              Card(
                  //users settings
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(150),
                  ),
                  child: Column(
                    children: [
                      Container(
                          child: IconButton(
                            icon: const Icon(
                              Icons.manage_accounts,
                              color: Colors.blue,
                              size: 40,
                            ),
                            onPressed: () {
                              //ManageUserScreen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ManageUserScreen()),
                              );
                            },
                          ),
                          width: 80,
                          height: 45,
                          decoration: const BoxDecoration(
                              // The child of a round Card should be in round shape
                              shape: BoxShape.circle,
                              color: Colors.white)),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6.0),
                        child: Text(
                          AppLocalizations.of(context)!.users,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      )
                    ],
                  )),
              Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(150),
                  ),
                  child: Column(
                    children: [
                      Container(
                          child: IconButton(
                            icon: const Icon(
                              Icons.delivery_dining,
                              color: Colors.blue,
                              size: 40,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const AllDeliveriesScreen()),
                              );
                            },
                          ),
                          width: 80,
                          height: 45,
                          decoration: const BoxDecoration(
                              // The child of a round Card should be in round shape
                              shape: BoxShape.circle,
                              color: Colors.white)),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6.0),
                        child: Text(
                          AppLocalizations.of(context)!.delivery,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      )
                    ],
                  )),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Card(
                  //profile setting
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(150),
                  ),
                  child: Column(
                    children: [
                      Container(
                          child: IconButton(
                            icon: const Icon(
                              Icons.settings,
                              color: Colors.blue,
                              size: 40,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SettingsScreen()),
                              );
                            },
                          ),
                          width: 80,
                          height: 45,
                          decoration: const BoxDecoration(
                              // The child of a round Card should be in round shape
                              shape: BoxShape.circle,
                              color: Colors.white)),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6.0),
                        child: Text(
                          AppLocalizations.of(context)!.settings,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      )
                    ],
                  )),
              // Card(
              //     //statistics
              //     elevation: 10,
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(150),
              //     ),
              //     child: Container(
              //         child: IconButton(
              //           icon: const Icon(
              //             Icons.bar_chart,
              //             color: Colors.blue,
              //             size: 50,
              //           ),
              //           onPressed: () {},
              //         ),
              //         width: 80,
              //         height: 80,
              //         decoration: const BoxDecoration(
              //             // The child of a round Card should be in round shape
              //             shape: BoxShape.circle,
              //             color: Colors.white))),
            ],
          )
        ],
      ),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.manage),
      ),
      bottomNavigationBar: const AdminBottomNav(2),
    );
  }
}
