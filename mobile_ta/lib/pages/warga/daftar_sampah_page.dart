import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class WargaDaftarSampahPage extends StatefulWidget {
  const WargaDaftarSampahPage({super.key});

  @override
  State<WargaDaftarSampahPage> createState() => _WargaDaftarSampahPageState();
}

class _WargaDaftarSampahPageState extends State<WargaDaftarSampahPage> {
  List<dynamic> sampahList = [];
  bool isLoading = true; // Tambahkan ini

  Future<void> loadSampah() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      debugPrint('Token tidak ditemukan');
      setState(() => isLoading = false); // Tetap set false agar UI muncul
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('${dotenv.env['URL']}/jenis-sampah'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          sampahList = jsonData['data'];
        });
      } else {
        debugPrint('Gagal fetch: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Gagal load data: $e');
    } finally {
      setState(() => isLoading = false); // Tutup loading
    }
  }

  @override
  void initState() {
    super.initState();
    loadSampah();
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
          'Daftar Sampah',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body:
          isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Colors.green),
              )
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Berikut adalah daftar jenis sampah yang diterima oleh sistem, beserta harga jual per kilogramnya:",
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    const SizedBox(height: 20),
                    if (sampahList.isEmpty)
                      const Center(child: Text("Tidak ada data tersedia."))
                    else
                      Column(
                        children:
                            sampahList.map((sampah) {
                              final nama =
                                  sampah['nama_sampah'] ?? 'Tidak diketahui';
                              final harga =
                                  sampah['harga_per_satuan']?.toString() ?? '-';

                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 3,
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  title: Text(
                                    nama,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text("Harga: Rp$harga /kg"),
                                  leading: const Icon(
                                    Icons.recycling,
                                    color: Colors.green,
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                  ],
                ),
              ),
    );
  }
}
