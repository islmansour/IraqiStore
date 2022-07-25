import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/navigation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

//ClientBottomNav
class AdminBottomNav extends StatelessWidget {
  final int activeButtonIndex;

  const AdminBottomNav(this.activeButtonIndex);

  @override
  Widget build(BuildContext context) {
    var translation = AppLocalizations.of(context);
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
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.home), label: translation!.home),
        BottomNavigationBarItem(
            icon: Icon(Icons.category), label: translation.products),
        BottomNavigationBarItem(
            icon: Icon(Icons.apps), label: translation.manage),
        // BottomNavigationBarItem(
        //     icon: Icon(Icons.chat), label: translation.chat),
      ],
    );
  }
}
