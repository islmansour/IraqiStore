import 'package:flutter/material.dart';
import 'package:hardwarestore/components/contact.dart';
import 'package:hardwarestore/models/contact.dart';
import 'package:hardwarestore/services/api.dart';
import 'package:hardwarestore/services/tools.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../components/admin/account_contacts_component.dart';
import '../../components/user.dart';
import '../../models/user.dart';

class CreateAccountContactForm extends StatefulWidget {
  final Contact? item;
  final int? accountId;
  CreateAccountContactForm({Key? key, this.item, this.accountId})
      : super(key: key);

  @override
  State<CreateAccountContactForm> createState() =>
      _CreateAccountContactFormState();
}

class _CreateAccountContactFormState extends State<CreateAccountContactForm> {
  // ignore: unnecessary_new
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  Contact _data = Contact();

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
      Repository().upsertContact(_data)?.then((value) {
        _data.id = value;
        Provider.of<EntityModification>(context, listen: false)
            .updateContact(_data);
        Provider.of<EntityModification>(context, listen: false)
            .accounts
            .where((element) => element.id == widget.accountId)
            .first
            .accountContacts
            ?.add(_data);

        if (Provider.of<EntityModification>(context, listen: false)
                .accounts
                .where((element) => element.id == widget.accountId)
                .first
                .contactId ==
            null) {
          Provider.of<EntityModification>(context, listen: false)
              .accounts
              .where((element) => element.id == widget.accountId)
              .first
              .contactId = value;
          Repository().upsertAccount(
              Provider.of<EntityModification>(context, listen: false)
                  .accounts
                  .where((element) => element.id == widget.accountId)
                  .first);
        }
        Navigator.pop(context);
      });
      // Save our form now.
// Save our form now.
    }
  }

  @override
  void initState() {
    try {
      if (widget.item != null) {
        _data = widget.item!;
        //  _getUser();
      }
    }
    // ignore: empty_catches
    catch (e) {
      print(e);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.indigo.shade300,
              leading: BackButton(
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: widget.item == null
                  ? Text('חדש')
                  : Text(widget.item!.first_name.toString() +
                      ' ' +
                      widget.item!.last_name.toString()),
              bottom: const TabBar(
                indicatorColor: Colors.white,
                tabs: [
                  Tab(icon: Icon(Icons.person_add)),
                  Tab(icon: Icon(Icons.people)),
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
                            initialValue: _data.first_name ?? "",
                            onSaved: (String? value) {
                              setState(() {
                                if (_data.id == null || _data.id == 0) {
                                  _data.id = 0;
                                  _data.active = true;
                                  if (widget.accountId != null) {
                                    _data.accountId = widget.accountId;
                                  }

                                  _data.created_by =
                                      Provider.of<GetCurrentUser>(context,
                                              listen: false)
                                          .currentUser
                                          ?.id;
                                }
                                _data.first_name = value;
                              });
                            },
                            decoration: const InputDecoration(
                                hintText: 'first name',
                                labelText: 'First Name'),
                          ),
                          TextFormField(
                            initialValue: _data.last_name ?? "",
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
                                _data.last_name = value;
                              });
                            },
                            decoration: const InputDecoration(
                                hintText: 'last name', labelText: 'Last Name'),
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
                          FutureBuilder<List<User>?>(
                            future: Repository().getUserByLogin(
                                (widget.item == null ||
                                        widget.item!.phone.toString() == '')
                                    ? '-0'
                                    : widget.item!.phone.toString()),
                            builder: (context, data) {
                              if (data.connectionState ==
                                  ConnectionState.waiting) return Container();
                              return Switch(
                                activeColor: Colors.green,
                                value: data.data!.isNotEmpty
                                    ? data.data!.first.active!
                                    : false,
                                onChanged: (value) {
                                  if (widget.item?.phone == null ||
                                      widget.item?.phone.toString() == '')
                                    return;
                                  setState(() {
                                    User user;
                                    if (data.data!.isNotEmpty) {
                                      user = data.data!.first;
                                    } else {
                                      user = User(
                                          active: value,
                                          contactId: widget.item?.id,
                                          uid: widget.item!.phone,
                                          token: 'TBD');
                                    }
                                    user.active = value;
                                    Repository().upsertUser(user);
                                  });
                                },
                              );
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Card(
                                    color: Colors.teal,
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
                // ContactContactsList(contact: widget.item),
                // ContactOrdersList(contact: widget.item),
                // ContactQuotesList(contact: widget.item),
                AccountContactsList()
              ],
            ),
          ),
        ));
  }
}
