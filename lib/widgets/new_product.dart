import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hardwarestore/services/django_services.dart';

import '../models/products.dart';

class CreateNewProductForm extends StatefulWidget {
  CreateNewProductForm({Key? key}) : super(key: key);

  @override
  State<CreateNewProductForm> createState() => _CreateNewProductFormState();
}

class _CreateNewProductFormState extends State<CreateNewProductForm> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  Product _data = new Product();

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
      DjangoServices().upsertProduct(_data); // Save our form now.
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Product'),
      ),
      body: Container(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
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
                    _data.category = value;
                  },
                  decoration: const InputDecoration(
                      hintText: 'category', labelText: 'Category'),
                ),
                TextFormField(
                  onSaved: (String? value) {
                    _data.desc = value;
                  },
                  decoration: const InputDecoration(
                      hintText: 'description', labelText: 'Description'),
                ),
                TextFormField(
                  onSaved: (String? value) {
                    if (value != "") _data.discount = double.parse(value!);
                  },
                  decoration: const InputDecoration(
                      hintText: 'discount', labelText: 'discount'),
                ),
                TextFormField(
                  onSaved: (String? value) {
                    if (value != "") _data.price = double.parse(value!);
                  },
                  decoration: const InputDecoration(
                      hintText: 'price', labelText: 'Price'),
                ),
                TextFormField(
                    // Use email input type for emails.
                    decoration: const InputDecoration(
                        hintText: 'img', labelText: 'img'),
                    // validator: _validateEmail,
                    onSaved: (String? value) {
                      _data.img = value;
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
