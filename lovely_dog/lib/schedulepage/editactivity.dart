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
import 'package:lovely_dog/model/dogsched_model.dart';
import 'package:lovely_dog/user.dart';
import 'package:lovely_dog/utility/normalDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/dog_model.dart';
import '../utility/my_constant.dart';

extension TimeOfDayConverter on TimeOfDay {
  String to24hours() {
    final hour = this.hour.toString().padLeft(2, "0");
    final min = this.minute.toString().padLeft(2, "0");
    return "$hour:$min";
  }
}

class editactivity extends StatefulWidget {
  final DogSchedule dogSched;
  const editactivity({Key? key, required this.dogSched}) : super(key: key);

  @override
  State<editactivity> createState() => _editactivityState();
}

class _editactivityState extends State<editactivity> {
  @override
  final formKey = GlobalKey<FormState>();

  File? file;
  final List<String> actItems = [
    'ทั่วไป',
  ];
  TextEditingController name = TextEditingController();
  String? type;
  TextEditingController detail = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController time = TextEditingController();

  String? datetime;
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  DogSchedule? dogSched;

  @override
  void initState() {
    dogSched = widget.dogSched;

    var inputFormat = DateFormat('dd/MM/yyyy');
    var inputDate = inputFormat.parse(dogSched!.actDate!.toString());

    var outputFormat = DateFormat('yyyy-MM-dd');
    var outputDate = outputFormat.format(inputDate);
    print(outputDate);

    name.text = dogSched!.actName!;
    type = dogSched!.actType;
    detail.text = dogSched!.actDetail!;
    date.text = outputDate;
    time.text = dogSched!.actTime!;
    print(name.text);
    // TODO: implement initState
    super.initState();
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
          ? dogSched?.actImg == ""
              ? Image.asset(
                  'assets/img/logo cir.png',
                  height: 100,
                )
              : Image.network('${MyConstant().domain}${dogSched?.actImg}')
          : Image.file(
              file!,
              height: 100,
            ),
    );
  }

  SizedBox deleteButton() {
    return SizedBox(
      width: 165,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: 0,
            primary: Color.fromARGB(255, 255, 68, 68),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15))),
        onPressed: () {
          comfirmDelete();
        },
        child: Text(
          'ลบ',
          style: GoogleFonts.sarabun(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Future<Null> comfirmDelete() async {
    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              title: Text(
                'คุณต้องกาลบกิจกรรมจริงหรือไม่',
                style: TextStyle(fontSize: 16),
              ),
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'ยกเลิก',
                          style: TextStyle(color: Colors.black),
                        )),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          deleteActivity();
                        },
                        child: Text(
                          'ตกลง',
                          style: TextStyle(color: Color(0xFFFF7544)),
                        )),
                  ],
                )
              ],
            ));
  }

  Future<Null> deleteActivity() async {
    String actid = dogSched!.actId.toString();
    print(actid);

    String url = '${MyConstant().domain}/dogservice/deleteActivity';
    final response = await http
        .post(Uri.parse(url), body: {'actid': dogSched?.actId.toString()});
    Navigator.pop(context);
    var data = json.decode(response.body);
    print(data);
  }

  SizedBox editButton() {
    return SizedBox(
      width: 165,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: 0,
            primary: Color(0xFFFF7544),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15))),
        onPressed: () {
          if (name.text == "" || type!.isEmpty) {
            normalDialog(context, 'กรุณากรอกชื่อกิจกรรม!');
          } else {
            comfirmEdit();
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

  Future<Null> comfirmEdit() async {
    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              title: Text(
                'คุณต้องการแก้ไขกิจกรรมจริงหรือไม่',
                style: TextStyle(fontSize: 16),
              ),
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'ยกเลิก',
                          style: TextStyle(color: Colors.black),
                        )),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          editActivity();
                        },
                        child: Text(
                          'ตกลง',
                          style: TextStyle(color: Color(0xFFFF7544)),
                        )),
                  ],
                )
              ],
            ));
  }

  Future<Null> editActivity() async {
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
        String url = "${MyConstant().domain}/dogservice/editActivityImg";
        final response = await http.post(Uri.parse(url), body: {
          'actid': dogSched?.actId.toString(),
          'name': name.text,
          'type': type,
          'detail': detail.text,
          'date': date.text,
          'time': time.text + ':00',
          'image': urlImage,
        });

        Navigator.pop(context);
      });
    }

    if (file == null) {
      var url = '${MyConstant().domain}/dogservice/editActivity';
      print(url);
      print(dogSched?.actId.toString());
      print(name.text);
      print(type);
      print(detail.text);
      print(date.text);
      print(time.text + ':00');
      final response = await http.post(Uri.parse(url), body: {
        'actid': dogSched?.actId.toString(),
        'name': name.text,
        'type': type,
        'detail': detail.text,
        'date': date.text,
        'time': time.text + ':00',
      });

      Navigator.pop(context);
    }
  }

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
          "ข้อมูลกิจกรรม",
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
                  actImg(),
                  SizedBox(
                    height: 20,
                  ),
                  actName(),
                  SizedBox(
                    height: 10,
                  ),
                  actType(),
                  SizedBox(
                    height: 10,
                  ),
                  actDetail(),
                  SizedBox(
                    height: 10,
                  ),
                  actDate(),
                  SizedBox(
                    height: 10,
                  ),
                  actTime(),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      deleteButton(),
                      SizedBox(
                        width: 10,
                      ),
                      editButton()
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget actImg() => Column(
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
        ],
      );

  Widget actName() => Column(
        children: <Widget>[
          SizedBox(
            width: 350,
            height: 50,
            child: TextFormField(
              //initialValue: name,
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
        ],
      );

  Widget actType() => Column(
        children: <Widget>[
          SizedBox(
            width: 350,
            height: 50,
            child: DropdownButtonFormField2<String>(
              value: type,
              isExpanded: true,
              decoration: InputDecoration(
                labelStyle: GoogleFonts.sarabun(),

                contentPadding: EdgeInsets.symmetric(vertical: 12),
                border: myinputborder(),
                enabledBorder: myinputborder(),
                focusedBorder: myfocusborder(),
                // Add more decoration..
              ),
              // hint: Text(
              //   'ประเภท',
              //   style: GoogleFonts.sarabun(),
              // ),
              items: actItems
                  .map((String item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      ))
                  .toList(),
              onChanged: (String? value) {
                setState(() {
                  type = value!;
                });
              },
            ),
          ),
        ],
      );

  Widget actDetail() => Column(
        children: <Widget>[
          SizedBox(
            width: 350,
            child: TextFormField(
              //initialValue: detail,
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
        ],
      );

  Widget actDate() => Column(
        children: <Widget>[
          SizedBox(
            width: 350,
            height: 50,
            child: TextFormField(
              //initialValue: date,
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
        ],
      );

  Widget actTime() => Column(
        children: <Widget>[
          SizedBox(
            width: 350,
            height: 50,
            child: TextFormField(
              //initialValue: time,
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
                    //datetime = date + ' ' + time + ':00';
                    print(datetime);
                  });
                } else {
                  print("Date is not selected");
                }
              },
              controller: time,
            ),
          ),
        ],
      );

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
}
