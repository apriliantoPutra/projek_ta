import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mobile_ta/constants/constants.dart';
import 'package:mobile_ta/warga/setor_langsung/status_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WargaDetailSetorLangsung extends StatefulWidget {
  final String tanggal;
  final String? catatan;
  const WargaDetailSetorLangsung({
    Key? key,
    required this.tanggal,
    this.catatan,
  }) : super(key: key);

  @override
  State<WargaDetailSetorLangsung> createState() =>
      _WargaDetailSetorLangsungState();
}

class _WargaDetailSetorLangsungState extends State<WargaDetailSetorLangsung> {
  final String lokasi = "Bank Sampah Kecamatan Tembalang";
  final String namaBank = "Bank Sampah Tembalang Berseri";
  final String deskripsiBank =
      "Tempat pengelolaan sampah ramah lingkungan dengan sistem tabungan.";
  final String alamatBank = "Jl. Tembalang Raya No.12, Semarang";
  final String mapUrl =
      "https://maps.googleapis.com/maps/api/staticmap?center=-7.05055837482239,110.44114708764991&zoom=16&size=600x300&markers=color:red%7C-7.05055837482239,110.44114708764991&key=YOUR_API_KEY";
  final String namaAdmin = "Ahmad Fathoni";
  final String emailAdmin = "ahmad@example.com";
  final String noHpAdmin = "0812-3456-7890";

  bool isLoading = false;
  String? formattedDate;

  @override
  void initState() {
    super.initState();

    // Konversi tanggal input ke format yyyy-MM-dd
    try {
      final inputDate = DateFormat('dd/MM/yyyy').parse(widget.tanggal);
      formattedDate = DateFormat('yyyy-MM-dd').format(inputDate);
    } catch (e) {
      formattedDate = null;
    }
  }

  Future<void> storePengajuanSetorLangsung() async {
    if (formattedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tanggal tidak valid.')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Token tidak ditemukan. Silakan login ulang.')),
      );
      return;
    }

    final url = Uri.parse("$baseUrl/setor-langsung");
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'waktu_pengajuan': formattedDate,
          'catatan_petugas': widget.catatan ?? '',
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseData['message'] ?? 'Berhasil mengirim'),
          ),
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const WargaStatusTungguSetorLangsung(),
          ),
          (Route<dynamic> route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'] ?? 'Gagal mengirim')),
        );
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan, coba lagi.')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
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
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Setor Langsung',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Informasi Input User
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.greenAccent.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Detail Penyetoran",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text("Tanggal: ${widget.tanggal}"),
                Text("Lokasi: $lokasi"),
                Text("Catatan: ${widget.catatan ?? "-"}"),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Informasi Bank Sampah
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Informasi Bank Sampah",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  "Nama: $namaBank",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text("Deskripsi: $deskripsiBank"),
                const SizedBox(height: 4),
                Text("Alamat: $alamatBank"),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    mapUrl,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        "https://i.pinimg.com/736x/b0/79/09/b079096855c0edbaba47d93c67f18853.jpg",
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Informasi Admin
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.greenAccent.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Kontak Admin",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text("Nama: $namaAdmin"),
                Text("Email: $emailAdmin"),
                Text("No HP: $noHpAdmin"),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Tombol Konfirmasi
          ElevatedButton(
            onPressed: isLoading ? null : storePengajuanSetorLangsung,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.greenAccent.shade400,
              padding: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    "Konfirmasi Setoran",
                    style: TextStyle(fontSize: 16),
                  ),
          ),
        ],
      ),
    );
  }
}
