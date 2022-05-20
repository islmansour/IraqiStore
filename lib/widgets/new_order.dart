import 'package:flutter/material.dart';
import 'package:hardwarestore/services/django_services.dart';
import 'package:provider/provider.dart';

import '../components/user.dart';
import '../models/orders.dart';

class CreateNewOrderForm extends StatefulWidget {
  CreateNewOrderForm({Key? key}) : super(key: key);

  @override
  State<CreateNewOrderForm> createState() => _CreateNewOrderFormState();
}

class _CreateNewOrderFormState extends State<CreateNewOrderForm> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  Order _data = new Order();

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
      DjangoServices().upsertOrder(_data); // Save our form now.
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Order'),
      ),
      body: Container(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                TextFormField(
                  onSaved: (String? value) {
                    if (value != "") _data.accountId = int.parse(value!);
                    _data.id = 0;
                    _data.quoteId = 1;
                    _data.created_by =
                        Provider.of<GetCurrentUser>(context, listen: false)
                            .currentUser
                            ?.id;
                  },
                  decoration: const InputDecoration(
                      hintText: 'account', labelText: 'Account'),
                ),
                TextFormField(
                  onSaved: (String? value) {
                    if (value != "") _data.contactId = int.parse(value!);
                  },
                  decoration: const InputDecoration(
                      hintText: 'contact', labelText: 'Contact'),
                ),
                TextFormField(
                  onSaved: (String? value) {
                    _data.notes = value!;
                  },
                  decoration: const InputDecoration(
                      hintText: 'notes', labelText: 'Notes'),
                ),
                TextFormField(
                  onSaved: (String? value) {
                    //   _data.orderDate = value!;
                  },
                  decoration: const InputDecoration(
                      hintText: 'date', labelText: 'Date'),
                ),
                TextFormField(
                  onSaved: (String? value) {
                    if (value != "") _data.status = "1";
                  },
                  decoration: const InputDecoration(
                      hintText: 'status', labelText: 'Status'),
                ),
                TextFormField(
                  onSaved: (String? value) {
                    if (value != "") _data.street = value!;
                  },
                  decoration: const InputDecoration(
                      hintText: 'street', labelText: 'Street'),
                ),
                TextFormField(
                    // Use email input type for emails.
                    decoration: const InputDecoration(labelText: 'Street 2'),
                    // validator: _validateEmail,
                    onSaved: (String? value) {
                      _data.street2 = value!;
                    }),
                TextFormField(
                    // Use email input type for emails.
                    decoration: const InputDecoration(labelText: 'town'),
                    // validator: _validateEmail,
                    onSaved: (String? value) {
                      _data.town = value!;
                    }),
                TextFormField(
                    // Use email input type for emails.
                    decoration: const InputDecoration(labelText: 'Waze'),
                    // validator: _validateEmail,
                    onSaved: (String? value) {
                      _data.wazeLink = value!;
                    }),
                Container(
                  width: screenSize.width,
                  child: TextButton(
                    child: const Text(
                      'Save',
                      style: TextStyle(color: Colors.green),
                    ),
                    onPressed: submit,
                  ),
                  margin: const EdgeInsets.only(top: 20.0),
                )
              ],
            ),
          )),
    );
  }
}
