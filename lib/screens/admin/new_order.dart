import 'package:flutter/material.dart';
import 'package:hardwarestore/components/admin/lov.dart';
import 'package:hardwarestore/models/account.dart';
import 'package:hardwarestore/models/lov.dart';
import 'package:hardwarestore/services/api.dart';
import 'package:hardwarestore/services/tools.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../components/add_items_to_orders.dart';
import '../../components/user.dart';
import '../../models/contact.dart';
import '../../models/orders.dart';

class CreateNewOrderForm extends StatefulWidget {
  CreateNewOrderForm({Key? key}) : super(key: key);
  bool hasAccount = false;

  @override
  State<CreateNewOrderForm> createState() => _CreateNewOrderFormState();
}

class _CreateNewOrderFormState extends State<CreateNewOrderForm> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  Order _data = Order();

  void submit() {
    try {
      // First validate form.
      if (_formKey.currentState!.validate()) {
        _formKey.currentState?.save();
        //DjangoServices().upsertOrder(_data)?.then((value) {
        Repository().upsertOrder(_data)?.then((value) {
          _data.id == value;
          Provider.of<EntityModification>(context, listen: false).update(_data);
        });
        Navigator.pop(context);
        // Save our form now.
      }
    } catch (e) {
      Scaffold.of(context).showSnackBar(
          const SnackBar(content: Text("התרחשה תקלה בשמירת  ההזמנה החדשה.")));
    }
  }

  void submitProducts() {
    try {
      // First validate form.
      if (_formKey.currentState!.validate()) {
        _formKey.currentState?.save();
        //DjangoServices().upsertOrder(_data)?.then((value) {
        Repository().upsertOrder(_data)?.then((value) {
          _data.id == value;
          Provider.of<EntityModification>(context, listen: false).update(_data);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      AddItemToOrder(orderId: _data.id)));
        });

        // Save our form now.
      }
    } catch (e) {
      Scaffold.of(context).showSnackBar(
          const SnackBar(content: Text("התרחשה תקלה במעבר למסך מוצרים.")));
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
                DropdownButtonFormField(
                    items: Provider.of<EntityModification>(context)
                        .accounts
                        .map((Account acc) {
                      return DropdownMenuItem(
                          value: acc.id,
                          child: Row(
                            children: <Widget>[
                              const Icon(
                                Icons.business_rounded,
                                size: 14,
                                color: Colors.lightBlue,
                              ),
                              const Text(' '),
                              Text(
                                acc.name!,
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 12),
                              ),
                            ],
                          ));
                    }).toList(),
                    onChanged: (newValue) {
                      try {
                        // do other stuff with _category
                        setState(() {
                          _data.accountId = int.parse(newValue.toString());
                          _data.id = 0;
                          widget.hasAccount = true;
                          _data.created_by = Provider.of<GetCurrentUser>(
                                  context,
                                  listen: false)
                              .currentUser
                              ?.id;
                        });
                      } catch (e) {
                        Scaffold.of(context).showSnackBar(const SnackBar(
                            content: Text(
                                "התרחשה תקלה בהכנת רשימת הלקוחות לבחירה.")));
                      }
                    },
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(right: 8))),
                _data.accountId != null
                    ? DropdownButtonFormField(
                        items: Provider.of<EntityModification>(context)
                            .contacts
                            .where((element) => element.id == _data.accountId)
                            .toList()
                            .map((Contact con) {
                          return DropdownMenuItem(
                              value: con.id,
                              child: Row(
                                children: <Widget>[
                                  const Icon(
                                    Icons.people,
                                    size: 14,
                                    color: Colors.lightBlue,
                                  ),
                                  const Text(' '),
                                  Text(
                                    con.first_name! + ' ' + con.last_name!,
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 12),
                                  ),
                                ],
                              ));
                        }).toList(),
                        onChanged: (newValue) {
                          // do other stuff with _category
                          try {
                            setState(() {
                              _data.contactId = int.parse(newValue.toString());
                            });
                          } catch (e) {
                            Scaffold.of(context).showSnackBar(const SnackBar(
                                content: Text(
                                    "התרחשה תקלה בבחירת איש קשר להזמנה.")));
                          }
                        },
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.only(right: 8)))
                    : Container(),
                TextFormField(
                  onSaved: (String? value) {
                    _data.notes = value!;
                  },
                  decoration: const InputDecoration(
                      hintText: 'notes', labelText: 'Notes'),
                ),
                DropdownButtonFormField(
                    items: Provider.of<CurrentListOfValuesUpdates>(context)
                        .getListOfValue('ORDER_STATUS', format.locale)
                        .map((ListOfValues status) {
                      return DropdownMenuItem(
                          value: status.name,
                          child: Row(
                            children: <Widget>[
                              const Icon(Icons.star),
                              Text(status.value!),
                            ],
                          ));
                    }).toList(),
                    onChanged: (newValue) {
                      try {
                        // do other stuff with _category
                        setState(() => _data.status = newValue.toString());
                      } catch (e) {
                        Scaffold.of(context).showSnackBar(const SnackBar(
                            content: Text("התרחשה תקלה בבחירת ססטוס ההסמנה.")));
                      }
                    },
                    value: _data.status == "" || _data.status == null
                        ? Provider.of<CurrentListOfValuesUpdates>(context)
                            .activeListOfValues
                            .where((element) =>
                                element.language == format.locale &&
                                element.name == 'new' &&
                                element.type == 'ORDER_STATUS')
                            .first
                            .name
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
                Column(
                  children: [
                    Container(
                      width: screenSize.width,
                      child: ElevatedButton(
                        child: const Text(
                          'Add Products',
                          style: TextStyle(color: Colors.green),
                        ),
                        onPressed: submitProducts,
                      ),
                      margin: const EdgeInsets.only(top: 20.0),
                    ),
                    Container(
                      width: screenSize.width,
                      child: ElevatedButton(
                        child: const Text(
                          'Save',
                          style: TextStyle(color: Colors.green),
                        ),
                        onPressed: submit,
                      ),
                      margin: const EdgeInsets.only(top: 20.0),
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }
}
