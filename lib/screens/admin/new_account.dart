import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hardwarestore/models/account.dart';
import 'package:hardwarestore/services/django_services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../components/admin/account_contact.dart';
import '../../components/admin/account_orders.dart';
import '../../components/admin/account_quotes.dart';
import '../../components/user.dart';
import '../opt_login.dart';

class CreateNewAccountForm extends StatefulWidget {
  final Account? item;
  CreateNewAccountForm({Key? key, this.item}) : super(key: key);
  String phoneNumber = "548004990"; //enter your 10 digit number
  int minNumber = 1000;
  int maxNumber = 6000;
  String countryCode = "+972";
  @override
  State<CreateNewAccountForm> createState() => _CreateNewAccountFormState();
}

class _CreateNewAccountFormState extends State<CreateNewAccountForm> {
  // ignore: unnecessary_new
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  Account _data = Account();

  String? _validateEmail(String? value) {
    // If empty value, the isEmail function throw a error.
    // So I changed this function with try and catch.
    try {} catch (e) {
      return 'The E-mail Address must be a valid email address.';
    }

    return "";
  }

  void submit() {
    // First validate form.
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      DjangoServices().upsertAccount(_data);
      Navigator.pop(context); // Save our form now.
// Save our form now.
    }
  }

  @override
  void initState() {
    try {
      if (widget.item != null) _data = widget.item!;
    }
    // ignore: empty_catches
    catch (e) {}
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return MaterialApp(
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
        supportedLocales: const [
          Locale("he", "HE"), // OR Locale('ar', 'AE') OR Other RTL locales
        ],
        locale: const Locale("he", "HE"),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: DefaultTabController(
          length: 5,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.indigo.shade300,
              leading: BackButton(
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Text(widget.item!.name.toString()),
              bottom: const TabBar(
                indicatorColor: Colors.white,
                tabs: [
                  Tab(icon: Icon(Icons.info_outline)),
                  Tab(icon: Icon(Icons.people)),
                  Tab(
                      icon: Icon(
                    Icons.shopping_cart,
                  )),
                  Tab(icon: Icon(Icons.shopping_basket)),
                  Tab(icon: Icon(Icons.attach_file)),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                Container(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        children: <Widget>[
                          // TextButton(
                          //     onPressed: () {
                          //       Navigator.push(
                          //           context,
                          //           MaterialPageRoute(
                          //               builder: (BuildContext context) => OTPLogin()));
                          //     },
                          //     child: Text('Login')),
                          TextFormField(
                            initialValue: _data.name ?? "",
                            onSaved: (String? value) {
                              setState(() {
                                if (_data.id == null || _data.id == 0) {
                                  _data.id = 0;
                                  _data.active = true;

                                  _data.created_by =
                                      Provider.of<GetCurrentUser>(context,
                                              listen: false)
                                          .currentUser
                                          ?.id;
                                }
                                _data.name = value;
                              });
                            },
                            decoration: const InputDecoration(
                                hintText: 'name', labelText: 'Name'),
                          ),
                          TextFormField(
                            initialValue: _data.phone ?? "",
                            onSaved: (String? value) {
                              _data.phone = value;
                            },
                            decoration: const InputDecoration(
                                hintText: 'phone', labelText: 'Phone'),
                          ),
                          TextFormField(
                            initialValue: _data.street ?? "",
                            onSaved: (String? value) {
                              _data.street = value;
                            },
                            decoration: const InputDecoration(
                                hintText: 'street', labelText: 'Street'),
                          ),
                          TextFormField(
                            initialValue: _data.town ?? "",
                            onSaved: (String? value) {
                              _data.town = value;
                            },
                            decoration: const InputDecoration(
                                hintText: 'town', labelText: 'Town'),
                          ),
                          TextFormField(
                            initialValue: _data.pobox != null
                                ? _data.pobox.toString()
                                : "",
                            onSaved: (String? value) {
                              if (value != "") _data.pobox = int.parse(value!);
                            },
                            decoration: const InputDecoration(
                                hintText: 'pobox', labelText: 'POBox'),
                          ),
                          TextFormField(
                            initialValue:
                                _data.zip != null ? _data.zip.toString() : "",
                            onSaved: (String? value) {
                              if (value != "") _data.zip = int.parse(value!);
                            },
                            decoration: const InputDecoration(
                                hintText: 'zip', labelText: 'ZIP'),
                          ),
                          TextFormField(
                              initialValue: _data.email != null
                                  ? _data.email.toString()
                                  : "",
                              keyboardType: TextInputType
                                  .emailAddress, // Use email input type for emails.
                              decoration: const InputDecoration(
                                  hintText: 'you@example.com',
                                  labelText: 'E-mail Address'),
                              // validator: _validateEmail,
                              onSaved: (String? value) {
                                _data.email = value;
                              }),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Card(
                                    color: Colors.green,
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(150),
                                    ),
                                    child: Container(
                                        child: IconButton(
                                            onPressed: submit,
                                            icon: const Icon(
                                              Icons.done,
                                              color: Colors.white,
                                              size: 50,
                                            )),
                                        width: 80,
                                        height: 80,
                                        decoration: const BoxDecoration(
                                            // The child of a round Card should be in round shape
                                            shape: BoxShape.circle,
                                            color: Colors.green))),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
                AccountContactsList(account: widget.item),
                AccountOrdersList(account: widget.item),
                AccountQuotesList(account: widget.item),
                const Icon(Icons.file_present),
              ],
            ),
          ),
        ));
  }
}
