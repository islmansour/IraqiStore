import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hardwarestore/services/api.dart';
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
    return FutureBuilder<List<AppUser>?>(
        future: Repository().getUser(widget.userId),
        builder: (context, AsyncSnapshot<List<AppUser>?> userSnap) {
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
  AppUser? currentUser;
  Uint8List? exportSignature;

  void updateUser(AppUser user) {
    currentUser = user;
    if (currentUser!.contact == null && currentUser!.contactId != null) {
      Repository()
          .getSingleContact(currentUser!.contactId.toString())
          .then((value) {
        currentUser!.contact = value;
      });
    }
    notifyListeners();
  }

  void setLocale(String lang) {
    currentUser!.language = lang;
    notifyListeners();
  }

  storeSignature(Uint8List? sig) {
    exportSignature = sig;
    // notifyListeners();
  }

  void usersLoaded() {
    notifyListeners();
  }
}
