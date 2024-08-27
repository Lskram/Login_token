import 'package:flutter/material.dart';
import 'signup_page.dart';
import 'login_page.dart';
import 'user_info_page.dart';
import 'edit_profile_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
      routes: {
        '/signup': (context) => SignUpPage(),
        '/login': (context) => LoginPage(),
        '/user_info': (context) => UserInfoPage(),
        '/edit_profile': (context) => EditProfilePage(),
      },
    );
  }
}
