import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'user.dart';
import 'utility/my_constant.dart';
import 'package:http/http.dart' as http;

class check_login extends StatefulWidget {
  const check_login({Key? key}) : super(key: key);

  @override
  State<check_login> createState() => _check_loginState();
}

class _check_loginState extends State<check_login> {
  Future checklogin() async {
    bool? login = await User.getlogin();
    print(login);

    if (login == false) {
      Navigator.pushNamed(context, 'login');
    } else {
      Navigator.pushNamed(context, 'homenew');

      String? token = await FirebaseMessaging.instance.getToken();
      print('Token => $token');

      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? idLogin = preferences.getString('user_id');
      print('ID Login => $idLogin');

      String url = '${MyConstant().domain}/dogservice/editToken';
      final response = await http.post(Uri.parse(url), body: {
        'userid': idLogin,
        'token': token
      }).then((value) => print('Update Token Success'));
    }
  }

  void initState() {
    checklogin();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
