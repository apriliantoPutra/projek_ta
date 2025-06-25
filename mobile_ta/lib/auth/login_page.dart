import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mobile_ta/auth/register_page.dart';
import 'package:mobile_ta/widget/petugas_main_widget.dart';
import 'package:mobile_ta/widget/warga_main_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> login() async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.post(
      Uri.parse('$baseUrl/authenticate'),
      body: {
        'username': _usernameController.text,
        'password': _passwordController.text,
      },
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final role = responseData['data']['role'];
      final token = responseData['token'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      if (role == 'warga') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => WargaMainWrapper()),
        );
      } else if (role == 'petugas') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => PetugasMainWrapper()),
        );
      } else {
        _showError('Role tidak dikenali.');
      }
    } else {
      final responseData = json.decode(response.body);
      _showError(responseData['message'] ?? 'Gagal login');
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('Login Gagal'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xff8fd14f),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Center(
              child: Image.asset(
                'assets/logo_bank_sampah.png', // letakkan logo di folder assets
                height: 120,
              ),
            ),
          ),
          SizedBox(height: 40),
          Text(
            "Login",
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            "Selamat datang di aplikasi Bank Sampah\nMohon masukkan username dan password",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[700]),
          ),
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    hintText: "Username",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  ),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isLoading ? null : login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff8fd14f),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    minimumSize: Size(double.infinity, 45),
                  ),
                  child:
                      _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                            "Log in",
                            style: TextStyle(color: Colors.white),
                          ),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    // Navigasi ke halaman register
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterPage(),
                      ),
                    );
                  },
                  child: Text.rich(
                    TextSpan(
                      text: "Belum punya akun? ",
                      children: [
                        TextSpan(
                          text: "Daftar",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
