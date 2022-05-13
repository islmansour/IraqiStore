import 'package:flutter/material.dart';
import '../components/bottomnav.dart';

class Orders extends StatelessWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('הזמנות'),
      ),
      bottomNavigationBar: const BottomNav(2),
    );
  }
}
