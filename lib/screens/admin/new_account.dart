import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hardwarestore/models/account.dart';
import 'package:hardwarestore/services/django_services.dart';
import 'package:provider/provider.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('לקוחות'),
      ),
      body: Container(
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
                  initialValue: _data.name != null ? _data.name : "",
                  onSaved: (String? value) {
                    setState(() {
                      if (_data == null || _data.id == null || _data.id == 0) {
                        _data.id = 0;
                        _data.active = true;

                        _data.created_by =
                            Provider.of<GetCurrentUser>(context, listen: false)
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
                  initialValue: _data.phone != null ? _data.phone : "",
                  onSaved: (String? value) {
                    _data.phone = value;
                  },
                  decoration: const InputDecoration(
                      hintText: 'phone', labelText: 'Phone'),
                ),
                TextFormField(
                  initialValue: _data.street != null ? _data.street : "",
                  onSaved: (String? value) {
                    _data.street = value;
                  },
                  decoration: const InputDecoration(
                      hintText: 'street', labelText: 'Street'),
                ),
                TextFormField(
                  initialValue: _data.town != null ? _data.town : "",
                  onSaved: (String? value) {
                    _data.town = value;
                  },
                  decoration: const InputDecoration(
                      hintText: 'town', labelText: 'Town'),
                ),
                TextFormField(
                  initialValue:
                      _data.pobox != null ? _data.pobox.toString() : "",
                  onSaved: (String? value) {
                    if (value != "") _data.pobox = int.parse(value!);
                  },
                  decoration: const InputDecoration(
                      hintText: 'pobox', labelText: 'POBox'),
                ),
                TextFormField(
                  initialValue: _data.zip != null ? _data.zip.toString() : "",
                  onSaved: (String? value) {
                    if (value != "") _data.zip = int.parse(value!);
                  },
                  decoration:
                      const InputDecoration(hintText: 'zip', labelText: 'ZIP'),
                ),
                TextFormField(
                    initialValue:
                        _data.email != null ? _data.email.toString() : "",
                    keyboardType: TextInputType
                        .emailAddress, // Use email input type for emails.
                    decoration: const InputDecoration(
                        hintText: 'you@example.com',
                        labelText: 'E-mail Address'),
                    // validator: _validateEmail,
                    onSaved: (String? value) {
                      _data.email = value;
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
