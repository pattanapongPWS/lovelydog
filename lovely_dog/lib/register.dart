// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lovely_dog/login.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/user_model.dart';
import 'user.dart';
import 'utility/my_constant.dart';
import 'utility/normalDialog.dart';

class register extends StatefulWidget {
  const register({Key? key}) : super(key: key);

  @override
  State<register> createState() => _registerState();
}

class _registerState extends State<register> {
  @override
  final formKey = GlobalKey<FormState>();

  File? file;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController nickname = TextEditingController();
  TextEditingController phone = TextEditingController();

  Future<Null> user(UserModel userModel) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('user_id', userModel.userId.toString());
  }

  Future sign_up() async {
    if (file == null) {
      String url = "${MyConstant().domain}/dogservice/register";
      final response = await http.post(Uri.parse(url), body: {
        'email': email.text,
        'password': password.text,
        'firstname': firstname.text,
        'lastname': lastname.text,
        'nickname': nickname.text,
        'phone': phone.text,
      });
      var data = json.decode(response.body);
      print(data.toString());

      for (var map in data) {
        UserModel userModel = UserModel.fromJson(map);
        print(userModel.userNickname);
        user(userModel);
      }

      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? userid = preferences.getString('user_id');
      print(userid);

      if (data == "Error") {
        Navigator.pushNamed(context, 'register');
      } else {
        await User.setlogin(true);
        Navigator.pushNamed(context, 'homenew');
      }
    }

    if (file != null) {
      Random random = Random();
      int i = random.nextInt(100000);
      String nameImage = 'post$i.jpg';

      String url = '${MyConstant().domain}/dogservice/api/userfile.php';

      Map<String, dynamic> map = Map();
      map['file'] =
          await MultipartFile.fromFile(file!.path, filename: nameImage);

      FormData formData = FormData.fromMap(map);
      await Dio().post(url, data: formData).then((value) async {
        String urlPathImage =
            '${MyConstant().domain}/dogservice/api/userimg/$nameImage';
        print('Response => $urlPathImage');

        SharedPreferences preferences = await SharedPreferences.getInstance();
        String? userid = preferences.getString('user_id');
        print(userid);

        String urlImage = '/dogservice/api/userimg/$nameImage';
        String url = "${MyConstant().domain}/dogservice/registerImg";
        final response = await http.post(Uri.parse(url), body: {
          'email': email.text,
          'password': password.text,
          'firstname': firstname.text,
          'lastname': lastname.text,
          'nickname': nickname.text,
          'phone': phone.text,
          'image': urlImage,
        });
        var data = json.decode(response.body);

        if (data == "Error") {
          Navigator.pushNamed(context, 'register');
        } else {
          await User.setlogin(true);
          Navigator.pushNamed(context, 'homenew');
        }
      });
    }
  }

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
      child: file == null
          ? Image.asset(
              'assets/img/logo cir.png',
              height: 80,
            )
          : Image.file(
              file!,
              height: 80,
            ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Form(
          key: formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  //Image.asset('assets/img/logo.png'),
                  Text(
                    "สมัครสมาชิก",
                    style: GoogleFonts.sarabun(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFFF7544),
                    ),
                  ),
                  Container(
                    child: showImage(),
                    padding: EdgeInsets.all(10),
                  ),
                  SizedBox(
                    width: 140,
                    height: 30,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          primary: Color(0xFFFF7544),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                      onPressed: () => chooseImage(ImageSource.gallery),
                      icon: FaIcon(
                        FontAwesomeIcons.solidSquarePlus,
                        size: 18,
                        color: Colors.white,
                      ),
                      label: Text(
                        'เพิ่มรูปโปรไฟล์',
                        style: GoogleFonts.sarabun(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   width: 30,
                  //   height: 30,
                  //   child: TextButton(
                  //     onPressed: () => chooseImage(ImageSource.gallery),
                  //     child: FaIcon(
                  //       FontAwesomeIcons.solidImage,
                  //       size: 22,
                  //       color: Color(0xFFFF7544),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 350,
                    height: 50,
                    child: TextFormField(
                      //controller: username,
                      decoration: InputDecoration(
                        labelText: "ชื่อ",
                        labelStyle: GoogleFonts.sarabun(),
                        prefixIcon: Icon(Icons.people),
                        border: myinputborder(),
                        enabledBorder: myinputborder(),
                        focusedBorder: myfocusborder(),
                      ),

                      controller: firstname,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  SizedBox(
                    width: 350,
                    height: 50,
                    child: TextFormField(
                      //controller: username,
                      decoration: InputDecoration(
                        labelText: "นามสกุล",
                        labelStyle: GoogleFonts.sarabun(),
                        prefixIcon: Icon(Icons.people),
                        border: myinputborder(),
                        enabledBorder: myinputborder(),
                        focusedBorder: myfocusborder(),
                      ),

                      controller: lastname,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  SizedBox(
                    width: 350,
                    height: 50,
                    child: TextFormField(
                      //controller: username,
                      decoration: InputDecoration(
                        labelText: "ชื่อเล่น (ใช้เป็นชื่อโปรไฟล์)",
                        labelStyle: GoogleFonts.sarabun(),
                        prefixIcon: Icon(Icons.people),
                        border: myinputborder(),
                        enabledBorder: myinputborder(),
                        focusedBorder: myfocusborder(),
                      ),

                      controller: nickname,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  SizedBox(
                    width: 350,
                    height: 50,
                    child: TextFormField(
                      //controller: username,
                      decoration: InputDecoration(
                        labelText: "เบอร์โทร",
                        labelStyle: GoogleFonts.sarabun(),
                        prefixIcon: Icon(Icons.phone),
                        border: myinputborder(),
                        enabledBorder: myinputborder(),
                        focusedBorder: myfocusborder(),
                      ),

                      controller: phone,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  SizedBox(
                    width: 350,
                    height: 50,
                    child: TextFormField(
                      //controller: username,
                      decoration: InputDecoration(
                        labelText: "อีเมล",
                        labelStyle: GoogleFonts.sarabun(),
                        prefixIcon: Icon(Icons.email),
                        border: myinputborder(),
                        enabledBorder: myinputborder(),
                        focusedBorder: myfocusborder(),
                      ),

                      controller: email,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 350,
                    height: 50,
                    child: TextFormField(
                      obscureText: true,
                      //controller: username,
                      decoration: InputDecoration(
                        labelText: "รหัสผ่าน",
                        labelStyle: GoogleFonts.sarabun(),
                        prefixIcon: Icon(Icons.lock),
                        border: myinputborder(),
                        enabledBorder: myinputborder(),
                        focusedBorder: myfocusborder(),
                      ),

                      controller: password,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  SizedBox(
                    width: 350,
                    height: 50,
                    child: TextFormField(
                      obscureText: true,
                      //controller: username,
                      decoration: InputDecoration(
                        labelText: "ยืนยันรหัสผ่าน",
                        labelStyle: GoogleFonts.sarabun(),
                        prefixIcon: Icon(Icons.lock),
                        border: myinputborder(),
                        enabledBorder: myinputborder(),
                        focusedBorder: myfocusborder(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  SizedBox(
                    width: 350,
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Color(0xFFFF7544),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                      onPressed: () {
                        if (email.text.isEmpty ||
                            password.text.isEmpty ||
                            firstname.text.isEmpty ||
                            lastname.text.isEmpty ||
                            nickname.text.isEmpty ||
                            phone.text.isEmpty) {
                          normalDialog(context, 'กรุณากรอกให้ครบทุกช่อง!');
                        } else {
                          sign_up();
                        }
                      },
                      child: Text(
                        'สมัครสมาชิก',
                        style: GoogleFonts.sarabun(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 15),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, 'login');
                    },
                    child: Text(
                      "มีบัญชีแล้ว? เข้าสู่ระบบ",
                      style: GoogleFonts.sarabun(
                        color: Color(0xFFFF7544),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  OutlineInputBorder myinputborder() {
    //return type is OutlineInputBorder
    return OutlineInputBorder(
        //Outline border type for TextFeild
        borderRadius: BorderRadius.all(Radius.circular(30)),
        borderSide: BorderSide(
          color: Color(0xFFFF7544),
          width: 2,
        ));
  }

  OutlineInputBorder myfocusborder() {
    return OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        borderSide: BorderSide(
          color: Color(0xFFFF7544),
          width: 2,
        ));
  }
}
