import 'package:flutter/material.dart';
import 'package:hardwarestore/services/api.dart';
import 'package:hardwarestore/services/django_services.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../../services/tools.dart';
import '../../widgets/user_min_admin.dart';

class UsersList extends StatefulWidget {
  UsersList({Key? key}) : super(key: key);

  @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  List<AppUser>? myUsers;
  var isLoaded = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AppUser>?>(
        future: Repository().getUsers(),
        builder: (context, AsyncSnapshot<List<AppUser>?> userSnap) {
          if (userSnap.connectionState == ConnectionState.none &&
              userSnap.hasData == null) {
            return Container();
          }

          return SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Scrollbar(
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: userSnap.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        return UserMiniAdmin(item: userSnap.data![index]);
                      })));
        });
  }
}
