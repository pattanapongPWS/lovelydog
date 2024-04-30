import 'package:shared_preferences/shared_preferences.dart';

class User {
  static Future<bool?> getlogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool("Login");
  }

  static Future setlogin(bool login) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setBool("Login", login);
  }
}
