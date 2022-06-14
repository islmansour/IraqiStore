import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/navigation.dart';

class BottomNav extends StatelessWidget {
  final int activeButtonIndex;

  const BottomNav(this.activeButtonIndex);

  @override
  Widget build(BuildContext context) {
    NavigationController navigation =
        Provider.of<NavigationController>(context, listen: false);
    return BottomNavigationBar(
      currentIndex: activeButtonIndex,
      onTap: (buttonIndex) {
        switch (buttonIndex) {
          case 0:
            navigation.changeScreen('/');
            break;
          case 2:
            navigation.changeScreen('/orders');
            break;
          case 1:
            navigation.changeScreen('/products');
            break;
          case 3:
            navigation.changeScreen('/manage');
            break;
          case 4:
            navigation.changeScreen('/chat');
            break;
          case 9:
            navigation.changeScreen('/login');
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(Icons.help_center), label: 'Products'),
        BottomNavigationBarItem(icon: Icon(Icons.shop), label: 'Orders'),
        BottomNavigationBarItem(icon: Icon(Icons.apps), label: 'Manage'),
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
      ],
    );
  }
}
