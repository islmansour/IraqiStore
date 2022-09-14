import 'package:flutter/material.dart';
import 'package:hardwarestore/services/api.dart';
import 'package:hardwarestore/services/django_services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../models/lov.dart';

class ListOfValuesList extends StatefulWidget {
  String? lov;
  ListOfValuesList({Key? key, required this.lov}) : super(key: key);

  @override
  State<ListOfValuesList> createState() => _ListOfValuesListState();
}

class _ListOfValuesListState extends State<ListOfValuesList> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class CurrentListOfValuesUpdates extends ChangeNotifier {
  List<ListOfValues> activeListOfValues = [];
  loadLovs() {
    Repository().getLOVs().then((value) => activeListOfValues = value!);
    //notifyListeners();
  }

  List<ListOfValues> getListOfValue(String type, String language) {
    List<ListOfValues> x = activeListOfValues
        .where(
            (element) => element.type == type && element.language == language)
        .toList();
    return x;
  }

  void changeListOfValues(ListOfValues newListOfValues) {
    activeListOfValues.add((newListOfValues));
    notifyListeners();
  }
}
