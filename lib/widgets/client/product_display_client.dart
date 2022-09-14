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
        //   alignment: Alignment.topRight,
        fit: StackFit.passthrough,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        children: <Widget>[
          // Container(
          //   color: Colors.amber,
          //   alignment: Alignment.centerRight,
          //   height: 120,
          //   width: 120,
          //   // width: MediaQuery.of(context).size.width,
          //   //   height: MediaQuery.of(context).size.height * 0.15,
          //   child:
          img == 'http://localhost.com' || img == null || img == ""
              ? Container(
                  alignment: Alignment.topCenter,
                  //  color: Colors.red,
                  width: 100,
                  height: 100,
                  margin: EdgeInsets.all(10),
                  child: Icon(
                    Icons.broken_image,
                    size: 100,
                    color: Colors.grey,
                  ),
                )
              : Container(
                  alignment: Alignment.topCenter,
                  //  color: Colors.black,
                  width: 100,
                  height: 100,
                  margin: EdgeInsets.all(10),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(img!,
                          height: 90, width: 90.0, fit: BoxFit.cover)),
                ),
          //   ),
          if (discount!.isNotEmpty && double.parse(discount!) > 0)
            Positioned(
              top: -10,
              left: -10,
              child: ShowDiscount(
                  value: double.parse(discount!).toStringAsFixed(0)),
            ),
        ]);
  }
}

class DisplayProductClientLarge extends StatelessWidget {
  final String? img;
  final String? discount;

  const DisplayProductClientLarge({Key? key, this.discount, this.img})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
        //   alignment: Alignment.topRight,
        fit: StackFit.passthrough,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        children: <Widget>[
          // Container(
          //   color: Colors.amber,
          //   alignment: Alignment.centerRight,
          //   height: 120,
          //   width: 120,
          //   // width: MediaQuery.of(context).size.width,
          //   //   height: MediaQuery.of(context).size.height * 0.15,
          //   child:
          img == 'http://localhost.com' || img == null || img == ""
              ? Container(
                  alignment: Alignment.topCenter,
                  //  color: Colors.red,
                  width: 200,
                  height: 200,
                  margin: EdgeInsets.all(10),
                  child: Icon(
                    Icons.broken_image,
                    size: 200,
                    color: Colors.grey,
                  ),
                )
              : Container(
                  alignment: Alignment.topCenter,
                  //  color: Colors.black,
                  width: 200,
                  height: 200,
                  margin: EdgeInsets.all(10),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(img!,
                          height: 180, width: 180.0, fit: BoxFit.cover)),
                ),
          //   ),
          if (discount!.isNotEmpty && double.parse(discount!) > 0)
            Positioned(
              top: -10,
              left: -10,
              child: ShowDiscount(
                  value: double.parse(discount!).toStringAsFixed(0)),
            ),
        ]);
  }
}
