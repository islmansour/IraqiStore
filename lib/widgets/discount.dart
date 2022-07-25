import 'package:flutter/material.dart';

class ShowDiscount extends StatelessWidget {
  final String? value;
  const ShowDiscount({Key? key, this.value}) : super(key: key);
//GoogleFonts.lato(fontStyle: FontStyle.italic)
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 60,
      width: 60,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          alignment: Alignment.bottomCenter,
          child: Text(
            value! + '%',
            style: TextStyle(
                fontFamily: 'Assistant',
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontSize: 18),
          ),
        ),
        Container(
          alignment: Alignment.topCenter,
          child: Text(
            'הנחה',
            style: TextStyle(
                fontFamily: 'Assistant',
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 12),
          ),
        ),
      ]),
      margin: EdgeInsets.all(20.0),
      decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
    );
  }
}
