import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ShowDiscount extends StatelessWidget {
  final String? value;
  const ShowDiscount({Key? key, this.value}) : super(key: key);
//GoogleFonts.lato(fontStyle: FontStyle.italic)
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 35,
      width: 35,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          alignment: Alignment.bottomCenter,
          child: Text(
            value! + '%',
            style: TextStyle(
                fontFamily: 'Assistant',
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontSize: 12),
          ),
        ),
        Container(
          alignment: Alignment.topCenter,
          child: Text(
            AppLocalizations.of(context)!.discount,
            style: TextStyle(
                fontFamily: 'Assistant',
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 8),
          ),
        ),
      ]),
      margin: EdgeInsets.all(20.0),
      decoration:
          BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
    );
  }
}
