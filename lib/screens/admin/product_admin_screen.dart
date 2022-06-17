import 'package:flutter/material.dart';
import 'package:hardwarestore/components/navbaradmin.dart';

import '../../components/admin/product_admin_list_component.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProductsAdminScreen extends StatelessWidget {
  const ProductsAdminScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
              mainAxisSize: MainAxisSize.max, children: [ProductsList()])),
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(AppLocalizations.of(context)!.products),
      ),
      bottomNavigationBar: const AdminBottomNav(1),
    );
  }
}
