import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_ta/petugas/petugas_edit_profil_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'edit_profil_page.dart';
import '../auth/login_page.dart';

class PetugasAkunPage extends StatelessWidget {
  const PetugasAkunPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Akun Saya",
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(padding: EdgeInsets.all(16)),
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                      'https://i.pinimg.com/736x/8a/e9/e9/8ae9e92fa4e69967aa61bf2bda967b7b.jpg',
                    ),
                  ),
                  SizedBox(height: 8),

                  //username
                  Text(
                    "username",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),

                  //email
                  Text(
                    "email@email.com",
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),

                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PetugasEditProfilPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade300,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text("Edit Akun"),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            //menu menu
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildMenuItem(Icons.settings, "Pengaturan"),
                  _buildMenuItem(Icons.mail_outline, "Notifikasi"),
                  _buildMenuItem(Icons.logout, "Logout", iconColor: Colors.red),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //widget builder
  Widget _buildMenuItem(
    IconData icon,
    String title, {
    Color? iconColor,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.greenAccent.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListTile(
          leading: Icon(icon, color: iconColor ?? Colors.green.shade900),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green.shade900,
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.green.shade900,
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
