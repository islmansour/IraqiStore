import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hardwarestore/models/products.dart';
import 'package:hardwarestore/services/api.dart';
import 'package:hardwarestore/services/django_services.dart';
import 'package:hardwarestore/services/tools.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'dart:io';
import '../models/imgbb_model.dart';

final imgBBkey = '77620f6bc5c71d69dc61e7460ff94a0f';
final imageString = 'https://imgur.com/4NH3806.png';

class ProductDetailsAdmin extends StatefulWidget {
  final Product item;

  const ProductDetailsAdmin({Key? key, required this.item}) : super(key: key);

  @override
  State<ProductDetailsAdmin> createState() => _ProductDetailsAdminState();
}

class _ProductDetailsAdminState extends State<ProductDetailsAdmin> {
  bool delay = true;
  bool loading = false;
  String txt = 'Choose Image';
  Dio dio = Dio();
  late ImgbbResponseModel imgbbResponse;

  File? _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      try {
        _image = File(pickedFile!.path);
      } catch (e) {
        print(e.toString());
      }
    });
  }

  void uploadingImageViaImageUrl() async {
    setState(() {
      loading = true;
    });
    FormData formData =
        FormData.fromMap({"key": imgBBkey, "image": imageString});

    Response response =
        await dio.post("https://api.imgbb.com/1/upload", data: formData);
    if (response.statusCode != 400) {
      imgbbResponse = ImgbbResponseModel.fromJson(response.data);
      setState(() {
        delay = false;
        loading = false;
      });
    } else {
      txt = 'Error Upload';
      setState(() {
        loading = false;
      });
    }
  }

  void uploadImageFile(File _image, Product product) async {
    setState(() {
      loading = true;
    });

    List<int> imageBytes = _image.readAsBytesSync();
    String baseimage = base64Encode(imageBytes);

    // ByteData bytes = await rootBundle.load(_image.path);
    // var buffer = bytes.buffer;
    var m = baseimage; //base64.encode(Uint8List.view(buffer));

    FormData formData = FormData.fromMap({"key": imgBBkey, "image": m});

    Response response = await dio.post(
      "https://api.imgbb.com/1/upload",
      data: formData,
    );
    if (response.statusCode != 400) {
      imgbbResponse = ImgbbResponseModel.fromJson(response.data);
      Provider.of<EntityModification>(context, listen: false)
          .products
          .where((element) => element.id == widget.item.id)
          .first
          .img = imgbbResponse.data?.displayUrl;
      Product? _p = Provider.of<EntityModification>(context, listen: false)
          .products
          .where((element) => element.id == widget.item.id)
          .first;

      Repository().upsertProduct(_p);
      setState(() {
        delay = false;
        loading = false;
      });
    } else {
      txt = 'Error Upload';
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    /*
    1 columns that has
    3 rows
      1st row: has one ListTile with one text: Product Number + Product Date
      2nd row: has 3 columns each as a container with a text.
        first column is the account name
        second column is the contact name
        third column : if contact exists, displays contact phone. otherwise display account phone
      3rd row: has 2 columns: First colum is Product Status , second is dlivery status



    */
    String? currentImg = Provider.of<EntityModification>(context, listen: false)
        .products
        .where((element) => element.id == widget.item.id)
        .first
        .img;

    return Container(
        padding: const EdgeInsets.all(5),
        height: 120,
        width: double.infinity,
        child: Column(
          children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: () async {
                      await getImage();
                      if (_image != null) uploadImageFile(_image!, widget.item);
                    },
                    child: currentImg == 'http://localhost.com'
                        ? Text(txt)
                        : SizedBox(
                            height: 75,
                            width: 75,
                            child: Image.network(currentImg!)),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.item.name.toString(),
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                ],
              ),
            ]),
            Row(
              children: [
                Column(
                  children: [
                    Text(widget.item.price.toString(),
                        style: Theme.of(context).textTheme.displayMedium),
                  ],
                ),
                Column(
                  children: [
                    Text(widget.item.desc.toString(),
                        style: Theme.of(context).textTheme.displayMedium),
                  ],
                ),
                Column(
                  children: [
                    Text(widget.item.active.toString(),
                        style: Theme.of(context).textTheme.displayMedium),
                  ],
                )
              ],
            ),
            Row(
              children: [
                Column(
                  children: [],
                )
              ],
            ),
          ],
        ));
  }
}
