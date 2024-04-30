import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lovely_dog/model/dog_model.dart';
import 'package:lovely_dog/model/userpost_model.dart';
import 'package:lovely_dog/model/vaccine_model.dart';
import 'package:lovely_dog/schedulepage/dogschedule.dart';
import 'package:lovely_dog/user.dart';
import 'package:lovely_dog/vaccine.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:like_button/like_button.dart';

import 'model/dogsched_model.dart';
import 'model/user_model.dart';
import 'model/userpostbyid_model.dart';
import 'model/vaccinesched_model.dart';
import 'utility/my_constant.dart';

/// Flutter code sample for [NavigationBar].

class homenew extends StatefulWidget {
  const homenew({super.key});

  @override
  State<homenew> createState() => _homenewState();
}

class _homenewState extends State<homenew> {
  int currentPageIndex = 0;
  List<UserPostModel>? userPostModels;
  List<UserPostModel>? post;

  List<UserPostByIdModel>? userPostByIdModels;
  List<UserPostByIdModel>? postById;

  List<DogModel>? dogModels;
  List<DogModel>? dog;

  List<DogSchedule>? dogSched;

  List<VaccineModel>? vaccineModel;
  List<VaccineSchedModel>? vaccineSchedModel;

  UserModel? userModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPost();
    getUser();
    getPostById();
    getDogById();
    refresh();
  }

  Future<void> refresh() {
    setState(() {
      getPost();
      getUser();
      getPostById();
      getDogById();
    });
    return Future.delayed(Duration(seconds: 1));
  }

  Future<Null> getPost() async {
    String url = '${MyConstant().domain}/dogservice/getPost';
    Response response = await Dio().get(url);
    //print('res => $response');
    var result = jsonDecode(response.data);
    //print('result => $result');

    post = (jsonDecode(response.data) as List)
        .map((data) => UserPostModel.fromJson(data))
        .toList();

    // for (var map in result) {
    //   UserPostModel userPostModel = UserPostModel.fromJson(map);
    //   userPostModels?.add(userPostModel);
    //   print(userPostModels?[map].postText);
    //   print(userPostModel.postId);
    // }
  }

  Widget showPost() {
    return showListPost();
  }

