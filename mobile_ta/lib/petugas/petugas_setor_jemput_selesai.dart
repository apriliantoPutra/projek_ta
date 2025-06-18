import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_ta/constants/constants.dart';
import 'package:mobile_ta/widget/petugas_main_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PetugasSetorJemputSelesai extends StatefulWidget {
  final int id;
  const PetugasSetorJemputSelesai({required this.id, super.key});

  @override
  State<PetugasSetorJemputSelesai> createState() =>
      _PetugasSetorJemputSelesaiState();
}

class _PetugasSetorJemputSelesaiState extends State<PetugasSetorJemputSelesai> {
  Map<String, dynamic>? pengajuanDetailSetor;
  Map<int, Map<String, dynamic>> jenisSampahCache = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    await fetchPengajuanDetailSetor();
    await fetchJenisSampah();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> fetchPengajuanDetailSetor() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final resp = await http.get(
      Uri.parse('$baseUrl/setor-jemput/${widget.id}'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body)['data'];
      pengajuanDetailSetor = data;
    } else {
      throw Exception('fetchPengajuanSetor failed');
    }
  }

  Future<void> fetchJenisSampah() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) return;

    final setoran =
        pengajuanDetailSetor?['input_detail']['setoran_sampah'] ?? [];

    for (var item in setoran) {
      final int jenisId = item['jenis_sampah_id'];

      if (!jenisSampahCache.containsKey(jenisId)) {
        final response = await http.get(
          Uri.parse('$baseUrl/jenis-sampah/$jenisId'),
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body)['data'];
          jenisSampahCache[jenisId] = {
            'nama': data['nama_sampah'],
            'harga': data['harga_per_satuan'],
            'warna': data['warna_indikasi'],
          };
        }
      }
    }
  }

  Widget build(BuildContext context) {
    if (isLoading || pengajuanDetailSetor == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Setor Langsung Sampah")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final profil = pengajuanDetailSetor!['user']?['profil'];
    final gambarPengguna =
        (profil != null && (profil['gambar_pengguna'] ?? '').isNotEmpty)
            ? profil['gambar_url']
            : 'https://i.pinimg.com/736x/8a/e9/e9/8ae9e92fa4e69967aa61bf2bda967b7b.jpg';

    final namaPengguna = profil?['nama_pengguna'] ?? 'memuat..';
    final detailSetoran = pengajuanDetailSetor!['input_detail'];
    final totalBerat = detailSetoran['total_berat'].toString();
    final totalHarga = detailSetoran['total_harga'];
    final setoranSampah = detailSetoran['setoran_sampah'] as List;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed:
              () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => PetugasMainWrapper(initialMenu: 1),
                ),
                (Route<dynamic> route) => false,
              ),
        ),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Setor Jemput Sampah",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 24,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              "Selesai",
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profil Penyetor
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(gambarPengguna),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    namaPengguna,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),

            // Estimasi Berat
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Estimasi Berat Sampah",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),

            // Kartu Estimasi
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF8FD14F),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  // Bar total berat
                  Stack(
                    children: [
                      Container(
                        height: 32,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey[300],
                        ),
                      ),
                      Row(
                        children:
                            pengajuanDetailSetor!['input_detail']['setoran_sampah']
                                .map<Widget>((item) {
                                  final jenisId = item['jenis_sampah_id'];
                                  final berat = item['berat'] * 1.0;
                                  final totalBerat =
                                      pengajuanDetailSetor!['input_detail']['total_berat'] *
                                      1.0;
                                  final proportion = berat / totalBerat;

                                  final warna =
                                      jenisSampahCache[jenisId]?['warna'] ??
                                      '#999999';

                                  return Expanded(
                                    flex:
                                        (proportion * 1000)
                                            .round(), // agar fleksibel
                                    child: Container(
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: Color(
                                          int.parse(
                                            warna.replaceAll('#', '0xff'),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                })
                                .toList(),
                      ),
                      Positioned.fill(
                        child: Center(
                          child: Text(
                            "$totalBerat kg",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Legend dari data setoran
                  ...setoranSampah.map((item) {
                    final jenisId = item['jenis_sampah_id'];
                    final berat = item['berat'];
                    final jenisInfo = jenisSampahCache[jenisId];

                    if (jenisInfo == null) return SizedBox();

                    final Color color = _parseHexColor(jenisInfo['warna']);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          _buildLegend(
                            color: color,
                            label: jenisInfo['nama'],
                            weight: "${berat}kg",
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    "Estimasi Harga",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Spacer(),
                  Text(
                    "Rp $totalHarga",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Alamat Warga",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  Text(
                    "Jl. Lorem ipsum dolor sit amet, consectetur adipiscing elit, Semarang, Jawa Tengah",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              height: 233,
              decoration: ShapeDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    "https://i.pinimg.com/736x/b0/79/09/b079096855c0edbaba47d93c67f18853.jpg",
                  ),
                  fit: BoxFit.cover,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    "Telah diambil oleh",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Spacer(),
                  Text(
                    "Nama Petugas Jemput",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend({
    required Color color,
    required String label,
    required String weight,
  }) {
    return Expanded(
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          Text(
            weight,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Color _parseHexColor(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return Color(int.parse(hexColor, radix: 16));
  }
}
