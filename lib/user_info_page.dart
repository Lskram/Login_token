import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';

class UserInfoPage extends StatefulWidget {
  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  String token = '';
  String firstName = '';
  String lastName = '';
  int age = 0;
  DateTime? tokenGeneratedTime;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
    setState(() {
      tokenGeneratedTime = DateTime.now();
      firstName = prefs.getString('first_name') ?? '';
      lastName = prefs.getString('last_name') ?? '';
      age = prefs.getInt('age') ?? 0;
    });

    var response = await http.get(
      Uri.parse('https://wallet-api-7m1z.onrender.com/user/information'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var userInfo = jsonDecode(response.body);
      setState(() {
        firstName = userInfo['first_name'] ?? '';
        lastName = userInfo['last_name'] ?? '';
        age = userInfo['age'] ?? 0;
      });
    } else {
      throw Exception('Failed to load user info');
    }

    await _saveTokenToFile(token);
  }

  Future<void> _saveTokenToFile(String token) async {
    final directory =
        Directory('${Platform.environment['USERPROFILE']}\\Desktop');
    if (!directory.existsSync()) {
      directory.createSync();
    }
    final file = File('${directory.path}/token.txt');
    await file.writeAsString(token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Information')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Token: $token'),
            SizedBox(height: 10),
            Text('First Name: $firstName'),
            SizedBox(height: 10),
            Text('Last Name: $lastName'),
            SizedBox(height: 10),
            Text('Age: $age'),
            SizedBox(height: 10),
            Text('Token Generated At: ${tokenGeneratedTime.toString()}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final updatedInfo =
                    await Navigator.pushNamed(context, '/edit_profile');
                if (updatedInfo != null &&
                    updatedInfo is Map<String, dynamic>) {
                  setState(() {
                    firstName = updatedInfo['first_name'] ?? '';
                    lastName = updatedInfo['last_name'] ?? '';
                    age = updatedInfo['age'] ?? 0;
                  });
                }
              },
              child: Text('Edit Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
