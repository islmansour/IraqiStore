import 'package:flutter/material.dart';
import 'package:hardwarestore/widgets/discount.dart';

class DisplayProductClient extends StatelessWidget {
  final String? img;
  final String? discount;

  const DisplayProductClient({Key? key, this.discount, this.img})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
        // alignment: Alignment.topCenter,
        fit: StackFit.passthrough,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            // width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.25,
            child: img == 'http://localhost.com' || img == null || img == ""
                ? Icon(
                    Icons.broken_image,
                    size: 100,
                    color: Colors.grey,
                  )
                : SizedBox(child: Image.network(img!)),
          ),
          if (discount!.isNotEmpty && double.parse(discount!) > 0)
            Positioned(
              top: -20,
              left: -20,
              child: ShowDiscount(value: discount),
            ),
        ]);
  }
}
