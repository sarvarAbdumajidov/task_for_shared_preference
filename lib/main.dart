import 'package:flutter/material.dart';
import 'package:task_for_shared_preference/pages/login_page.dart';
import 'package:task_for_shared_preference/pages/sign_up_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: LoginPage.id,
      routes: {
        LoginPage.id: (context) => LoginPage(),
        SignUpPage.id: (context) => SignUpPage()
      },
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
