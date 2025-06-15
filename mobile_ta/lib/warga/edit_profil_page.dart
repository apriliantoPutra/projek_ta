import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mobile_ta/constants/constants.dart';
import 'package:mobile_ta/widget/warga_main_widget.dart';
import 'package:path/path.dart' as Path;
import 'package:shared_preferences/shared_preferences.dart';

class WargaEditProfilPage extends StatefulWidget {
  final Map<String, dynamic>? profilData;
  const WargaEditProfilPage({Key? key, this.profilData})
    : super(key: key);

  @override
  State<WargaEditProfilPage> createState() => _WargaEditProfilPageState();
}

class _WargaEditProfilPageState extends State<WargaEditProfilPage> {
  late TextEditingController _namaController;
  late TextEditingController _telponController;
  late TextEditingController _alamatController;
  late TextEditingController _koordinatController;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(
      text: widget.profilData?['nama_pengguna'] ?? '',
    );
    _telponController = TextEditingController(
      text: widget.profilData?['no_hp_pengguna'] ?? '',
    );
    _alamatController = TextEditingController(
      text: widget.profilData?['alamat_pengguna'] ?? '',
    );
    _koordinatController = TextEditingController(
      text: widget.profilData?['koordinat_pengguna'] ?? '',
    );
  }

  File? _profileImage;
  bool _isLoading = false;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source, imageQuality: 75);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            alignment: WrapAlignment.center,
            children: [
              Text(
                "Pilih Foto Profil",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text("Dari Galeri"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Dari Kamera"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _submitForm() async {
    setState(() => _isLoading = true);

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      var uri = Uri.parse('$baseUrl/profil');
      var request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = 'Bearer $token';

      request.fields['nama_pengguna'] = _namaController.text;
      request.fields['alamat_pengguna'] = _alamatController.text;
      request.fields['no_hp_pengguna'] = _telponController.text;
      request.fields['koordinat_pengguna'] = _koordinatController.text;
      request.fields['_method'] = 'PUT';

      if (_profileImage != null) {
        var stream = http.ByteStream(_profileImage!.openRead());
        var length = await _profileImage!.length();
        var multipartFile = http.MultipartFile(
          'gambar_pengguna',
          stream,
          length,
          filename: Path.basename(_profileImage!.path),
        );
        request.files.add(multipartFile);
      }

      var response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profil berhasil diedit'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => WargaMainWrapper()),
            (Route<dynamic> route) => false,
          );
        }
      } else {
        final resData = await response.stream.bytesToString();
        final json = jsonDecode(resData);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(json['message'] ?? 'Gagal edit profil'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent.shade400,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit Profil',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.white),
            onPressed: _isLoading ? null : _submitForm,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: _showImagePickerOptions,
              child: Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage:
                          _profileImage != null
                              ? FileImage(_profileImage!)
                              : NetworkImage(
                                    (widget.profilData?['gambar_pengguna'] ??
                                                '')
                                            .isNotEmpty
                                        ? widget.profilData!['gambar_url']
                                        : 'https://i.pinimg.com/736x/8a/e9/e9/8ae9e92fa4e69967aa61bf2bda967b7b.jpg',
                                  )
                                  as ImageProvider,
                    ),
                    const CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.edit, color: Colors.green),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Form Data
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.greenAccent.shade400,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField("Nama Lengkap", _namaController),
                  _buildTextField("Telpon", _telponController),
                  _buildTextField("Alamat", _alamatController),
                  _buildTextField("Titik Koordinat", _koordinatController),
                  const SizedBox(height: 12),

                  // Peta (Dummy)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      "https://i.pinimg.com/736x/b0/79/09/b079096855c0edbaba47d93c67f18853.jpg",
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

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
