import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/imgbb_model.dart';

final imgBBkey = '77620f6bc5c71d69dc61e7460ff94a0f';
final imageString = 'https://imgur.com/4NH3806.png';

class ImgBB extends StatefulWidget {
  ImgBB({Key? key}) : super(key: key);

  @override
  State<ImgBB> createState() => _ImgBBState();
}

class _ImgBBState extends State<ImgBB> {
  bool delay = true;
  bool loading = false;
  String txt = 'Choose Image';
  Dio dio = new Dio();
  late ImgbbResponseModel imgbbResponse;

  File? _image;
  final picker = ImagePicker();

  Future getImage() async {
    print('testing');
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

  void uploadImageFile(File _image) async {
    setState(() {
      loading = true;
    });
    ByteData bytes = await rootBundle.load(_image.path);
    var buffer = bytes.buffer;
    var m = base64.encode(Uint8List.view(buffer));

    FormData formData = FormData.fromMap({"key": imgBBkey, "image": m});

    Response response = await dio.post(
      "https://api.imgbb.com/1/upload",
      data: formData,
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                TextButton(
                  onPressed: () async {
                    await getImage();
                    uploadImageFile(_image!);
                  },
                  child: _image == null
                      ? Text(txt)
                      : SizedBox(
                          height: 100, width: 100, child: Image.file(_image!)),
                ),
                const SizedBox(
                  height: 50,
                ),
                delay
                    ? Text(txt)
                    : CircleAvatar(
                        radius: 100,
                        backgroundImage: NetworkImage(
                            imgbbResponse.data!.displayUrl.toString()),
                      ),
                const Spacer(),
                Text(imageString)
              ],
            )),
    );
  }
}
