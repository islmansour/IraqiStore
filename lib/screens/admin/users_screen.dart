import 'package:flutter/material.dart';

import '../../components/admin/users_component.dart';
import '../../models/user.dart';
import '../../services/search.dart';
import '../../widgets/user_min_admin.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ManageUserScreen extends StatefulWidget {
  const ManageUserScreen({Key? key}) : super(key: key);

  @override
  State<ManageUserScreen> createState() => _ManageUserScreenState();
}

class _ManageUserScreenState extends State<ManageUserScreen> {
  bool _searching = false;
  String _newSearch = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.users),
          backgroundColor: Colors.teal,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(left: 30.0, right: 30, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 300,
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            if (value.isEmpty) {
                              _searching = false;
                            } else {
                              _searching = true;
                            }
                            _newSearch = value;
                          });
                        },
                        decoration: InputDecoration(
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 200, 200, 200)),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 200, 200, 200)),
                          ),
                          hintText: AppLocalizations.of(context)!.search,
                          hintStyle: const TextStyle(
                            color: Color.fromARGB(255, 191, 190, 190),
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                          ),
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              if (_searching == false) UsersList(),
              if (_searching == true && _newSearch.length >= 3)
                FutureBuilder<List<SearchItem>?>(
                    future: ApplySearch().SearchAllObjects(context, _newSearch),
                    builder:
                        (context, AsyncSnapshot<List<SearchItem>?> searchSnap) {
                      if (searchSnap.connectionState == ConnectionState.none &&
                          searchSnap.hasData == null) {
                        return Container();
                      }
                      if (searchSnap.data?.length == null) return Container();
                      return SizedBox(
                          child: Padding(
                        padding: const EdgeInsets.only(right: 8.0, left: 8),
                        child: Scrollbar(
                            child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: searchSnap.data?.length,
                                itemBuilder: (context, index) {
                                  String type = "";
                                  Widget output = Text('');
                                  if (searchSnap.data != null) {
                                    type =
                                        searchSnap.data![index].type.toString();

                                    switch (type) {
                                      case "User":
                                        output = UserMiniAdmin(
                                            item: searchSnap.data![index].item
                                                as AppUser);
                                        break;
                                    }
                                  }
                                  return output;
                                })),
                      ));
                    }),
            ],
          ),
        ));
  }
}