//-------------------------------Show Post All---------------------------------
  Widget showListPost() => post?.length == 0
      ? Container(
          height: 500,
          child: Text(
            "ยังไม่มีโพสต์",
            style: GoogleFonts.sarabun(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color(0xFFFF7544),
            ),
          ))
      : ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: post?.length,
          itemBuilder: (context, index) => Container(
                color: Colors.white,
                margin: EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            '${post![index].userImg}' != ''
                                ? Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                '${MyConstant().domain}${post![index].userImg}'),
                                            fit: BoxFit.cover)),
                                  )
                                : Container(
                                    width: 50,
                                    height: 50,
                                    child:
                                        Image.asset('assets/img/logo cir.png')),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '${post![index].userNickname}',
                                  style: GoogleFonts.sarabun(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  '${post![index].postDate}',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                ),
                              ],
                            )
                          ],
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.more_horiz,
                            size: 20,
                            color: Colors.grey[600],
                          ),
                          onPressed: () {},
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '${post![index].postText}',
                      style: GoogleFonts.sarabun(
                        fontSize: 14,
                        color: Colors.grey[800],
                        height: 1.5,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    '${post![index].postImg}' != ''
                        ? Container(
                            height: 220,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    image: NetworkImage(
                                        '${MyConstant().domain}${post![index].postImg}'),
                                    fit: BoxFit.cover)),
                          )
                        : Container(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        makeLikeButton(isActive: false),
                        makeCommentButton(),
                      ],
                    ),
                    Container(
                      height: 1,
                      width: 420,
                      color: Colors.grey.shade300,
                    ),
                  ],
                ),
              ));

  Future<Null> getPostById() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? userid = preferences.getString('user_id');

    String url = '${MyConstant().domain}/dogservice/getPost/${userid}';
    Response response = await Dio().get(url);
    //print('res => $response');
    var result = jsonDecode(response.data);
    print('resultPostById => $result');

    postById = (jsonDecode(response.data) as List)
        .map((data) => UserPostByIdModel.fromJson(data))
        .toList();

    // for (var map in result) {
    //   UserPostModel userPostModel = UserPostModel.fromJson(map);
    //   userPostModels?.add(userPostModel);
    //   print(userPostModels?[map].postText);
    //   print(userPostModel.postId);
    // }
  }

  Widget showPostById() {
    return showListPostById();
  }

  Widget showListPostById() => postById?.length == 0
      ? Container(
          height: 500,
          child: Text(
            "ยังไม่มีโพสต์",
            style: GoogleFonts.sarabun(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFFFF7544),
            ),
          ))
      : ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: postById?.length,
          itemBuilder: (context, index) => Container(
                child: makeFeed(
                    userName: '${postById![index].userNickname}',
                    userImage:
                        '${MyConstant().domain}${postById![index].userImg}',
                    feedTime: '${postById![index].postDate}',
                    feedText: '${postById![index].postText}',
                    feedImage: '${MyConstant().domain}${post![index].postImg}',
                    feedLike: '${postById![index].postLike.toString()}'),
              ));

  Future<Null> getUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? userid = preferences.getString('user_id');

    String url = '${MyConstant().domain}/dogservice/getUser/$userid';
    await Dio().get(url).then((value) {
      //print('res => $response');
      var result = jsonDecode(value.data);
      print('result => $result');

      for (var map in result) {
        userModel = UserModel.fromJson(map);
        print(userModel?.userNickname);
      }
    });

    // user = (jsonDecode(response.data) as List)
    //     .map((data) => UserModel.fromJson(data))
    //     .toList();
  }

  Future<Null> getDogById() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? userid = preferences.getString('user_id');

    String url = '${MyConstant().domain}/dogservice/getDog/${userid}';
    Response response = await Dio().get(url);
    //print('res => $response');
    var result = jsonDecode(response.data);
    print('resultDogById => $result');

    dog = (jsonDecode(response.data) as List)
        .map((data) => DogModel.fromJson(data))
        .toList();
    print('DogLength => ${dog!.length}');

    // for (var map in result) {
    //   UserPostModel userPostModel = UserPostModel.fromJson(map);
    //   userPostModels?.add(userPostModel);
    //   print(userPostModels?[map].postText);
    //   print(userPostModel.postId);
    // }
  }

  Widget showDogById() {
    return showListDogById();
  }

  Widget showListDogById() => ListView.builder(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemCount: dog?.length,
      itemBuilder: (context, index) => Container(
            margin: EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Color(0xFFFF7544),
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
                          dog![index].dogImg != ''
                              ? Container(
                                  margin: EdgeInsets.all(10),
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              '${MyConstant().domain}${dog![index].dogImg}'),
                                          fit: BoxFit.cover)),
                                )
                              : Container(
                                  margin: EdgeInsets.all(10),
                                  width: 30,
                                  height: 30,
                                  child:
                                      Image.asset('assets/img/logo cir.png')),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '${dog![index].dogName}',
                                style: GoogleFonts.sarabun(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                            ],
                          )
                        ],
                      ),
                      IconButton(
                        icon: FaIcon(
                          FontAwesomeIcons.barsStaggered,
                          size: 18,
                        ),
                        color: Colors.white,
                        onPressed: () async {
                          // MaterialPageRoute route = MaterialPageRoute(
                          //     builder: (context) => dogschedule(
                          //           dogModel: dog![index],
                          //           dogSched: dogSched,
                          //         ));
                          // Navigator.push(context, route);
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          ));

  Widget showDogSched() {
    return showListDogSched();
  }

  Widget showListDogSched() => ListView.builder(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemCount: dog?.length,
      itemBuilder: (context, index) => Container(
            margin: EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Color(0xFFFF7544),
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
                          dog![index].dogImg != ''
                              ? Container(
                                  margin: EdgeInsets.all(10),
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              '${MyConstant().domain}${dog![index].dogImg}'),
                                          fit: BoxFit.cover)),
                                )
                              : Container(
                                  margin: EdgeInsets.all(10),
                                  width: 50,
                                  height: 50,
                                  child:
                                      Image.asset('assets/img/logo cir.png')),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '${dog![index].dogName}',
                                style: GoogleFonts.sarabun(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(
                                height: 3,
                              ),
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
                              '${MyConstant().domain}/dogservice/getSched/${dog![index].dogId}';
                          Response response = await Dio().get(url);
                          //print('res => $response');

                          dogSched = (jsonDecode(response.data) as List)
                              .map((data) => DogSchedule.fromJson(data))
                              .toList();
                          print('ActivityLength => ${dogSched!.length}');

                          String urlgetVac =
                              '${MyConstant().domain}/dogservice/getVaccineSched/${dog![index].dogId}';
                          Response responsegetVac = await Dio().get(urlgetVac);
                          //print('res => $response');

                          vaccineSchedModel = (jsonDecode(responsegetVac.data)
                                  as List)
                              .map((data) => VaccineSchedModel.fromJson(data))
                              .toList();
                          print(vaccineSchedModel!.length);

                          MaterialPageRoute route = MaterialPageRoute(
                              builder: (context) => dogschedule(
                                    dogModel: dog![index],
                                    dogSched: dogSched,
                                    vaccineSchedModel: vaccineSchedModel,
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

  @override
  Future logout() async {
    await User.setlogin(false);
    Navigator.pushNamed(context, 'login');
  }

  Drawer showDrawer() => Drawer(
        child: ListView(
          children: <Widget>[
            showHeadDrawer(),
            ListTile(
              leading: FaIcon(
                FontAwesomeIcons.syringe,
                //color: Color(0xFFFF7544),
              ),
              title: Text(
                'คู่มือการฉีดวัคซีน',
                style: TextStyle(
                  //color: Color(0xFFFF7544),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () async {
                String url = '${MyConstant().domain}/dogservice/getVaccine';
                Response response = await Dio().get(url);
                //print('res => $response');
                var result = jsonDecode(response.data);

                vaccineModel = (jsonDecode(response.data) as List)
                    .map((data) => VaccineModel.fromJson(data))
                    .toList();
                MaterialPageRoute route = MaterialPageRoute(
                    builder: (value) => vaccine(
                          vaccineModel: vaccineModel,
                        ));
                Navigator.push(context, route);
              },
            ),
            ListTile(
              leading: FaIcon(
                FontAwesomeIcons.arrowRightFromBracket,
                color: Color(0xFFFF7544),
              ),
              title: Text(
                'ออกจากระบบ',
                style: TextStyle(
                  color: Color(0xFFFF7544),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () async {
                showDialog(
                    context: context,
                    builder: (context) => SimpleDialog(
                          title: Text(
                            'คุณต้องกาออกจากระบบจริงหรือไม่',
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
                                      logout();
                                    },
                                    child: Text(
                                      'ตกลง',
                                      style:
                                          TextStyle(color: Color(0xFFFF7544)),
                                    )),
                              ],
                            )
                          ],
                        ));
              },
            ),
          ],
        ),
      );

  UserAccountsDrawerHeader showHeadDrawer() {
    return UserAccountsDrawerHeader(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/img/dog_group3.jpg'),
                fit: BoxFit.cover)),
        accountName: Text(
          'Lovely Dog Diary',
          style: TextStyle(fontSize: 18),
        ),
        accountEmail: Text('สมุดบันทึกน้องหมาสุดรัก'));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: showDrawer(),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFFFF7544),
        centerTitle: true,
        // leading: IconButton(
        //     onPressed: () {},
        //     icon: const FaIcon(FontAwesomeIcons.barsStaggered)),
        title: Image.asset(
          'assets/img/logo.png',
          width: 45,
          height: 45,
        ),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => SimpleDialog(
                          title: Text(
                            'คุณต้องกาออกจากระบบจริงหรือไม่',
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
                                      logout();
                                    },
                                    child: Text(
                                      'ตกลง',
                                      style:
                                          TextStyle(color: Color(0xFFFF7544)),
                                    )),
                              ],
                            )
                          ],
                        ));
              },
              icon: const FaIcon(
                FontAwesomeIcons.arrowRightFromBracket,
                size: 20,
              ))
        ],
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Color(0xFFFF7544),
        backgroundColor: Colors.white,
        selectedIndex: currentPageIndex,
        height: 70,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: FaIcon(
              FontAwesomeIcons.house,
              size: 22,
              color: Colors.white,
            ),
            icon: FaIcon(
              FontAwesomeIcons.house,
              size: 22,
              color: Colors.grey,
            ),
            label: 'หน้าหลัก',
          ),
          NavigationDestination(
            selectedIcon: FaIcon(
              FontAwesomeIcons.users,
              size: 22,
              color: Colors.white,
            ),
            icon: FaIcon(
              FontAwesomeIcons.users,
              size: 22,
              color: Colors.grey,
            ),
            label: 'ชุมชน',
          ),
          NavigationDestination(
            selectedIcon: FaIcon(
              FontAwesomeIcons.solidCalendarDays,
              size: 22,
              color: Colors.white,
            ),
            icon: FaIcon(
              FontAwesomeIcons.solidCalendarDays,
              size: 22,
              color: Colors.grey,
            ),
            label: 'กำหนดการ',
          ),
          NavigationDestination(
            selectedIcon: FaIcon(
              FontAwesomeIcons.solidUser,
              size: 22,
              color: Colors.white,
            ),
            icon: FaIcon(
              FontAwesomeIcons.solidUser,
              size: 22,
              color: Colors.grey,
            ),
            label: 'บัญชี',
          ),
        ],
      ),
      body: <Widget>[
        Container(
          //หน้าแรก
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: 380,
                          height: 40,
                          child: TextFormField(
                              //controller: username,
                              decoration: InputDecoration(
                            labelText: "ค้นหา",
                            labelStyle: GoogleFonts.sarabun(),
                            prefixIcon: Icon(Icons.search),
                            filled: true, //<-- SEE HERE
                            fillColor: Colors.white,
                            border: myinputborder(),
                            enabledBorder: myinputborder(),
                            focusedBorder: myfocusborder(),
                          )),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                            child: Text(
                          'ยังไม่มีโพสต์',
                          style:
                              TextStyle(fontSize: 16, color: Color(0xFFFF7544)),
                        ))
                        // makeFeed(
                        //     userName: 'Lovely Dog Diary',
                        //     userImage: 'assets/img/logo cir.png',
                        //     feedTime: '1 hr ago',
                        //     feedText:
                        //         'องค์การอนามัยโลก หรือดับเบิลยูเอชโอ เผยมีการตรวจพบสุนัขติดเชื้อฝีดาษวานรจากเจ้าของเป็นกรณีแรกของโลกกรณีสุนัขติดเชื้อฝีดาษวานรจากมนุษย์ ทำให้ผู้เชี่ยวชาญด้านสาธารณสุขแนะนำว่า หากเจ้าของติดเชื้อฝีดาษวานร ให้แยกกักตัวและอยู่ให้ห่างสุนัขของตนองค์การอนามัยโลกยังเตือนว่า ควรจัดการกับขยะอย่างระมัดระวัง เพื่อหลีกเลี่ยงความเสี่ยงทำให้สัตว์ตัวอื่น ๆ ติดเชื้ออย่างไรก็ดี ยังไม่มีหลักฐานว่า สุนัขสามารถแพร่เชื้อฝีดาษวานรไปยังสุนัขตัวอื่น หรือมนุษย์ ได้หรือไม่',
                        //     feedImage: 'assets/img/dog1.png',
                        //     feedLike: ''),
                        // new Container(
                        //   height: 1,
                        //   width: 420,
                        //   color: Colors.grey,
                        // ),
                        // SizedBox(
                        //   height: 10,
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          child: RefreshIndicator(
            onRefresh: refresh,
            //ชุมชน
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            width: 130,
                            height: 40,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  primary: Color(0xFFFF7544),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15))),
                              onPressed: () {
                                Navigator.pushNamed(context, 'createpost')
                                    .then((value) => getPost())
                                    .then((value) => refresh());
                              },
                              icon: FaIcon(
                                FontAwesomeIcons.solidPenToSquare,
                                size: 22,
                                color: Colors.white,
                              ),
                              label: Text(
                                'เขียนโพสต์',
                                style: GoogleFonts.sarabun(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          showPost(),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          //กำหนดการ
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              dog?.length == 0
                  ? Center(
                      child: Text(
                      "ยังไม่มีน้องหมา",
                      style: GoogleFonts.sarabun(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFFF7544),
                      ),
                    ))
                  : Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Padding(
                          padding: EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                width: 380,
                                height: 40,
                                child: TextFormField(
                                    //controller: username,
                                    decoration: InputDecoration(
                                  labelText: "ค้นหา",
                                  labelStyle: GoogleFonts.sarabun(),
                                  prefixIcon: Icon(Icons.search),
                                  filled: true, //<-- SEE HERE
                                  fillColor: Colors.white,
                                  border: myinputborder(),
                                  enabledBorder: myinputborder(),
                                  focusedBorder: myfocusborder(),
                                )),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              showDogSched(),
                            ],
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
        Container(
          child: RefreshIndicator(
            onRefresh: refresh,
            //บัญชี
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                      child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(children: <Widget>[
                        Container(
                          width: 220,
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Color(0xFFFF7544),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              '${userModel?.userImg}' != ''
                                  ? Container(
                                      margin: EdgeInsets.all(10),
                                      width: 300,
                                      height: 100,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  '${MyConstant().domain}${userModel?.userImg}'),
                                              fit: BoxFit.contain)),
                                    )
                                  : Container(
                                      margin: EdgeInsets.all(10),
                                      width: 300,
                                      height: 100,
                                      child: Image.asset(
                                          'assets/img/logo cir.png')),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    '${userModel?.userNickname}',
                                    style: GoogleFonts.sarabun(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    width: 160,
                                    height: 30,
                                    child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                          elevation: 0,
                                          primary: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15))),
                                      onPressed: () {
                                        //Navigator.pushNamed(context, 'createpost');
                                      },
                                      icon: FaIcon(
                                        FontAwesomeIcons.pen,
                                        size: 18,
                                        color: Color(0xFFFF7544),
                                      ),
                                      label: Text(
                                        'แก้ไขข้อมูลส่วนตัว',
                                        style: GoogleFonts.sarabun(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFFFF7544),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 13,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 130,
                          height: 30,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                elevation: 0,
                                primary: Color(0xFFFF7544),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15))),
                            onPressed: () {
                              Navigator.pushNamed(context, 'adddog')
                                  .then((value) => getDogById())
                                  .then((value) => refresh());
                            },
                            icon: FaIcon(
                              FontAwesomeIcons.solidSquarePlus,
                              size: 18,
                              color: Colors.white,
                            ),
                            label: Text(
                              'เพิ่มน้องหมา',
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
                        showDogById(),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 1,
                          width: 420,
                          color: Colors.grey.shade300,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "โพสตของฉัน",
                          style: GoogleFonts.sarabun(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFFF7544)),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        showPostById(),
                      ]),
                    ),
                  )),
                ],
              ),
            ),
          ),
        ),
      ][currentPageIndex],
    );
  }

  Widget makeListDog({dogName, dogImage}) {
    return Container(
      margin: EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: Color(0xFFFF7544),
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
                    dogImage != '${MyConstant().domain}'
                        ? Container(
                            margin: EdgeInsets.all(10),
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: NetworkImage(dogImage),
                                    fit: BoxFit.cover)),
                          )
                        : Container(
                            margin: EdgeInsets.all(10),
                            width: 50,
                            height: 50,
                            child: Image.asset('assets/img/logo cir.png')),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          dogName,
                          style: GoogleFonts.sarabun(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: 3,
                        ),
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
                    Navigator.pushNamed(context, 'dogschedule');
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
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

