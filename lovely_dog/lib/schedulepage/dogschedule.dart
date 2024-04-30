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
import 'package:lovely_dog/model/dog_model.dart';
import 'package:lovely_dog/model/dogsched_model.dart';
import 'package:lovely_dog/model/vaccinesched_model.dart';
import 'package:lovely_dog/schedulepage/addactivity.dart';
import 'package:lovely_dog/schedulepage/editactivity.dart';
import 'package:lovely_dog/schedulepage/editvaccine.dart';
import 'package:lovely_dog/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/user_model.dart';
import '../model/userpost_model.dart';
import '../model/vaccine_model.dart';
import '../utility/my_constant.dart';
import 'addvaccine.dart';

class dogschedule extends StatefulWidget {
  final DogModel dogModel;
  final List<DogSchedule>? dogSched;
  final List<VaccineSchedModel>? vaccineSchedModel;

  const dogschedule(
      {Key? key,
      required this.dogModel,
      required this.dogSched,
      required this.vaccineSchedModel})
      : super(key: key);

  @override
  State<dogschedule> createState() => _dogscheduleState();
}

class _dogscheduleState extends State<dogschedule> {
  File? file;

  @override
  final formKey = GlobalKey<FormState>();

  TextEditingController text = TextEditingController();

  DogModel? dogModel;
  List<DogSchedule>? dogSched;

