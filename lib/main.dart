import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:audio_app/pages/login_page.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔥 IMPORTANT
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}