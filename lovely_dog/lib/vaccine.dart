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
import 'package:lovely_dog/model/vaccine_model.dart';
import 'package:lovely_dog/user.dart';
import 'package:lovely_dog/vaccinedetail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utility/my_constant.dart';

class vaccine extends StatefulWidget {
  final List<VaccineModel>? vaccineModel;
  const vaccine({Key? key, required this.vaccineModel}) : super(key: key);

  @override
  State<vaccine> createState() => _vaccineState();
}

class _vaccineState extends State<vaccine> {
  @override
  final formKey = GlobalKey<FormState>();

  File? file;
  TextEditingController text = TextEditingController();
  List<VaccineModel>? vaccineModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    vaccineModel = widget.vaccineModel;
  }

  Widget showVaccineSched() {
    return showListVaccine();
  }

  Widget showListVaccine() => ListView.builder(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemCount: vaccineModel?.length,
      itemBuilder: (context, index) => Container(
            margin: EdgeInsets.only(top: 6, left: 8, right: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Color.fromARGB(255, 255, 68, 68),
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
          ));

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
            "คู่มือการฉีดวัคซีน",
            style: GoogleFonts.sarabun(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 5,
              ),
              showVaccineSched(),
            ],
          ), // This trailing comma makes auto-formatting nicer for build methods.
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
