import 'package:flutter/material.dart';
import 'package:hardwarestore/components/admin/lov.dart';
import 'package:hardwarestore/models/lov.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CategoryFilterNotifier extends ChangeNotifier {
  String? searchCategory;

  setCategory(String category) {
    if (searchCategory == category)
      searchCategory = "";
    else
      searchCategory = category;
    notifyListeners();
  }
}

class CategoriesFilter extends StatefulWidget {
  CategoriesFilter({Key? key}) : super(key: key);

  @override
  State<CategoriesFilter> createState() => _categoriesFilterState();
}

class _categoriesFilterState extends State<CategoriesFilter> {
  setCategory(String value) {
    setState(() {
      Provider.of<CategoryFilterNotifier>(context, listen: false)
          .setCategory(value);
    });
  }

  @override
  void initState() {
    try {
      //   _searchCategory = CategoryFilterNotifier().searchCategory!;
    } catch (e) {}

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<ListOfValues> _categories =
        Provider.of<CurrentListOfValuesUpdates>(context).getListOfValue(
            'PRODUCT_CATEGORY', AppLocalizations.of(context)!.localeName);

    if (_categories == null || _categories.isEmpty) return Container();

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.75,
      height: 40,
      child: Scrollbar(
          child: ListView.builder(
              physics: const ScrollPhysics(),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                if (_categories != null) {}
                return Padding(
                  padding: const EdgeInsets.only(right: 4.0, left: 4),
                  child: Container(
                    width: 60,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Provider.of<CategoryFilterNotifier>(context)
                                    .searchCategory ==
                                _categories[index].name!
                            ? Colors.green
                            : Colors.redAccent,
                        border: Border.all(
                          color: Provider.of<CategoryFilterNotifier>(context)
                                      .searchCategory ==
                                  _categories[index].name!
                              ? Colors.green
                              : Colors.redAccent,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: TextButton(
                      child: Text(_categories[index].value!,
                          style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        setState(() {
                          setCategory(_categories[index].name!);
                        });
                      },
                    ),
                  ),
                );
              })),
    );
  }
}
