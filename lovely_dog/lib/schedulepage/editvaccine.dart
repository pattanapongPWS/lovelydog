// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'dart:io';
import 'dart:math';

import 'package:age_calculator/age_calculator.dart';
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
import 'package:lovely_dog/model/vaccinesched_model.dart';
import 'package:lovely_dog/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/dog_model.dart';
import '../model/vaccine_model.dart';
import '../utility/my_constant.dart';
import '../utility/normalDialog.dart';
import '../vaccinedetail.dart';

extension TimeOfDayConverter on TimeOfDay {
  String to24hours() {
    final hour = this.hour.toString().padLeft(2, "0");
    final min = this.minute.toString().padLeft(2, "0");
    return "$hour:$min";
  }
}

class editvaccine extends StatefulWidget {
  final DogModel? dogModel;
  final List<VaccineModel>? vaccineModel;
  final VaccineSchedModel? vaccineSchedModel;
  const editvaccine(
      {Key? key,
      required this.dogModel,
      required this.vaccineModel,
      required this.vaccineSchedModel})
      : super(key: key);

  @override
  State<editvaccine> createState() => _editvaccineState();
}

class _editvaccineState extends State<editvaccine> {
  @override
  final formKey = GlobalKey<FormState>();

  TextEditingController name = TextEditingController();
  TextEditingController detail = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController time = TextEditingController();

  String? datetime;
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  DogModel? dogModel;
  List<VaccineModel>? vaccineModel;
  VaccineSchedModel? vaccineSchedModel;

  var datee;
  var month;
  var year;
  String? age;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dogModel = widget.dogModel;
    vaccineModel = widget.vaccineModel;
    vaccineSchedModel = widget.vaccineSchedModel;

    DateTime dogBirth =
        DateTime.parse(dogModel!.dogBirth!.toString() + ' 00:00:00');
    datee = DateFormat.d().format(dogBirth);
    month = DateFormat.M().format(dogBirth);
    year = DateFormat.y().format(dogBirth);
    print(datee);
    print(month);
    print(year);
    DateTime birthday =
        DateTime(int.parse(year), int.parse(month), int.parse(datee));

    DateDuration duration;

    // Find out your age as of today's date 2021-03-08
    duration = AgeCalculator.age(birthday);
    print('Your age is ${duration}');

    age = '${duration.years} ปี ${duration.months} เดือน ${duration.days} วัน';

    var inputFormat = DateFormat('dd/MM/yyyy');
    var inputDate =
        inputFormat.parse(vaccineSchedModel!.vacschedDate!.toString());

    var outputFormat = DateFormat('yyyy-MM-dd');
    var outputDate = outputFormat.format(inputDate);
    print(outputDate);

    name.text = vaccineSchedModel!.vacschedName!;
    detail.text = vaccineSchedModel!.vacschedDetail!;
    date.text = outputDate;
    time.text = vaccineSchedModel!.vacschedTime!;
  }

  Widget showVaccineSched() {
    return showListVaccine();
  }

  Widget showListVaccine() => ListView.builder(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemCount: vaccineModel?.length,
      itemBuilder: (context, index) => InkWell(
          onTap: () {
            setState(() {
              name.text = vaccineModel![index].vacName!;
              detail.text = vaccineModel![index].vacDetail!;
            });
          },
          child: Container(
            margin: EdgeInsets.only(top: 6, left: 8, right: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Color(0xFFA35B33),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(top: 10, left: 15),
                                child: Text(
                                  '${vaccineModel![index].vacName}',
                                  style: GoogleFonts.sarabun(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 15, left: 15),
                                child: Text(
                                  'อายุน้องหมา : ${vaccineModel![index].vacAge} เดือน',
                                  style: GoogleFonts.sarabun(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      IconButton(
                        icon: FaIcon(
                          FontAwesomeIcons.barsStaggered,
                          size: 20,
                        ),
                        color: Colors.white,
                        onPressed: () {
                          MaterialPageRoute route = MaterialPageRoute(
                              builder: (context) => vaccinedetail(
                                    vaccineModel: vaccineModel![index],
                                  ));
                          Navigator.push(context, route);
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          )));

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
                'คุณต้องกาลบการฉีดวัคซีนจริงหรือไม่',
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
                          deleteVaccine();
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

  Future<Null> deleteVaccine() async {
    String url = '${MyConstant().domain}/dogservice/deleteVaccine';
    final response = await http.post(Uri.parse(url),
        body: {'vacschedid': vaccineSchedModel?.vacschedId.toString()});

    Navigator.pop(context);
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
          if (name.text == "" || detail.text == "") {
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
                          editVaccine();
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

  Future<Null> editVaccine() async {
    String url = "${MyConstant().domain}/dogservice/editVaccine";
    final response = await http.post(Uri.parse(url), body: {
      'vacschedid': vaccineSchedModel?.vacschedId.toString(),
      'name': name.text,
      'detail': detail.text,
      'date': date.text,
      'time': time.text,
    });
    Navigator.pop(context);
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
          "เพิ่มการฉีดวัคซีนของ${dogModel?.dogName}",
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
            physics: AlwaysScrollableScrollPhysics(),
            children: [
              Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'อายุของ${dogModel?.dogName}: $age',
                    style: TextStyle(
                      fontSize: 16,
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
                        labelText: "ชื่อวัคซีน",
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      deleteButton(),
                      SizedBox(
                        width: 10,
                      ),
                      editButton()
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'เลือกจากคู่มือการฉีดวัคซีน',
                    style: TextStyle(fontSize: 16, color: Color(0xFFFF7544)),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  showListVaccine(),
                  SizedBox(
                    height: 10,
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
