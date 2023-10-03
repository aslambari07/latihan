// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:latihan/firebase_options.dart';
import 'package:latihan/view/biodata.dart';
import 'package:latihan/view/login.dart';
// import 'package:latihan/view/register.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Login(),
    // home: Register(),
    // home: BiodataForm(),
    // home: MyHomePage(),
  ));
}
