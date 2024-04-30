// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lovely_dog/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utility/my_constant.dart';

class createpost extends StatefulWidget {
  const createpost({Key? key}) : super(key: key);

  @override
  State<createpost> createState() => _createpostState();
}

class _createpostState extends State<createpost> {
  @override
  final formKey = GlobalKey<FormState>();

  File? file;
  TextEditingController text = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFFFF7544),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const FaIcon(FontAwesomeIcons.angleLeft)),
        title: Text(
          "เขียนโพสต์",
          style: GoogleFonts.sarabun(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        // actions: [
        //   IconButton(
        //       onPressed: () {}, icon: const FaIcon(FontAwesomeIcons.solidBell))
        // ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      child: TextFormField(
                          keyboardType: TextInputType.multiline,
                          minLines: 3,
                          maxLines: 10,
                          decoration: InputDecoration(
                            labelText: "เขียนโพสต์...",
                            labelStyle: GoogleFonts.sarabun(),
                            filled: true, //<-- SEE HERE
                            fillColor: Colors.white,
                            border: myinputborder(),
                            enabledBorder: myinputborder(),
                            focusedBorder: myfocusborder(),
                          ),
                          controller: text),
                    ),
                    Container(
                      child: showImage(),
                      padding: EdgeInsets.all(10),
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: 130,
                          height: 50,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                elevation: 0,
                                primary: Color(0xFFFF7544),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15))),
                            onPressed: () => chooseImage(ImageSource.gallery),
                            icon: FaIcon(
                              FontAwesomeIcons.solidImage,
                              size: 22,
                              color: Colors.white,
                            ),
                            label: Text(
                              'เพิ่มรูปภาพ',
                              style: GoogleFonts.sarabun(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 130,
                        ),
                        SizedBox(
                          width: 100,
                          height: 50,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                elevation: 0,
                                primary: Color(0xFFFF7544),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15))),
                            onPressed: () {
                              uploadPost();
                              Navigator.pop(context);
                            },
                            icon: FaIcon(
                              FontAwesomeIcons.solidPenToSquare,
                              size: 22,
                              color: Colors.white,
                            ),
                            label: Text(
                              'โพสต์',
                              style: GoogleFonts.sarabun(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  OutlineInputBorder myinputborder() {
    //return type is OutlineInputBorder
    return OutlineInputBorder(
        //Outline border type for TextFeild
        borderRadius: BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide(
          color: Color(0xFFFF7544),
          width: 2,
        ));
  }

  OutlineInputBorder myfocusborder() {
    return OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide(
          color: Color(0xFFFF7544),
          width: 2,
        ));
  }

  // chooseImage2() async {
  //   PickedFile pickedFile = (await ImagePicker().pickImage(
  //     source: ImageSource.gallery,
  //     maxWidth: 800,
  //     maxHeight: 800,
  //   )) as PickedFile;
  //   if (pickedFile != null) {
  //     setState(() {
  //       file = File(pickedFile.path);
  //     });
  //   }
  // }

  Future<Null> chooseImage(ImageSource imageSource) async {
    print(file);
    var object = await ImagePicker()
        .pickImage(source: imageSource, maxHeight: 800, maxWidth: 800);

    setState(() {
      file = File(object!.path);
    });
  }

  Future pickImageFromGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      file = File(image!.path);
    });
  }

  Widget showImage() {
    return Container(
      width: 350,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
      ),
      child: file == null ? const Text('') : Image.file(file!),
    );
  }

  Future<Null> uploadPost() async {
    if (file != null && text.text != null) {
      Random random = Random();
      int i = random.nextInt(100000);
      String nameImage = 'post$i.jpg';

      String url = '${MyConstant().domain}/dogservice/api/post.php';

      Map<String, dynamic> map = Map();
      map['file'] =
          await MultipartFile.fromFile(file!.path, filename: nameImage);

      FormData formData = FormData.fromMap(map);
      await Dio().post(url, data: formData).then((value) async {
        String urlPathImage =
            '${MyConstant().domain}/dogservice/api/postimg/$nameImage';
        print('Response => $urlPathImage');

        SharedPreferences preferences = await SharedPreferences.getInstance();
        String? userid = preferences.getString('user_id');
        print(userid);
        print(text.text);

        String urlImage = '/dogservice/api/postimg/$nameImage';
        String url = "${MyConstant().domain}/dogservice/addPost";

        final response = await http.post(Uri.parse(url), body: {
          'userid': userid,
          'text': text.text,
          'image': urlImage,
        });
        var data = json.decode(response.body);
        print(data);
      });
    }

    if (file == null) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? userid = preferences.getString('user_id');
      print(userid);
      print(text.text);

      String url = "${MyConstant().domain}/dogservice/addPostText";

      final response = await http.post(Uri.parse(url), body: {
        'userid': userid,
        'text': text.text,
      });
      var data = json.decode(response.body);
      print(data);
    }

    if (text.text == null) {
      Random random = Random();
      int i = random.nextInt(100000);
      String nameImage = 'post$i.jpg';

      String url = '${MyConstant().domain}/dogservice/api/post.php';

      Map<String, dynamic> map = Map();
      map['file'] =
          await MultipartFile.fromFile(file!.path, filename: nameImage);

      FormData formData = FormData.fromMap(map);
      await Dio().post(url, data: formData).then((value) async {
        String urlPathImage =
            '${MyConstant().domain}/dogservice/api/postimg/$nameImage';
        print('Response => $urlPathImage');

        SharedPreferences preferences = await SharedPreferences.getInstance();
        String? userid = preferences.getString('user_id');
        print(userid);
        print(text.text);

        String urlImage = '/dogservice/api/postimg/$nameImage';
        String url = "${MyConstant().domain}/dogservice/addPostImg";

        final response = await http.post(Uri.parse(url), body: {
          'userid': userid,
          'image': urlImage,
        });
        var data = json.decode(response.body);
        print(data);
      });
    }
  }
}
