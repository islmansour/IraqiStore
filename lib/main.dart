import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hardwarestore/components/admin/lov.dart';
import 'package:hardwarestore/components/admin/order_item_list_component.dart';
import 'package:hardwarestore/components/admin/quote_item_list_component.dart';
import 'package:hardwarestore/components/user.dart';
import 'package:hardwarestore/screens/admin/manage_admin_screen.dart';
import 'package:hardwarestore/screens/admin/product_admin_screen.dart';
import 'package:hardwarestore/screens/home_admin.dart';
import 'package:hardwarestore/screens/login_page.dart';
import 'package:hardwarestore/services/notification_management.dart';
import 'package:hardwarestore/services/search.dart';
import 'package:hardwarestore/services/tools.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './screens/screens.dart';
import 'package:provider/provider.dart';
import './controllers/navigation.dart';
import 'components/news.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:overlay_support/overlay_support.dart';

import 'package:hardwarestore/l10n/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => EntityModification()),
      ListenableProvider<NavigationController>(
        create: (_) => NavigationController(),
      ),
      ListenableProvider<CurrentNewsUpdates>(
        create: (_) => CurrentNewsUpdates(),
      ),

      ListenableProvider<Environment>(
        create: (_) => Environment(),
      ),

      // ListenableProvider<CurrentDeliverysUpdate>(
      //   create: (_) => CurrentDeliverysUpdate(),
      // ),
      ListenableProvider<CurrentOrderItemUpdate>(
        create: (_) => CurrentOrderItemUpdate(),
      ),
      ListenableProvider<CurrentQuoteItemUpdate>(
        create: (_) => CurrentQuoteItemUpdate(),
      ),
      ListenableProvider<CurrentListOfValuesUpdates>(
        create: (_) => CurrentListOfValuesUpdates(),
      ),
      ListenableProvider<ApplySearch>(
        create: (_) => ApplySearch(),
      ),
      ListenableProvider<GetCurrentUser>(create: (_) => GetCurrentUser())
    ], child: const IraqiStoreApp()),
  );
}

class IraqiStoreApp extends StatefulWidget {
  const IraqiStoreApp({
    Key? key,
  }) : super(key: key);

  @override
  State<IraqiStoreApp> createState() => _IraqiStoreAppState();
}

class _IraqiStoreAppState extends State<IraqiStoreApp> {
  late final FirebaseMessaging _messaging;
  // late int _totalNotifications;
  // PushNotification? _notificationInfo;

  // For handling notification when the app is in terminated state
  checkForInitialMessage() async {
    await Firebase.initializeApp();
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      PushNotification notification = PushNotification(
        title: initialMessage.notification?.title,
        body: initialMessage.notification?.body,
      );
      setState(() {
        // _notificationInfo = notification;
        // _totalNotifications++;
      });
    }
  }

  @override
  void initState() {
    // _totalNotifications = 0;
    registerNotification();
    checkForInitialMessage();

    // For handling notification when the app is in background
    // but not terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      PushNotification notification = PushNotification(
        title: message.notification?.title,
        body: message.notification?.body,
        dataTitle: message.data['title'],
        dataBody: message.data['body'],
      );

      setState(() {
        // _notificationInfo = notification;
        // _totalNotifications++;
      });
    });

    super.initState();
  }

  Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");
  }

  void registerNotification() async {
    // 1. Initialize the Firebase app
    await Firebase.initializeApp();

    // 2. Instantiate Firebase Messaging
    _messaging = FirebaseMessaging.instance;
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // 3. On iOS, this helps to take the user permissions
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('message: ${message.notification?.body}');
        // Parse the message received
        PushNotification notification = PushNotification(
          title: message.notification?.title,
          body: message.notification?.body,
        );

        setState(() {
          // _notificationInfo = notification;
          // _totalNotifications++;
        });
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }

  @override
  Widget build(BuildContext context) {
    NavigationController navigation =
        Provider.of<NavigationController>(context);

    if (Provider.of<GetCurrentUser>(context).currentUser == null) {
      SharedPreferences.getInstance().then((value) {
        value.setString('ipAddress', 'http://www.arabapps.biz:8000');
      });
      navigation.screenName = '/login';
    } else {
// Obtain shared preferences.
      SharedPreferences.getInstance().then((value) {
        switch (Provider.of<GetCurrentUser>(context, listen: false)
            .currentUser!
            .userType
            .toString()) {
          case 'dev':
            value.setString('ipAddress', 'http://127.0.0.1:8000');
            break;
          case 'test':
            value.setString('ipAddress', 'http://139.162.139.161:8000');
            break;
          default:
            value.setString('ipAddress', 'http://www.arabapps.biz:8000');
        }
      });
    }
    Provider.of<CurrentListOfValuesUpdates>(context, listen: false).loadLovs();
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
          return OverlaySupport(
            child: MaterialApp(
                debugShowCheckedModeBanner: false,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                theme: ThemeData(
                  // Define the default brightness and colors.
                  //brightness: Brightness.dark,
                  primaryColor: Colors.lightBlue[800],

                  textTheme: const TextTheme(
                    displayMedium: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        //  fontWeight: FontWeight.bold,
                        color: Colors.white),
                    displaySmall: TextStyle(
                      fontSize: 14.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    headlineSmall: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    headlineMedium: TextStyle(
                      color: Colors.black,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                    headlineLarge: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                    titleMedium: TextStyle(
                      fontSize: 14.0,
                      color: Colors.lightBlue,
                      fontWeight: FontWeight.bold,
                    ),
                    titleSmall: TextStyle(
                      fontSize: 12.0,
                      color: Colors.lightBlue,
                      fontWeight: FontWeight.bold,
                    ),
                    titleLarge: TextStyle(
                        fontSize: 16.0,
                        color: Colors.lightBlue,
                        fontWeight: FontWeight.bold),
                    bodyLarge: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                    bodyMedium: TextStyle(fontSize: 14, color: Colors.black),
                    bodySmall: TextStyle(fontSize: 12, color: Colors.black),
                    labelSmall: TextStyle(fontSize: 12.0, color: Colors.grey),
                    labelMedium: TextStyle(
                        fontSize: 14.0,
                        color: Colors.deepOrangeAccent,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                supportedLocales: L10n.all,
                locale: Provider.of<GetCurrentUser>(context).currentUser == null
                    ? Locale('he', 'HE ')
                    : Provider.of<GetCurrentUser>(context)
                                .currentUser!
                                .language ==
                            "ar"
                        ? const Locale('ar', 'AR')
                        : Provider.of<GetCurrentUser>(context)
                                    .currentUser!
                                    .language ==
                                "he"
                            ? const Locale('he', 'HE')
                            : const Locale('en', 'EN'),
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
                    if (navigation.screenName == '/settings-screen')
                      const MaterialPage(child: SettingsScreen()),
                    if (navigation.screenName == '/login')
                      MaterialPage(child: LoginPage()),
                  ],
                  onPopPage: (route, result) {
                    bool popStatus = (route.didPop(result));
                    if (popStatus == true) {
                      Provider.of<NavigationController>(context, listen: false)
                          .changeScreen('/');
                    }
                    return popStatus;
                  },
                )),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return const Directionality(
            textDirection: TextDirection.rtl, child: Text('Loading..'));
      },
    );
  }
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  importance: Importance.high,
  description:
      'This channel is used for important notifications.', // description
);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
