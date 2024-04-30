// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'user.dart';

class homepage extends StatefulWidget {
  const homepage({Key? key}) : super(key: key);

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  @override
  Widget build(BuildContext context) {
    List<Widget> _buildScreens() {
      return [
        const Screen1(),
        const Screen2(),
        const Screen3(),
        const Screen4(),
      ];
    }

    List<PersistentBottomNavBarItem> _navBarsItems() {
      return [
        PersistentBottomNavBarItem(
          icon: const FaIcon(FontAwesomeIcons.house, size: 22),
          title: ("หน้าหลัก"),
          activeColorPrimary: Color(0xFFFF7544),
          activeColorSecondary: Colors.white,
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: const FaIcon(FontAwesomeIcons.users, size: 22),
          title: ("ชุมชน"),
          activeColorPrimary: Color(0xFFFF7544),
          activeColorSecondary: Colors.white,
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: const FaIcon(FontAwesomeIcons.solidCalendarDays, size: 22),
          title: ("กำหนดการ"),
          activeColorPrimary: Color(0xFFFF7544),
          activeColorSecondary: Colors.white,
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: const FaIcon(FontAwesomeIcons.solidUser, size: 22),
          title: ("บัญชี"),
          activeColorPrimary: Color(0xFFFF7544),
          activeColorSecondary: Colors.white,
          inactiveColorPrimary: Colors.grey,
        ),
      ];
    }

    PersistentTabController controller;

    controller = PersistentTabController(initialIndex: 0);
    return PersistentTabView(
      context,
      screens: _buildScreens(),
      items: _navBarsItems(),
      controller: controller,
      confineInSafeArea: true,
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties(
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        animateTabTransition: false,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style7,
      navBarHeight: 60,
    );
  }
}

class Screen1 extends StatelessWidget {
  const Screen1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFF7544),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {},
            icon: const FaIcon(FontAwesomeIcons.barsStaggered)),
        title: Image.asset(
          'assets/img/logo.png',
          width: 45,
          height: 45,
        ),
        actions: [
          IconButton(
              onPressed: () {}, icon: const FaIcon(FontAwesomeIcons.solidBell))
        ],
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: 380,
                      height: 40,
                      child: TextField(
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
                    makeFeed(
                        userName: 'Lovely Dog Diary',
                        userImage: 'assets/img/logo cir.png',
                        feedTime: '1 hr ago',
                        feedText:
                            'องค์การอนามัยโลก หรือดับเบิลยูเอชโอ เผยมีการตรวจพบสุนัขติดเชื้อฝีดาษวานรจากเจ้าของเป็นกรณีแรกของโลกกรณีสุนัขติดเชื้อฝีดาษวานรจากมนุษย์ ทำให้ผู้เชี่ยวชาญด้านสาธารณสุขแนะนำว่า หากเจ้าของติดเชื้อฝีดาษวานร ให้แยกกักตัวและอยู่ให้ห่างสุนัขของตนองค์การอนามัยโลกยังเตือนว่า ควรจัดการกับขยะอย่างระมัดระวัง เพื่อหลีกเลี่ยงความเสี่ยงทำให้สัตว์ตัวอื่น ๆ ติดเชื้ออย่างไรก็ดี ยังไม่มีหลักฐานว่า สุนัขสามารถแพร่เชื้อฝีดาษวานรไปยังสุนัขตัวอื่น หรือมนุษย์ ได้หรือไม่',
                        feedImage: 'assets/img/dog1.png'),
                    new Container(
                      height: 1,
                      width: 420,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    makeFeed(
                        userName: 'lovely Dog Diary',
                        userImage: 'assets/img/logo cir.png',
                        feedTime: '3 mins ago',
                        feedText:
                            "All the Lorem Ipsum generators on the Internet tend to repeat predefined.All the Lorem Ipsum generators on the Internet tend to repeat predefined.All the Lorem Ipsum generators on the Internet tend to repeat predefined.",
                        feedImage: ''),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Screen2 extends StatelessWidget {
  const Screen2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFF7544),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {},
            icon: const FaIcon(FontAwesomeIcons.barsStaggered)),
        title: Image.asset(
          'assets/img/logo.png',
          width: 45,
          height: 45,
        ),
        actions: [
          IconButton(
              onPressed: () {}, icon: const FaIcon(FontAwesomeIcons.solidBell))
        ],
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: 380,
                      height: 40,
                      child: TextField(
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
                    makeFeed(
                        userName: 'Lovely Dog Diary',
                        userImage: 'assets/img/logo cir.png',
                        feedTime: '1 hr ago',
                        feedText:
                            'องค์การอนามัยโลก หรือดับเบิลยูเอชโอ เผยมีการตรวจพบสุนัขติดเชื้อฝีดาษวานรจากเจ้าของเป็นกรณีแรกของโลกกรณีสุนัขติดเชื้อฝีดาษวานรจากมนุษย์ ทำให้ผู้เชี่ยวชาญด้านสาธารณสุขแนะนำว่า หากเจ้าของติดเชื้อฝีดาษวานร ให้แยกกักตัวและอยู่ให้ห่างสุนัขของตนองค์การอนามัยโลกยังเตือนว่า ควรจัดการกับขยะอย่างระมัดระวัง เพื่อหลีกเลี่ยงความเสี่ยงทำให้สัตว์ตัวอื่น ๆ ติดเชื้ออย่างไรก็ดี ยังไม่มีหลักฐานว่า สุนัขสามารถแพร่เชื้อฝีดาษวานรไปยังสุนัขตัวอื่น หรือมนุษย์ ได้หรือไม่',
                        feedImage: 'assets/img/dog1.png'),
                    new Container(
                      height: 1,
                      width: 420,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    makeFeed(
                        userName: 'lovely Dog Diary',
                        userImage: 'assets/img/logo cir.png',
                        feedTime: '3 mins ago',
                        feedText:
                            "All the Lorem Ipsum generators on the Internet tend to repeat predefined.All the Lorem Ipsum generators on the Internet tend to repeat predefined.All the Lorem Ipsum generators on the Internet tend to repeat predefined.",
                        feedImage: ''),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class Screen3 extends StatelessWidget {
  const Screen3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFF7544),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {},
            icon: const FaIcon(FontAwesomeIcons.barsStaggered)),
        title: Image.asset(
          'assets/img/logo.png',
          width: 45,
          height: 45,
        ),
        actions: [
          IconButton(
              onPressed: () {}, icon: const FaIcon(FontAwesomeIcons.solidBell))
        ],
      ),
      body: const Center(
        child: Text(
          'Screen3',
          style: TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}

class Screen4 extends StatelessWidget {
  const Screen4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFF7544),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {},
            icon: const FaIcon(FontAwesomeIcons.barsStaggered)),
        title: Image.asset(
          'assets/img/logo.png',
          width: 45,
          height: 45,
        ),
        actions: [
          IconButton(
              onPressed: () {}, icon: const FaIcon(FontAwesomeIcons.solidBell))
        ],
      ),
      body: Center(
        child: Form(
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
                  SizedBox(
                    width: 350,
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Color(0xFFFF7544),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                      onPressed: () {
                        Future logout() async {
                          await User.setlogin(false);
                          Navigator.pushNamed(context, 'login');
                        }

                        logout();
                      },
                      child: Text(
                        'ออกจากระบบ',
                        style: GoogleFonts.sarabun(
                          fontSize: 20,
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

Widget makeFeed({userName, userImage, feedTime, feedText, feedImage}) {
  return Container(
    margin: EdgeInsets.only(bottom: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage(userImage), fit: BoxFit.cover)),
                ),
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
                          letterSpacing: 1),
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
              letterSpacing: .7),
        ),
        SizedBox(
          height: 10,
        ),
        feedImage != ''
            ? Container(
                height: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        image: AssetImage(feedImage), fit: BoxFit.cover)),
              )
            : Container(),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                makeLike(),
                Transform.translate(offset: Offset(-5, 0), child: makeLove()),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "2.5K",
                  style: TextStyle(fontSize: 15, color: Colors.grey[800]),
                )
              ],
            ),
            Text(
              "400 Comments",
              style: TextStyle(fontSize: 13, color: Colors.grey[800]),
            )
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            makeLikeButton(isActive: false),
            makeCommentButton(),
            makeShareButton(),
          ],
        )
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

Widget makeLikeButton({isActive}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(50),
    ),
    child: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.thumb_up,
            color: isActive ? Colors.blue : Colors.grey,
            size: 18,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            "Like",
            style: TextStyle(color: isActive ? Colors.blue : Colors.grey),
          )
        ],
      ),
    ),
  );
}

Widget makeCommentButton() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(50),
    ),
    child: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.chat, color: Colors.grey, size: 18),
          SizedBox(
            width: 5,
          ),
          Text(
            "Comment",
            style: TextStyle(color: Colors.grey),
          )
        ],
      ),
    ),
  );
}

Widget makeShareButton() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(50),
    ),
    child: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.share, color: Colors.grey, size: 18),
          SizedBox(
            width: 5,
          ),
          Text(
            "Share",
            style: TextStyle(color: Colors.grey),
          )
        ],
      ),
    ),
  );
}
