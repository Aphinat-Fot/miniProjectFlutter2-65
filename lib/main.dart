//import 'dart:js';

import 'package:firstapp/database/addcomment.dart';
import 'package:firstapp/database/comment.dart';
import 'package:firstapp/login/changimage.dart';
import 'package:firstapp/login/changname.dart';
import 'package:firstapp/login/reset.dart';
import 'package:flutter/material.dart';
import 'package:firstapp/pages/homepage.dart';
import 'package:firstapp/login//login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firstapp/login//register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  //const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return buildMaterialApp();
  }

  MaterialApp buildMaterialApp() {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/homepage': (context) => HomePage(),
        '/changname': (context) => ChangName(),
        '/changimage': (context) => ChangImage(),
        '/reset': (context) => ResetPassword(),
      },
    );
  }
}
