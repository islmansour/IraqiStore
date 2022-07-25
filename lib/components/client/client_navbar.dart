import 'package:flutter/material.dart';
import 'package:hardwarestore/controllers/navigation.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

//ClientBottomNav
class ClientBottomNav extends StatelessWidget {
  final int activeButtonIndex;

  const ClientBottomNav(this.activeButtonIndex);

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
            navigation.changeScreen('/orders');
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
            icon: Icon(Icons.history), label: translation.orders),
        BottomNavigationBarItem(
            icon: Icon(Icons.chat), label: translation.chat),
        // BottomNavigationBarItem(
        //     icon: Icon(Icons.chat), label: translation.chat),
      ],
    );
  }
}
