import 'package:flutter/material.dart';
import 'package:hardwarestore/services/django_services.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';

class CurrentUser extends StatefulWidget {
  final String userId;
  const CurrentUser({Key? key, required this.userId}) : super(key: key);

  @override
  State<CurrentUser> createState() => _CurrentUserState();
}

class _CurrentUserState extends State<CurrentUser> {
  var isLoaded = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<User>?>(
        future: DjangoServices().getUser(widget.userId),
        builder: (context, AsyncSnapshot<List<User>?> userSnap) {
          if (userSnap.connectionState == ConnectionState.none &&
              // ignore: unnecessary_null_comparison
              userSnap.hasData == null) {
            return Container();
          }
          int len = userSnap.data?.length ?? 0;
          Provider.of<GetCurrentUser>(context).currentUser =
              userSnap.data?.first;
          return Container();
        });
  }
}

class GetCurrentUser extends ChangeNotifier {
  User? currentUser;
  void updateUser(User user) {
    currentUser = user;
    notifyListeners();
  }

  void usersLoaded() {
    notifyListeners();
  }
}
