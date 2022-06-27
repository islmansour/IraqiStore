import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hardwarestore/components/user.dart';
import 'package:hardwarestore/models/contact.dart';
import 'package:hardwarestore/services/api.dart';
import 'package:hardwarestore/services/tools.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Contact? _data = Contact();

  @override
  Widget build(BuildContext context) {
    String? _lang = AppLocalizations.of(context)!.localeName;
    if (_data!.id == null)
      _data = Provider.of<GetCurrentUser>(context).currentUser?.contact!;
    var translation = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  border: Border(
                bottom: BorderSide(width: 1.0, color: Colors.black),
              )),
              child: Padding(
                padding: const EdgeInsets.only(right: 20.0, top: 20),
                child: Text(
                  translation!.details,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(right: 35),
              width: 200,
              child: Column(
                children: [
                  TextFormField(
                    initialValue: _data!.first_name ?? "",
                    onChanged: (String? value) {
                      setState(() {
                        if (_data!.id == null || _data!.id == 0) {
                          _data!.id = 0;
                          _data!.active = true;

                          _data!.created_by = Provider.of<GetCurrentUser>(
                                  context,
                                  listen: false)
                              .currentUser
                              ?.id;
                        }
                        _data!.first_name = value;
                      });
                    },
                    decoration: InputDecoration(
                        hintText: translation.firstName,
                        labelText: translation.firstName),
                  ),
                  TextFormField(
                    initialValue: _data!.last_name ?? "",
                    onChanged: (String? value) {
                      setState(() {
                        if (_data!.id == null || _data!.id == 0) {
                          _data!.id = 0;
                          _data!.active = true;

                          _data!.created_by = Provider.of<GetCurrentUser>(
                                  context,
                                  listen: false)
                              .currentUser
                              ?.id;
                        }
                        _data!.last_name = value;
                      });
                    },
                    decoration: InputDecoration(
                        hintText: translation.lastName,
                        labelText: translation.lastName),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: ElevatedButton(
                      onPressed: () {
                        Provider.of<GetCurrentUser>(context, listen: false)
                            .currentUser
                            ?.contact = _data;
                        Provider.of<EntityModification>(context, listen: false)
                            .updateContact(_data!);
                        Repository().upsertContact(_data!);
                      },
                      child: Text(
                        translation.save,
                      )),
                )
              ],
            ),
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  border: Border(
                bottom: BorderSide(width: 1.0, color: Colors.black),
              )),
              child: Padding(
                padding: const EdgeInsets.only(right: 20.0, top: 20),
                child: Text(
                  translation.appLanguage,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
            ListTile(
              title:
                  Text('عربية', style: Theme.of(context).textTheme.bodyMedium),
              leading: Radio(
                value: "ar",
                groupValue: _lang,
                activeColor: Colors.green,
                onChanged: (String? value) {
                  setState(() {
                    _lang = value;
                    Provider.of<GetCurrentUser>(context, listen: false)
                        .setLocale(value!);

                    //           AppLocalizations.of(context)!.localeName = value;
                  });
                },
              ),
            ),
            ListTile(
              title:
                  Text('עברית', style: Theme.of(context).textTheme.bodyMedium),
              leading: Radio(
                value: "he",
                groupValue: _lang,
                activeColor: Colors.green,
                onChanged: (String? value) {
                  setState(() {
                    _lang = value;

                    Provider.of<GetCurrentUser>(context, listen: false)
                        .setLocale(value!);
                  });
                },
              ),
            ),
            ListTile(
              title: Text('English',
                  style: Theme.of(context).textTheme.bodyMedium),
              leading: Radio(
                value: "en",
                groupValue: _lang,
                activeColor: Colors.green,
                onChanged: (String? value) {
                  setState(() {
                    _lang = value;

                    Provider.of<GetCurrentUser>(context, listen: false)
                        .setLocale(value!);
                  });
                },
              ),
            ),
          ]),
    );
  }
}
