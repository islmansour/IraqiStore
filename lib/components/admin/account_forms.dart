import 'package:flutter/material.dart';
import 'package:hardwarestore/models/legal_document.dart';
import 'package:hardwarestore/services/api.dart';
import 'package:provider/provider.dart';

import '../../models/account.dart';

import '../../models/forms.dart';
import '../../services/tools.dart';
import '../../widgets/form_min_admin.dart';

class AccountLegalFormsList extends StatefulWidget {
  Account? account;
  AccountLegalFormsList({Key? key, required this.account}) : super(key: key);

  @override
  State<AccountLegalFormsList> createState() => _AccountLegalFormsListState();
}

class _AccountLegalFormsListState extends State<AccountLegalFormsList> {
  var isLoaded = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          flex: 70,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Scrollbar(
              child: FutureBuilder<List<LegalDocument>?>(
                  builder: ((context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting)
                      return Container();

                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return LegalFormMiniAdmin(
                              item: snapshot.data![index]);
                        });
                    return Container();
                  }),
                  future: Repository().getFormsByAccount(
                    widget.account!.id.toString(),
                  )),
            ),
          ),
        )
      ],
    );
  }
}
