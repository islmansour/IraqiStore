import 'package:flutter/material.dart';
import 'package:hardwarestore/components/account.dart';
import 'package:hardwarestore/components/admin/lov.dart';
import 'package:hardwarestore/models/account.dart';
import 'package:hardwarestore/models/lov.dart';
import 'package:hardwarestore/services/django_services.dart';
import 'package:hardwarestore/services/tools.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../components/user.dart';
import '../../models/orders.dart';

class CreateNewOrderForm extends StatefulWidget {
  CreateNewOrderForm({Key? key}) : super(key: key);

  @override
  State<CreateNewOrderForm> createState() => _CreateNewOrderFormState();
}

class _CreateNewOrderFormState extends State<CreateNewOrderForm> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  Order _data = Order();

  void submit() {
    // First validate form.
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      DjangoServices().upsertOrder(_data); // Save our form now.
    }
  }

  @override
  Widget build(BuildContext context) {
    var format = NumberFormat.simpleCurrency(locale: 'he');

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
                // TextFormField(
                //   onSaved: (String? value) {
                //     if (value != "") _data.accountId = int.parse(value!);
                //     _data.id = 0;
                //     _data.quoteId = 1;

                //     _data.created_by =
                //         Provider.of<GetCurrentUser>(context, listen: false)
                //             .currentUser
                //             ?.id;
                //   },
                //   decoration: const InputDecoration(
                //       hintText: 'account', labelText: 'Account'),
                // ),
                DropdownButtonFormField(
                    items: Provider.of<CurrentAccountsUpdate>(context)
                        .accounts
                        ?.map((Account acc) {
                      return DropdownMenuItem(
                          value: acc.id,
                          child: Row(
                            children: <Widget>[
                              const Icon(Icons.star),
                              Text(acc.name!),
                            ],
                          ));
                    }).toList(),
                    onChanged: (newValue) {
                      // do other stuff with _category
                      setState(() {
                        _data.accountId = int.parse(newValue.toString());
                        _data.id = 0;
                        _data.quoteId = 1;

                        _data.created_by =
                            Provider.of<GetCurrentUser>(context, listen: false)
                                .currentUser
                                ?.id;
                      });
                    },
                    //value: _data.accountId == "" || _data.accountId == null
                    //    ? ""
                    //     : _data.accountId,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(right: 8))),
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
                // TextFormField(
                //   onSaved: (String? value) {
                //     if (value != "") _data.status = "1";
                //   },
                //   decoration: const InputDecoration(
                //       hintText: 'status', labelText: 'Status'),
                // ),
                DropdownButtonFormField(
                    items: Provider.of<CurrentListOfValuesUpdates>(context)
                        .getListOfValue('ORDER_STATUS', format.locale)
                        .map((ListOfValues status) {
                      return DropdownMenuItem(
                          value: status.value,
                          child: Row(
                            children: <Widget>[
                              const Icon(Icons.star),
                              Text(status.value!),
                            ],
                          ));
                    }).toList(),
                    onChanged: (newValue) {
                      // do other stuff with _category
                      setState(() => _data.status = newValue.toString());
                    },
                    value: _data.status == "" || _data.status == null
                        ? Provider.of<CurrentListOfValuesUpdates>(context)
                            .activeListOfValues
                            .where((element) =>
                                element.language == format.locale &&
                                element.name == 'new' &&
                                element.type == 'ORDER_STATUS')
                            .first
                            .value
                        : _data.status,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(right: 8))),
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
