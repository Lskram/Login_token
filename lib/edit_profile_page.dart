import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCurrentInfo();
  }

  Future<void> _loadCurrentInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    firstNameController.text = prefs.getString('first_name') ?? '';
    lastNameController.text = prefs.getString('last_name') ?? '';
    ageController.text = prefs.getInt('age')?.toString() ?? '0';
  }

  void _updateProfile(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    var response = await http.put(
      // ใช้ PUT หรือ PATCH หาก API รองรับ
      Uri.parse(
          'https://wallet-api-7m1z.onrender.com/user/update'), // URL ที่ถูกต้อง
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'first_name': firstNameController.text,
        'last_name': lastNameController.text,
        'age': int.parse(ageController.text),
      }),
    );

    if (response.statusCode == 200) {
      // บันทึกข้อมูลใหม่ลง SharedPreferences
      await prefs.setString('first_name', firstNameController.text);
      await prefs.setString('last_name', lastNameController.text);
      await prefs.setInt('age', int.parse(ageController.text));

      // แสดงผลข้อความว่าอัพเดตข้อมูลสำเร็จ
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Profile updated successfully'),
      ));

      // ส่งข้อมูลกลับไปที่ User Information Page
      Navigator.pop(context, {
        'first_name': firstNameController.text,
        'last_name': lastNameController.text,
        'age': int.parse(ageController.text),
      });
    } else {
      // แสดงผลข้อความว่าการอัพเดตข้อมูลล้มเหลว
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to update profile: ${response.body}'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Profile')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: firstNameController,
              decoration: InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: lastNameController,
              decoration: InputDecoration(labelText: 'Last Name'),
            ),
            TextField(
              controller: ageController,
              decoration: InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _updateProfile(context),
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
