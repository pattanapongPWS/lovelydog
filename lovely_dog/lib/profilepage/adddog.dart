// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lovely_dog/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utility/my_constant.dart';
import '../utility/normalDialog.dart';

class adddog extends StatefulWidget {
  const adddog({Key? key}) : super(key: key);

  @override
  State<adddog> createState() => _adddogState();
}

class _adddogState extends State<adddog> {
  @override
  final formKey = GlobalKey<FormState>();

  final List<String> genderItems = [
    'เพศผู้',
    'เพศเมีย',
  ];
  File? file;
  TextEditingController name = TextEditingController();
  String? gender;
  TextEditingController firstname = TextEditingController();
  TextEditingController gene = TextEditingController();
  TextEditingController weight = TextEditingController();
  TextEditingController birthdate = TextEditingController();

  String? date;

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
              height: 100,
            )
          : Image.file(
              file!,
              height: 100,
            ),
    );
  }

  SizedBox addButton() {
    return SizedBox(
      width: 350,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: Color(0xFFFF7544),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15))),
        onPressed: () {
          if (name.text == "" ||
              gender == null ||
              gene.text == "" ||
              weight.text == "" ||
              birthdate.text == "") {
            normalDialog(context, 'กรุณากรอกให้ครบทุกช่อง!');
          } else {
            uploadDog();
            Navigator.pop(context);
          }
        },
        child: Text(
          'บันทึก',
          style: GoogleFonts.sarabun(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Future<Null> uploadDog() async {
    if (file != null) {
      Random random = Random();
      int i = random.nextInt(100000);
      String nameImage = 'dog$i.jpg';

      String url = '${MyConstant().domain}/dogservice/api/dog.php';

      Map<String, dynamic> map = Map();
      map['file'] =
          await MultipartFile.fromFile(file!.path, filename: nameImage);

      FormData formData = FormData.fromMap(map);
      await Dio().post(url, data: formData).then((value) async {
        String urlPathImage =
            '${MyConstant().domain}/dogservice/api/dogimg/$nameImage';
        print('Response => $urlPathImage');

        SharedPreferences preferences = await SharedPreferences.getInstance();
        String? userid = preferences.getString('user_id');
        print(userid);

        String urlImage = '/dogservice/api/dogimg/$nameImage';
        String url = "${MyConstant().domain}/dogservice/adddogImg";
        final response = await http.post(Uri.parse(url), body: {
          'userid': userid,
          'name': name.text,
          'gender': gender,
          'gene': gene.text,
          'weight': weight.text,
          'birthdate': birthdate.text,
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

      String url = "${MyConstant().domain}/dogservice/adddog";

      final response = await http.post(Uri.parse(url), body: {
        'userid': userid,
        'name': name.text,
        'gender': gender,
        'gene': gene.text,
        'weight': weight.text,
        'birthdate': birthdate.text,
      });
      var data = json.decode(response.body);
      print(data);
    }
  }

  // @override
  // void initState() {
  //   birthdate.text = ""; //set the initial value of text field
  //   super.initState();
  // }

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
          "เพิ่มน้องหมา",
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
      body: Center(
        child: Form(
          key: formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: showImage(),
                  ),
                  SizedBox(
                    height: 20,
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
                        FontAwesomeIcons.solidImage,
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
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 350,
                    height: 50,
                    child: TextFormField(
                      //controller: username,
                      decoration: InputDecoration(
                        labelText: "ชื่อ",
                        labelStyle: GoogleFonts.sarabun(),
                        border: myinputborder(),
                        enabledBorder: myinputborder(),
                        focusedBorder: myfocusborder(),
                      ),

                      controller: name,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 350,
                    height: 50,
                    child: DropdownButtonFormField2<String>(
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelStyle: GoogleFonts.sarabun(),

                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                        border: myinputborder(),
                        enabledBorder: myinputborder(),
                        focusedBorder: myfocusborder(),
                        // Add more decoration..
                      ),
                      hint: Text(
                        'เพศ',
                        style: GoogleFonts.sarabun(
                            textStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500)),
                      ),
                      items: genderItems
                          .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: GoogleFonts.sarabun(
                                      textStyle: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey.shade800,
                                          fontWeight: FontWeight.w500)),
                                ),
                              ))
                          .toList(),
                      onChanged: (value) {
                        gender = value.toString();
                      },
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
                        labelText: "สายพันธุ์",
                        labelStyle: GoogleFonts.sarabun(),
                        border: myinputborder(),
                        enabledBorder: myinputborder(),
                        focusedBorder: myfocusborder(),
                      ),

                      controller: gene,
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
                        labelText: "น้ำหนัก",
                        labelStyle: GoogleFonts.sarabun(),
                        border: myinputborder(),
                        enabledBorder: myinputborder(),
                        focusedBorder: myfocusborder(),
                      ),

                      controller: weight,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 350,
                    height: 50,
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: "วันเกิด",
                        labelStyle: GoogleFonts.sarabun(),
                        suffixIcon: Icon(Icons.calendar_month),
                        border: myinputborder(),
                        enabledBorder: myinputborder(),
                        focusedBorder: myfocusborder(),
                      ),
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(
                                2000), //DateTime.now() - not to allow to choose before today.
                            lastDate: DateTime(2101));

                        if (pickedDate != null) {
                          print(
                              pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                          String formattedDate =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                          print(
                              formattedDate); //formatted date output using intl package =>  2021-03-16
                          //you can implement different kind of Date Format here according to your requirement
                          setState(() {
                            birthdate.text =
                                formattedDate; //set output date to TextField value.
                            date = formattedDate;
                          });
                        } else {
                          print("Date is not selected");
                        }
                      },
                      controller: birthdate,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  addButton(),
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
}
