import 'package:flutter/material.dart';
import '../components/bottomnav.dart';

class Chat extends StatelessWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('עיראקי'),
      ),
    );
  }
}
