import 'package:flutter/material.dart';
import '../components/bottomnav.dart';

class Products extends StatelessWidget {
  const Products({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('מוצרים'),
      ),
      bottomNavigationBar: const BottomNav(1),
    );
  }
}
