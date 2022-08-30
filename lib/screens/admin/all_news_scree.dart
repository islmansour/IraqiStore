import 'package:flutter/material.dart';
import 'package:hardwarestore/components/admin/admin_news.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hardwarestore/screens/admin/new_news.dart';

class AllNewsScreen extends StatefulWidget {
  const AllNewsScreen({Key? key}) : super(key: key);

  @override
  State<AllNewsScreen> createState() => _AllNewsScreenState();
}

class _AllNewsScreenState extends State<AllNewsScreen> {
  bool _searching = false;
  String _newSearch = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green.shade500,
          child: Icon(Icons.add),
          onPressed: () {
            //NewNewsStepper
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NewNewsStepper()),
            );
          },
        ),
        appBar: AppBar(
          backgroundColor: Colors.green.shade500,
          title: Text(AppLocalizations.of(context)!.news),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              if (_searching == false) NewsList(),
            ],
          ),
        ));
  }
}
