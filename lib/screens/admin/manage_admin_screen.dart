import 'package:flutter/material.dart';
import 'package:hardwarestore/components/navbaradmin.dart';

import '../../components/account.dart';
import '../../components/contact.dart';

class ManageAdminScreen extends StatelessWidget {
  const ManageAdminScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [AccountsList(), ContactsList()])),
      appBar: AppBar(
        title: const Text('ניהול'),
      ),
      bottomNavigationBar: const AdminBottomNav(2),
    );
  }
}
