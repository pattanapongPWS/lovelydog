// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:lovely_dog/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'user.dart';
import 'utility/my_constant.dart';
import 'utility/normalDialog.dart';

class login extends StatefulWidget {
  const login({Key? key}) : super(key: key);

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  @override
  final formKey = GlobalKey<FormState>();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  Future login() async {
    String url = "${MyConstant().domain}/dogservice/login";
    final response = await http.post(Uri.parse(url), body: {
      'email': email.text,
      'password': password.text,
    });
    var data = json.decode(response.body);
    print(data.toString());

    if (data.toString() == "{success: false, error: Incorrect password}" ||
        data.toString() == "{success: false, error: Email not found}") {
      normalDialog(context, 'อีเมลหรือรหัสผ่านไม่ถูกต้อง!');
    } else {
      for (var map in data) {
        UserModel userModel = UserModel.fromJson(map);
        print(userModel.userNickname);
        user(userModel);
      }
      SharedPreferences preferences = await SharedPreferences.getInstance();
      print(preferences.getString('user_id').toString());

      await User.setlogin(true);
      Navigator.pushNamed(context, 'homenew');
    }
  }

  Future<Null> user(UserModel userModel) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('user_id', userModel.userId.toString());
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
                    height: 10,
                  ),
                  Image.asset(
                    'assets/img/logo.png',
                    width: 300,
                    height: 300,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "เข้าสู่ระบบ",
                    style: GoogleFonts.sarabun(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFFF7544),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 350,
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
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'โปรดใส่ข้อมูล';
                        }
                        return null;
                      },
                      controller: email,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 350,
                    child: TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "รหัสผ่าน",
                        labelStyle: GoogleFonts.sarabun(),
                        prefixIcon: Icon(Icons.lock),
                        border: myinputborder(),
                        enabledBorder: myinputborder(),
                        focusedBorder: myfocusborder(),
                      ),
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'โปรดใส่ข้อมูล';
                        }
                        return null;
                      },
                      controller: password,
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
                        bool pass = formKey.currentState!.validate();
                        if (pass) {
                          login();
                        }
                      },
                      child: Text(
                        'เข้าสู่ระบบ',
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
                      Navigator.pushNamed(context, 'register');
                    },
                    child: Text(
                      "ยังไม่มีบัญชี? สมัครสมาชิก",
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
