import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hardwarestore/models/account.dart';
import 'package:hardwarestore/services/django_services.dart';
import 'package:flutter_otp/flutter_otp.dart';

FlutterOtp otp = FlutterOtp();

class CreateNewAccountForm extends StatefulWidget {
  CreateNewAccountForm({Key? key}) : super(key: key);
  String phoneNumber = "548004990"; //enter your 10 digit number
  int minNumber = 1000;
  int maxNumber = 6000;
  String countryCode = "+972";
  @override
  State<CreateNewAccountForm> createState() => _CreateNewAccountFormState();
}

class _CreateNewAccountFormState extends State<CreateNewAccountForm> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  Account _data = new Account();

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
      DjangoServices().upsertAccount(_data); // Save our form now.
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Account'),
      ),
      body: Container(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                TextButton(
                  child: Text(
                    "Send",
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    // call sentOtp function and pass the parameters

                    otp.sendOtp(
                        '548004990',
                        'OTP is : pass the generated otp here ',
                        1000,
                        9999,
                        '+972');
                  },
                ),
                TextFormField(
                  onSaved: (String? value) {
                    _data.name = value;
                    _data.id = 0;
                    _data.active = true;
                  },
                  decoration: const InputDecoration(
                      hintText: 'name', labelText: 'Name'),
                ),
                TextFormField(
                  onSaved: (String? value) {
                    _data.phone = value;
                  },
                  decoration: const InputDecoration(
                      hintText: 'phone', labelText: 'Phone'),
                ),
                TextFormField(
                  onSaved: (String? value) {
                    _data.street = value;
                  },
                  decoration: const InputDecoration(
                      hintText: 'street', labelText: 'Street'),
                ),
                TextFormField(
                  onSaved: (String? value) {
                    _data.town = value;
                  },
                  decoration: const InputDecoration(
                      hintText: 'town', labelText: 'Town'),
                ),
                TextFormField(
                  onSaved: (String? value) {
                    if (value != "") _data.pobox = int.parse(value!);
                  },
                  decoration: const InputDecoration(
                      hintText: 'pobox', labelText: 'POBox'),
                ),
                TextFormField(
                  onSaved: (String? value) {
                    if (value != "") _data.zip = int.parse(value!);
                  },
                  decoration:
                      const InputDecoration(hintText: 'zip', labelText: 'ZIP'),
                ),
                TextFormField(
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
