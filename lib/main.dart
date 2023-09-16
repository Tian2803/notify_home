import 'package:flutter/material.dart';
import 'package:notify_home/controllers/controller_login.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notify hogar',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: const Color.fromARGB(255, 37, 43, 214),
      )),
      home: LoginController(),
    );
  }
}