import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/navigation.dart';

class AdminBottomNav extends StatelessWidget {
  final int activeButtonIndex;

  const AdminBottomNav(this.activeButtonIndex);

  @override
  Widget build(BuildContext context) {
    NavigationController navigation =
        Provider.of<NavigationController>(context, listen: false);
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: activeButtonIndex,
      onTap: (buttonIndex) {
        switch (buttonIndex) {
          case 0:
            navigation.changeScreen('/');
            break;
          case 1:
            navigation.changeScreen('/product-admin');
            break;

          case 2:
            navigation.changeScreen('/manage');
            break;
          case 3:
            navigation.changeScreen('/chat');
            break;
          case 9:
            navigation.changeScreen('/login');
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Products'),
        BottomNavigationBarItem(icon: Icon(Icons.apps), label: 'Manage'),
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
      ],
    );
  }
}
