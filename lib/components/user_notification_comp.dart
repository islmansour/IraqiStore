import 'package:flutter/material.dart';
import 'package:hardwarestore/components/user.dart';
import 'package:hardwarestore/models/user.dart';
import 'package:hardwarestore/models/userNotifications.dart';
import 'package:hardwarestore/services/api.dart';
import 'package:hardwarestore/widgets/usernotification_card.dart';
import 'package:provider/provider.dart';

class CurrentUserNotifications extends StatefulWidget {
  const CurrentUserNotifications({
    Key? key,
  }) : super(key: key);

  @override
  State<CurrentUserNotifications> createState() =>
      _CurrentUserNotificationsState();
}

class _CurrentUserNotificationsState extends State<CurrentUserNotifications> {
  var isLoaded = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<UserNotifications>?>(
        future: Repository().getUserNotifications(
            Provider.of<GetCurrentUser>(context).currentUser!),
        builder: (context,
            AsyncSnapshot<List<UserNotifications>?> usernotificationSnap) {
          if (usernotificationSnap.connectionState == ConnectionState.waiting) {
            return Center(child: Text('Please wait its loading...'));
          } else {
            // ignore: unnecessary_null_comparison
            if (usernotificationSnap.hasError)
              return Center(
                  child: Text('Error: ${usernotificationSnap.error}'));
            // snapshot.data  :- get your object which is pass from your downloadData() function
          }

          return SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Scrollbar(
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: usernotificationSnap.data!.length,
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: UserNotificationsMiniAdmin(
                                item: usernotificationSnap.data![index],
                              ),
                            )
                          ],
                        );
                      })));
        });
  }
}

// class GetCurrentUserNotifications extends ChangeNotifier {
//   AppUserNotifications? currentUserNotifications;
//   Uint8List? exportSignature;

//   void updateUserNotifications(AppUserNotifications usernotification) {
//     currentUserNotifications = usernotification;
//     notifyListeners();
//   }

//   void setLocale(String lang) {
//     currentUserNotifications!.language = lang;
//     notifyListeners();
//   }

//   storeSignature(Uint8List? sig) {
//     exportSignature = sig;
//     // notifyListeners();
//   }

//   void usernotificationsLoaded() {
//     notifyListeners();
//   }
// }
