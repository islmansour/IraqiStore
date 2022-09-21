import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hardwarestore/l10n/l10n.dart';
import 'package:hardwarestore/models/account.dart';
import 'package:hardwarestore/services/api.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../components/admin/account_contact.dart';
import '../../components/admin/account_forms.dart';
import '../../components/admin/account_orders.dart';
import '../../components/admin/account_quotes.dart';
import '../../components/admin/lov.dart';
import '../../components/user.dart';
import '../../models/lov.dart';

class CreateNewAccountForm extends StatefulWidget {
  final Account? item;
  CreateNewAccountForm({Key? key, this.item}) : super(key: key);

  @override
  State<CreateNewAccountForm> createState() => _CreateNewAccountFormState();
}

class _CreateNewAccountFormState extends State<CreateNewAccountForm> {
  // ignore: unnecessary_new
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  Account _data = Account();

  void submit() {
    // First validate form.
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      Repository().upsertAccount(_data);
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
    var format = NumberFormat.simpleCurrency(locale: 'he');
    var translation = AppLocalizations.of(context);
    return MaterialApp(
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
        locale: Provider.of<GetCurrentUser>(context).currentUser!.language ==
                "ar"
            ? const Locale('ar', 'AR')
            : Provider.of<GetCurrentUser>(context).currentUser!.language == "he"
                ? const Locale('he', 'HE')
                : const Locale('en', 'EN'),
        home: DefaultTabController(
          length: 4,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.indigo.shade300,
              leading: BackButton(
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title:
                  Text(widget.item == null ? "" : widget.item!.name.toString()),
              bottom: TabBar(
                indicatorColor: Colors.white,
                tabs: [
                  Tab(
                    icon: const Icon(Icons.info_outline),
                    text: translation!.details,
                  ),
                  Tab(
                    icon: Icon(Icons.people),
                    text: translation.contacts,
                  ),
                  Tab(
                    icon: Icon(
                      Icons.shopping_cart,
                    ),
                    text: translation.orders,
                  ),
                  // Tab(
                  //   icon: const Icon(Icons.shopping_basket),
                  //   text: translation.quotes,
                  // ),
                  Tab(
                    icon: Icon(Icons.attach_file),
                    text: translation.files,
                  ),
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
                            decoration: InputDecoration(
                                hintText: translation.name,
                                labelText: translation.name),
                          ),
                          DropdownButtonFormField(
                              items: Provider.of<CurrentListOfValuesUpdates>(context)
                                  .getListOfValue('ACCOUNT_TYPE',
                                      AppLocalizations.of(context)!.localeName)
                                  .map((ListOfValues status) {
                                return DropdownMenuItem(
                                    value: status.name,
                                    child: Row(
                                      children: <Widget>[
                                        Text(status.value!),
                                      ],
                                    ));
                              }).toList(),
                              onChanged: (newValue) {
                                try {
                                  // do other stuff with _category
                                  setState(
                                      () => _data.type = newValue.toString());
                                } catch (e) {
                                  // Scaffold.of(context).showSnackBar(SnackBar(
                                  //     content: Text(
                                  //         translation.errorDisplayStatus)));
                                }
                              },
                              value: _data.type == "" || _data.type == null
                                  ? Provider.of<CurrentListOfValuesUpdates>(context)
                                      .activeListOfValues
                                      .where((element) =>
                                          element.language ==
                                              AppLocalizations.of(context)!
                                                  .localeName &&
                                          element.name == 'private' &&
                                          element.type == 'ACCOUNT_TYPE')
                                      .first
                                      .name
                                  : Provider.of<CurrentListOfValuesUpdates>(context)
                                      .activeListOfValues
                                      .where((element) =>
                                          element.language ==
                                              AppLocalizations.of(context)!.localeName &&
                                          element.name == _data.type &&
                                          element.type == 'ACCOUNT_TYPE')
                                      .first
                                      .name,
                              decoration: const InputDecoration(contentPadding: EdgeInsets.only(right: 8))),
                          TextFormField(
                            initialValue: _data.phone ?? "",
                            onSaved: (String? value) {
                              _data.phone = value;
                            },
                            decoration: InputDecoration(
                                hintText: translation.phone,
                                labelText: translation.phone),
                          ),
                          TextFormField(
                            initialValue: _data.street ?? "",
                            onSaved: (String? value) {
                              _data.street = value;
                            },
                            decoration: InputDecoration(
                                hintText: translation.street,
                                labelText: translation.street),
                          ),
                          TextFormField(
                            initialValue: _data.town ?? "",
                            onSaved: (String? value) {
                              _data.town = value;
                            },
                            decoration: InputDecoration(
                                hintText: translation.town,
                                labelText: translation.town),
                          ),
                          TextFormField(
                            initialValue: _data.pobox != null
                                ? _data.pobox.toString()
                                : "",
                            onSaved: (String? value) {
                              if (value != "")
                                _data.pobox = int.parse(value!);
                              else
                                _data.pobox = null;
                            },
                            decoration: InputDecoration(
                                hintText: translation.pobox,
                                labelText: translation.pobox),
                          ),
                          TextFormField(
                            initialValue:
                                _data.zip != null ? _data.zip.toString() : "",
                            onSaved: (String? value) {
                              if (value != "")
                                _data.zip = int.parse(value!);
                              else
                                _data.pobox = null;
                            },
                            decoration: InputDecoration(
                                hintText: translation.zip,
                                labelText: translation.zip),
                          ),
                          TextFormField(
                              initialValue: _data.email != null
                                  ? _data.email.toString()
                                  : "",
                              keyboardType: TextInputType
                                  .emailAddress, // Use email input type for emails.
                              decoration: InputDecoration(
                                  hintText: translation.email,
                                  labelText: translation.email),
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
                // AccountQuotesList(account: widget.item),
                AccountLegalFormsList(account: widget.item),
              ],
            ),
          ),
        ));
  }
}
