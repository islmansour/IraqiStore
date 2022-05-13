import 'package:flutter/material.dart';
import '../components/bottomnav.dart';

class Quotes extends StatelessWidget {
  const Quotes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('עיראקי'),
      ),
      bottomNavigationBar: const BottomNav(3),
    );
  }
}
