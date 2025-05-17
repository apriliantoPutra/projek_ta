import 'package:flutter/material.dart';

class WargaEditAkunPage extends StatelessWidget {
  const WargaEditAkunPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent.shade400,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Edit Profil',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.check, color: Colors.white),
            onPressed: () {
              // Simpan perubahan
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Foto Profil
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                  'https://i.pravatar.cc/300',
                ), // Ganti sesuai gambar profil
              ),
            ),
            SizedBox(height: 16),

            // Form Container
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.greenAccent.shade400,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField("Username"),
                  _buildTextField("Nama Lengkap"),
                  _buildTextField("Telpon"),
                  _buildTextField("Alamat"),
                  _buildTextField("Titik Koordinat"),
                  SizedBox(height: 12),

                  // Peta (Dummy Image)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      "https://i.pinimg.com/736x/b0/79/09/b079096855c0edbaba47d93c67f18853.jpg", // Peta dummy
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        TextField(
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        SizedBox(height: 12),
      ],
    );
  }
}
