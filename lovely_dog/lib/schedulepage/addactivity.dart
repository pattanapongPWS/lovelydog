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

import '../model/dog_model.dart';
import '../utility/my_constant.dart';
import '../utility/normalDialog.dart';

extension TimeOfDayConverter on TimeOfDay {
  String to24hours() {
    final hour = this.hour.toString().padLeft(2, "0");
    final min = this.minute.toString().padLeft(2, "0");
    return "$hour:$min";
  }
}

class addactivity extends StatefulWidget {
  final DogModel dogModel;
  const addactivity({Key? key, required this.dogModel}) : super(key: key);

  @override
  State<addactivity> createState() => _addactivityState();
}

class _addactivityState extends State<addactivity> {
  @override
  final formKey = GlobalKey<FormState>();

  File? file;
  final List<String> actItems = ['ทั่วไป'];
  TextEditingController name = TextEditingController();
  String? type;
  TextEditingController detail = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController time = TextEditingController();

  String? datetime;
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  DogModel? dogModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dogModel = widget.dogModel;
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
            elevation: 0,
            primary: Color(0xFFFF7544),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15))),
        onPressed: () {
          if (name.text == "" ||
              type == null ||
              detail.text == "" ||
              date.text == "" ||
              time.text == "") {
            normalDialog(context, 'กรุณากรอกให้ครบทุกช่อง!');
          } else {
            uploadActivity();
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

  Future<Null> uploadActivity() async {
    if (file != null) {
      Random random = Random();
      int i = random.nextInt(100000);
      String nameImage = 'activity$i.jpg';

      String url = '${MyConstant().domain}/dogservice/api/activity.php';

      Map<String, dynamic> map = Map();
      map['file'] =
          await MultipartFile.fromFile(file!.path, filename: nameImage);

      FormData formData = FormData.fromMap(map);
      await Dio().post(url, data: formData).then((value) async {
        String urlPathImage =
            '${MyConstant().domain}/dogservice/api/activityimg/$nameImage';
        print('Response => $urlPathImage');

        SharedPreferences preferences = await SharedPreferences.getInstance();
        String? userid = preferences.getString('user_id');
        print(userid);

        String urlImage = '/dogservice/api/activityimg/$nameImage';
        String url = "${MyConstant().domain}/dogservice/addActivityImg";
        final response = await http.post(Uri.parse(url), body: {
          'dogid': dogModel?.dogId.toString(),
          'name': name.text,
          'type': type,
          'detail': detail.text,
          'date': date.text,
          'time': time.text,
          'image': urlImage,
        });

        var data = json.decode(response.body);
        print(data);
      });
    }

    if (file == null) {
      String url = "${MyConstant().domain}/dogservice/addActivity";

      final response = await http.post(Uri.parse(url), body: {
        'dogid': dogModel?.dogId.toString(),
        'name': name.text,
        'type': type,
        'detail': detail.text,
        'date': date.text,
        'time': time.text,
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
          "เพิ่มกิจกรรมของ${dogModel?.dogName}",
          style: GoogleFonts.sarabun(
            fontSize: 18,
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
                        'เพิ่มรูปภาพ',
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
                        labelText: "ชื่อกิจกรรม",
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
                        'ประเภท',
                        style: GoogleFonts.sarabun(),
                      ),
                      items: actItems
                          .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: GoogleFonts.sarabun(),
                                ),
                              ))
                          .toList(),
                      onChanged: (value) {
                        type = value.toString();
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 350,
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      minLines: 2,
                      maxLines: 10,
                      decoration: InputDecoration(
                        labelText: "รายละเอียด",
                        labelStyle: GoogleFonts.sarabun(),
                        border: myinputborder(),
                        enabledBorder: myinputborder(),
                        focusedBorder: myfocusborder(),
                      ),
                      controller: detail,
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
                        labelText: "วันที่",
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
                            date.text =
                                formattedDate; //set output date to TextField value.
                          });
                        } else {
                          print("Date is not selected");
                        }
                      },
                      controller: date,
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
                        labelText: "เวลา",
                        labelStyle: GoogleFonts.sarabun(),
                        suffixIcon: Icon(Icons.access_time),
                        border: myinputborder(),
                        enabledBorder: myinputborder(),
                        focusedBorder: myfocusborder(),
                      ),
                      readOnly: true,
                      onTap: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: selectedTime,
                          builder: (BuildContext context, Widget? child) {
                            return MediaQuery(
                              data: MediaQuery.of(context)
                                  .copyWith(alwaysUse24HourFormat: true),
                              child: child ?? Container(),
                            );
                          },
                        );

                        if (pickedTime != null) {
                          print(pickedTime);

                          print(pickedTime.to24hours());
                          setState(() {
                            time.text = pickedTime.to24hours();
                            datetime = date.text + ' ' + time.text + ':00';
                            print(datetime);
                          });
                        } else {
                          print("Date is not selected");
                        }
                      },
                      controller: time,
                    ),
                  ),
                  SizedBox(
                    height: 10,
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
