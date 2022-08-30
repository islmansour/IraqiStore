import 'package:flutter/material.dart';
import 'package:hardwarestore/components/user_notification_comp.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserNotificationsSceeen extends StatelessWidget {
  const UserNotificationsSceeen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CurrentUserNotifications(), //NewsList(),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.notifications),
      ),
      // bottomNavigationBar: const BottomNav(0),
    );
  }
}