Widget makeFeed(
    {userName, userImage, feedTime, feedText, feedImage, feedLike}) {
  return Container(
    color: Colors.white,
    margin: EdgeInsets.only(bottom: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                userImage != '${MyConstant().domain}'
                    ? Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: NetworkImage(userImage),
                                fit: BoxFit.cover)),
                      )
                    : Container(
                        width: 50,
                        height: 50,
                        child: Image.asset('assets/img/logo cir.png')),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      userName,
                      style: GoogleFonts.sarabun(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      feedTime,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                )
              ],
            ),
            IconButton(
              icon: Icon(
                Icons.more_horiz,
                size: 30,
                color: Colors.grey[600],
              ),
              onPressed: () {},
            )
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          feedText,
          style: GoogleFonts.sarabun(
            fontSize: 14,
            color: Colors.grey[800],
            height: 1.5,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        feedImage != '${MyConstant().domain}'
            ? Container(
                height: 220,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        image: NetworkImage(feedImage), fit: BoxFit.cover)),
              )
            : Container(),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            makeLikeButton(isActive: false),
            makeCommentButton(),
          ],
        ),
        Container(
          height: 1,
          width: 420,
          color: Colors.grey.shade300,
        ),
      ],
    ),
  );
}

Widget makeLike() {
  return Container(
    width: 25,
    height: 25,
    decoration: BoxDecoration(
        color: Colors.blue,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white)),
    child: Center(
      child: Icon(Icons.thumb_up, size: 12, color: Colors.white),
    ),
  );
}

