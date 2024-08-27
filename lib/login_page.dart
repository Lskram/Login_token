import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // เพิ่ม import นี้สำหรับการจัดการ JSON

class LoginPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void loginUser(BuildContext context) async {
    var response = await http.post(
      Uri.parse('https://wallet-api-7m1z.onrender.com/auth/login'),
      body: {
        'username': usernameController.text,
        'password': passwordController.text,
      },
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body); // แปลง String เป็น Map
      String token = jsonResponse['token'];

      // Save token to shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', token);
      print('Login successful');

      // นำทางไปที่หน้า User Information
      Navigator.pushNamed(context, '/user_info');
    } else {
      print('Login failed: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => loginUser(context),
              child: Text('Login'),
            ),
            SizedBox(height: 20),
            // เพิ่มปุ่มลิงก์ไปที่หน้า Sign Up
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
              child: Text('Don\'t have an account? Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
