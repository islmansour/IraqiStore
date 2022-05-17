import 'package:flutter/material.dart';
import 'package:hardwarestore/services/django_services.dart';

import '../models/quote.dart';

class CreateNewQuoteForm extends StatefulWidget {
  CreateNewQuoteForm({Key? key}) : super(key: key);

  @override
  State<CreateNewQuoteForm> createState() => _CreateNewQuoteFormState();
}

class _CreateNewQuoteFormState extends State<CreateNewQuoteForm> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  Quote _data = new Quote();

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
      DjangoServices().upsertQuote(_data); // Save our form now.
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Quote'),
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
                    //   _data.quoteDate = value!;
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
