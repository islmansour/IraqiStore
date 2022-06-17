import 'package:flutter/material.dart';
import 'package:hardwarestore/services/api.dart';
import 'package:hardwarestore/widgets/account_contact_admin.dart';
import 'package:provider/provider.dart';

import '../../models/account.dart';
import '../../models/contact.dart';
import '../../services/search.dart';
import '../../services/tools.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AccountContactsList extends StatefulWidget {
  final Account? account;
  AccountContactsList({Key? key, this.account}) : super(key: key);

  @override
  State<AccountContactsList> createState() => _AccountContactsListState();
}

class _AccountContactsListState extends State<AccountContactsList> {
  bool _searching = false;
  String _newSearch = "";
  List<Contact>? myContacts;
  var isLoaded = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Contact>?>(
        future: Repository().getContacts(),
        builder: (context, AsyncSnapshot<List<Contact>?> contactSnap) {
          if (contactSnap.connectionState == ConnectionState.none &&
              contactSnap.hasData == null) {
            return Container();
          }

          return Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(left: 30.0, right: 30, bottom: 30),
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
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 200, 200, 200)),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 200, 200, 200)),
                          ),
                          hintText: AppLocalizations.of(context)!.search,
                          hintStyle: TextStyle(
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
              if (_searching == true && _newSearch.length >= 3)
                FutureBuilder<List<SearchItem>?>(
                    future: ApplySearch().SearchAllObjects(context, _newSearch),
                    builder:
                        (context, AsyncSnapshot<List<SearchItem>?> searchSnap) {
                      if (searchSnap.connectionState == ConnectionState.none &&
                          searchSnap.hasData == null) {
                        return Container();
                      }

                      return SizedBox(
                          height: MediaQuery.of(context).size.height / 2,
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
                                        type = searchSnap.data![index].type
                                            .toString();

                                        switch (type) {
                                          case "Contact":
                                            output = AccountContactFrom(
                                              item: searchSnap.data![index].item
                                                  as Contact,
                                              account: widget.account,
                                            );
                                            break;
                                        }
                                      }
                                      return output;
                                    })),
                          ));
                    }),
              if (_searching == false)
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: Scrollbar(
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: contactSnap.data?.length ?? 0,
                            itemBuilder: (context, index) {
                              Provider.of<EntityModification>(context)
                                  .contacts = contactSnap.data!;
                              return AccountContactFrom(
                                item: contactSnap.data![index],
                                account: widget.account,
                              );
                            }))),
            ],
          );
        });
  }
}
