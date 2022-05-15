import 'package:flutter/material.dart';
import 'package:hardwarestore/models/account.dart';

import '../models/contact.dart';

class ContactMiniAdmin extends StatelessWidget {
  final Contact item;

  const ContactMiniAdmin({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /*
    1 columns that has
    3 rows
      1st row: has one ListTile with one text: Contact Number + Contact Date
      2nd row: has 3 columns each as a container with a text.
        first column is the account name
        second column is the contact name
        third column : if contact exists, displays contact phone. otherwise display account phone
      3rd row: has 2 columns: First colum is Contact Status , second is dlivery status



    */
    return Container();
  }
}