Widget makeLove() {
  return Container(
    width: 25,
    height: 25,
    decoration: BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white)),
    child: Center(
      child: Icon(Icons.favorite, size: 12, color: Colors.white),
    ),
  );
}

// Widget makeLikeButton({isActive}) {
//   return Container(
//     padding: EdgeInsets.symmetric(horizontal: 60, vertical: 5),
//     decoration: BoxDecoration(
//       border: Border.all(color: Colors.grey),
//       borderRadius: BorderRadius.circular(50),
//     ),
//     child: Center(
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           Icon(
//             Icons.thumb_up,
//             color: isActive ? Colors.blue : Colors.grey,
//             size: 18,
//           ),
//           SizedBox(
//             width: 5,
//           ),
//           Text(
//             "ถูกใจ",
//             style: TextStyle(color: isActive ? Colors.blue : Colors.grey),
//           )
//         ],
//       ),
//     ),
//   );
// }

Widget makeLikeButton({isActive}) {
  return LikeButton(
    size: 24,
    likeCount: 0,
    likeCountPadding: EdgeInsets.only(left: 10),
  );
}

Widget makeCommentButton() {
  return Row(children: <Widget>[
    IconButton(
      icon: FaIcon(
        FontAwesomeIcons.solidComment,
        size: 20,
      ),
      color: Colors.grey,
      onPressed: () {},
    ),
    Text(
      '0',
      style: TextStyle(color: Colors.grey),
    )
  ]);
}
