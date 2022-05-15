import 'package:flutter/material.dart';
import 'package:hardwarestore/components/account.dart';
import 'package:hardwarestore/components/admin/product_admin_list_component.dart';
import 'package:hardwarestore/components/contact.dart';
import 'package:hardwarestore/components/delivery.dart';
import 'package:hardwarestore/components/order.dart';
import 'package:hardwarestore/components/quote.dart';
import 'package:hardwarestore/screens/admin/manage_admin_screen.dart';
import 'package:hardwarestore/screens/admin/product_admin_screen.dart';
import 'package:hardwarestore/screens/home_admin.dart';
import './screens/screens.dart';
import 'package:provider/provider.dart';
import './controllers/navigation.dart';
import 'components/news.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
    return MaterialApp(
        theme: ThemeData(
          // Define the default brightness and colors.
          //brightness: Brightness.dark,
          primaryColor: Colors.lightBlue[800],

          // Define the default font family.
          //fontFamily: 'Georgia',

          // Define the default `TextTheme`. Use this to specify the default
          // text styling for headlines, titles, bodies of text, and more.
          textTheme: const TextTheme(
            headline1: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
            headline2: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue),
            headline3: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
            subtitle1: TextStyle(fontSize: 12.0, color: Colors.grey),
          ),
        ),
        localizationsDelegates: const [
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale("he", "HE"), // OR Locale('ar', 'AE') OR Other RTL locales
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
}
