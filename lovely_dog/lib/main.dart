import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_custom.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:intl/intl.dart';
import 'package:lovely_dog/check_login.dart';
import 'package:lovely_dog/firebase_options.dart';
//import 'package:lovely_dog/home.dart';
import 'package:lovely_dog/schedulepage/dogschedule.dart';
import 'commupage/createpost.dart';
import 'homenew.dart';
import 'login.dart';
import 'profilepage/adddog.dart';
import 'register.dart';
import 'schedulepage/addactivity.dart';
import 'utility/color.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: GoogleFonts.sarabun().fontFamily,
        primarySwatch: Colors.brown,
      ),
      home: check_login(),
      routes: {
        'register': (context) => register(),
        //'home': (context) => homepage(),
        'login': (context) => login(),
        'homenew': (context) => homenew(),
        'createpost': (context) => createpost(),
        'adddog': (context) => adddog(),
        //'dogschedule': (context) => dogschedule(),
        //'addactivity': (context) => addactivity()
      },
    );
  }
}
