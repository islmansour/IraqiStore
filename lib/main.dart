import 'package:flutter/material.dart';
import 'package:hardwarestore/components/account.dart';
import 'package:hardwarestore/components/admin/order_item_list_component.dart';
import 'package:hardwarestore/components/admin/product_admin_list_component.dart';
import 'package:hardwarestore/components/admin/quote_item_list_component.dart';
import 'package:hardwarestore/components/contact.dart';
import 'package:hardwarestore/components/delivery.dart';
import 'package:hardwarestore/components/order.dart';
import 'package:hardwarestore/components/quote.dart';
import 'package:hardwarestore/components/user.dart';
import 'package:hardwarestore/screens/admin/manage_admin_screen.dart';
import 'package:hardwarestore/screens/admin/product_admin_screen.dart';
import 'package:hardwarestore/screens/home_admin.dart';
import 'package:hardwarestore/services/search.dart';
import './screens/screens.dart';
import 'package:provider/provider.dart';
import './controllers/navigation.dart';
import 'components/news.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';

import 'models/orders.dart';

void main() {
  runApp(
    MultiProvider(providers: [
      ListenableProvider<NavigationController>(
        create: (_) => NavigationController(),
      ),
      ListenableProvider<CurrentNewsUpdates>(
        create: (_) => CurrentNewsUpdates(),
      ),
      ListenableProvider<CurrentOrdersUpdate>(
        create: (_) => CurrentOrdersUpdate(),
      ),
      ListenableProvider<CurrentQuotesUpdate>(
        create: (_) => CurrentQuotesUpdate(),
      ),
      ListenableProvider<CurrentDeliverysUpdate>(
        create: (_) => CurrentDeliverysUpdate(),
      ),
      ListenableProvider<CurrentAccountsUpdate>(
        create: (_) => CurrentAccountsUpdate(),
      ),
      ListenableProvider<CurrentContactsUpdate>(
        create: (_) => CurrentContactsUpdate(),
      ),
      ListenableProvider<CurrentProductsUpdate>(
        create: (_) => CurrentProductsUpdate(),
      ),
      ListenableProvider<CurrentOrderItemUpdate>(
        create: (_) => CurrentOrderItemUpdate(),
      ),
      ListenableProvider<CurrentQuoteItemUpdate>(
        create: (_) => CurrentQuoteItemUpdate(),
      ),
      ListenableProvider<ApplySearch>(
        create: (_) => ApplySearch(),
      ),
      ListenableProvider<GetCurrentUser>(create: (_) => GetCurrentUser())
    ], child: const IraqiStoreApp()),
  );
}

class IraqiStoreApp extends StatelessWidget {
  const IraqiStoreApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    NavigationController navigation =
        Provider.of<NavigationController>(context);
    return FutureBuilder(
      // Initialize FlutterFire
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          print('error');
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
              localizationsDelegates:
                  AppLocalizations.localizationsDelegates, // <- here
              //s  supportedLocales: AppLocalizations.supportedLocales,
              theme: ThemeData(
                // Define the default brightness and colors.
                //brightness: Brightness.dark,
                primaryColor: Colors.lightBlue[800],

                // Define the default font family.
                //fontFamily: 'Georgia',

                // Define the default `TextTheme`. Use this to specify the default
                // text styling for headlines, titles, bodies of text, and more.
                textTheme: const TextTheme(
                  headlineSmall: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber),
                  displayMedium: TextStyle(
                      fontSize: 14.0,
                      //  fontWeight: FontWeight.bold,
                      color: Colors.black),
                  displaySmall: TextStyle(
                    fontSize: 12.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  titleMedium: TextStyle(
                    fontSize: 12.0,
                    color: Colors.lightBlue,
                    fontWeight: FontWeight.bold,
                  ),
                  bodyLarge:
                      TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                  labelSmall: TextStyle(fontSize: 12.0, color: Colors.grey),
                  labelMedium: TextStyle(
                    fontSize: 12.0,
                  ),
                ),
              ),
              supportedLocales: const [
                Locale(
                    "he", "HE"), // OR Locale('ar', 'AE') OR Other RTL locales
              ],
              locale: const Locale("he", "HE"),
              home: Navigator(
                pages: [
                  const MaterialPage(child: HomeAdmin()),
                  if (navigation.screenName == '/orders')
                    const MaterialPage(child: Orders()),
                  if (navigation.screenName == '/products')
                    const MaterialPage(child: Products()),
                  if (navigation.screenName == '/manage')
                    const MaterialPage(child: ManageAdminScreen()),
                  if (navigation.screenName == '/chat')
                    const MaterialPage(child: Chat()),
                  if (navigation.screenName == '/product-admin')
                    const MaterialPage(child: ProductsAdminScreen()),
                ],
                onPopPage: (route, result) {
                  bool popStatus = (route.didPop(result));
                  if (popStatus == true) {
                    Provider.of<NavigationController>(context, listen: false)
                        .changeScreen('/');
                  }
                  return popStatus;
                },
              ));
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return new Directionality(
            textDirection: TextDirection.rtl, child: new Text('Loading..'));
      },
    );
  }
}