  List<VaccineModel>? vaccineModel;
  List<VaccineSchedModel>? vaccineSchedModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dogModel = widget.dogModel;
    dogSched = widget.dogSched;
    vaccineSchedModel = widget.vaccineSchedModel;
    getDogSched();
    showDogSched();
    getVaccineSched();
    showVaccineSched();
    getVaccine();
    refresh();
  }

  Future<void> refresh() {
    setState(() {
      getDogSched();
      showDogSched();
      getVaccineSched();
      showVaccineSched();
    });
    return Future.delayed(Duration(seconds: 1));
  }

  Future<Null> getVaccine() async {
    String url = '${MyConstant().domain}/dogservice/getVaccine';
    Response response = await Dio().get(url);
    //print('res => $response');
    var result = jsonDecode(response.data);

    vaccineModel = (jsonDecode(response.data) as List)
        .map((data) => VaccineModel.fromJson(data))
        .toList();
  }

  Future<Null> getVaccineSched() async {
    var dogid = dogModel?.dogId.toString();
    String url = '${MyConstant().domain}/dogservice/getVaccineSched/$dogid';
    Response response = await Dio().get(url);
    //print('res => $response');
    var result = jsonDecode(response.data);

    vaccineSchedModel = (jsonDecode(response.data) as List)
        .map((data) => VaccineSchedModel.fromJson(data))
        .toList();
  }

  Widget showVaccineSched() {
    return showListVaccineSched();
  }

  Widget showListVaccineSched() => vaccineSchedModel!.length == 0
      ? Center(
          child: Text(
          "ยังไม่มีกำหนดการฉีดวัคซีน",
          style: GoogleFonts.sarabun(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color(0xFFFF7544)),
        ))
      : ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: vaccineSchedModel?.length,
          itemBuilder: (context, index) => Container(
                margin: EdgeInsets.all(2),
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
                                      '${vaccineSchedModel![index].vacschedName}',
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
                                    margin:
                                        EdgeInsets.only(bottom: 15, left: 15),
                                    child: Text(
                                      '${vaccineSchedModel![index].vacschedDate} | ${vaccineSchedModel![index].vacschedTime}',
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
                            onPressed: () async {
                              String url =
                                  '${MyConstant().domain}/dogservice/getVaccine';
                              Response response = await Dio().get(url);
                              //print('res => $response');
                              var result = jsonDecode(response.data);

                              vaccineModel = (jsonDecode(response.data) as List)
                                  .map((data) => VaccineModel.fromJson(data))
                                  .toList();
                              MaterialPageRoute route = MaterialPageRoute(
                                  builder: (context) => editvaccine(
                                        dogModel: dogModel,
                                        vaccineModel: vaccineModel,
                                        vaccineSchedModel:
                                            vaccineSchedModel![index],
                                      ));
                              Navigator.push(context, route)
                                  .then((value) => getVaccineSched())
                                  .then((value) => refresh());
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ));

  Future<Null> getDogSched() async {
    var dogid = dogModel?.dogId.toString();
    String url = '${MyConstant().domain}/dogservice/getSched/$dogid';
    Response response = await Dio().get(url);
    //print('res => $response');
    var result = jsonDecode(response.data);

    dogSched = (jsonDecode(response.data) as List)
        .map((data) => DogSchedule.fromJson(data))
        .toList();
  }

  Widget showDogSched() {
    return showListDogSched();
  }

  Widget showListDogSched() => dogSched!.length == 0
      ? Center(
          child: Text(
          "ยังไม่มีกิจกรรม",
          style: GoogleFonts.sarabun(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color(0xFFFF7544)),
        ))
      : ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: dogSched?.length,
          itemBuilder: (context, index) => Container(
                margin: EdgeInsets.all(2),
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
                                      '${dogSched![index].actName}',
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
                                    margin:
                                        EdgeInsets.only(bottom: 15, left: 15),
                                    child: Text(
                                      '${dogSched![index].actDate} | ${dogSched![index].actTime}',
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
                                  builder: (context) => editactivity(
                                        dogSched: dogSched![index],
                                      ));
                              Navigator.push(context, route)
                                  .then((value) => getDogSched())
                                  .then((value) => refresh());
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ));

  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
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
                "กำหนดการของ${dogModel?.dogName}",
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
            body: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Container(
                    height: 45,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25.0)),
                    child: TabBar(
                      indicator: BoxDecoration(
                          color: Color(0xFFFF7544),
                          borderRadius: BorderRadius.circular(25.0)),
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.black,
                      tabs: [
                        Tab(
                          child: Text(
                            'ทั่วไป',
                            style: GoogleFonts.sarabun(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'ฉีดวัคซีน',
                            style: GoogleFonts.sarabun(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'เสร็จสิ้น',
                            style: GoogleFonts.sarabun(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                      child: TabBarView(
                    children: [
                      //---------------------ทั้งหมด--------------------------
                      Center(
                        child: RefreshIndicator(
                          onRefresh: refresh,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                    child: SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: Column(
                                          children: <Widget>[
                                            SizedBox(
                                              height: 10,
                                            ),
                                            SizedBox(
                                              width: 130,
                                              height: 30,
                                              child: ElevatedButton.icon(
                                                style: ElevatedButton.styleFrom(
                                                    elevation: 0,
                                                    primary: Color(0xFFFF7544),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15))),
                                                onPressed: () {
                                                  MaterialPageRoute route =
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              addactivity(
                                                                dogModel:
                                                                    dogModel!,
                                                              ));
                                                  Navigator.push(context, route)
                                                      .then((value) =>
                                                          getDogSched())
                                                      .then(
                                                          (value) => refresh());
                                                },
                                                icon: FaIcon(
                                                  FontAwesomeIcons
                                                      .solidSquarePlus,
                                                  size: 18,
                                                  color: Colors.white,
                                                ),
                                                label: Text(
                                                  'เพิ่มกิจกรรม',
                                                  style: GoogleFonts.sarabun(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            showDogSched()
                                          ],
                                        ))),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: RefreshIndicator(
                          onRefresh: refresh,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                    child: SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: Column(
                                          children: <Widget>[
                                            SizedBox(
                                              height: 10,
                                            ),
                                            SizedBox(
                                              width: 150,
                                              height: 30,
                                              child: ElevatedButton.icon(
                                                style: ElevatedButton.styleFrom(
                                                    elevation: 0,
                                                    primary: Color(0xFFFF7544),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15))),
                                                onPressed: () async {
                                                  MaterialPageRoute route =
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              addvaccine(
                                                                dogModel:
                                                                    dogModel!,
                                                                vaccineModel:
                                                                    vaccineModel,
                                                              ));
                                                  Navigator.push(context, route)
                                                      .then((value) =>
                                                          getVaccineSched())
                                                      .then(
                                                          (value) => refresh());
                                                },
                                                icon: FaIcon(
                                                  FontAwesomeIcons
                                                      .solidSquarePlus,
                                                  size: 18,
                                                  color: Colors.white,
                                                ),
                                                label: Text(
                                                  'เพิ่มการฉีดวัคซีน',
                                                  style: GoogleFonts.sarabun(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            showVaccineSched()
                                          ],
                                        ))),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Text('เสร็จสิ้น'),
                      ),
                    ],
                  ))
                ],
              ),
            )

            // This trailing comma makes auto-formatting nicer for build methods.
            ));
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
