import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HasilSetorSampahPage extends StatefulWidget {
  final List<Map<String, dynamic>> dataSetoran;
  const HasilSetorSampahPage({required this.dataSetoran, super.key});

  @override
  State<HasilSetorSampahPage> createState() => _HasilSetorSampahPageState();
}

class _HasilSetorSampahPageState extends State<HasilSetorSampahPage> {
  final Map<int, Map<String, dynamic>> jenisSampahCache = {};
  List<Map<String, dynamic>> processedSetoran = [];
  double totalBerat = 0.0;
  int totalHarga = 0;
  int biayaLayanan = 0; // Tetap 0
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    processSetoran();
  }

  Future<void> processSetoran() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      debugPrint('Token tidak ditemukan');
      return;
    }

    for (var item in widget.dataSetoran) {
      final int jenisId = item['jenis_sampah_id'];
      final double berat = item['berat'] * 1.0;

      Map<String, dynamic> jenisData;
      if (jenisSampahCache.containsKey(jenisId)) {
        jenisData = jenisSampahCache[jenisId]!;
      } else {
        final response = await http.get(
          Uri.parse('${dotenv.env['URL']}/jenis-sampah/$jenisId'),
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body)['data'];
          jenisData = {
            'nama': data['nama_sampah'],
            'harga': data['harga_per_satuan'],
            'warna': data['warna_indikasi'],
          };
          jenisSampahCache[jenisId] = jenisData;
        } else {
          debugPrint('Gagal ambil data jenis sampah id: $jenisId');
          continue;
        }
      }

      final int harga = jenisData['harga'];
      final int subtotal = (berat * harga).round();

      processedSetoran.add({
        'nama': jenisData['nama'],
        'berat': berat,
        'harga': harga,
        'subtotal': subtotal,
        'warna': jenisData['warna'],
      });

      totalBerat += berat;
      totalHarga += subtotal;
    }

    setState(() {
      isLoading = false;
    });
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
          'Kalkulator Setor Sampah',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.greenAccent.shade400,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Column(
                          children: [
                            Text(
                              'Setor Jemput',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Setor Jemput adalah layanan penjemputan sampah ke rumah pengguna oleh petugas Bank Sampah, dengan tambahan biaya sebesar Rp4.000 per kilometer.',
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const Text(
                        'Jenis dan Berat Sampah',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.greenAccent.shade100,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                Container(
                                  height: 24,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.grey[300],
                                  ),
                                ),
                                Row(
                                  children:
                                      processedSetoran.map((item) {
                                        final double proportion =
                                            item['berat'] / totalBerat;
                                        return Expanded(
                                          flex: (proportion * 1000).round(),
                                          child: Container(
                                            height: 24,
                                            decoration: BoxDecoration(
                                              color: Color(
                                                int.parse(
                                                  item['warna']
                                                      .toString()
                                                      .replaceAll('#', '0xff'),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                ),
                                Positioned.fill(
                                  child: Center(
                                    child: Text(
                                      '${totalBerat.toStringAsFixed(1)}kg',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ...processedSetoran.map((item) {
                              return Row(
                                children: [
                                  Icon(
                                    Icons.square,
                                    color: Color(
                                      int.parse(
                                        item['warna'].toString().replaceAll(
                                          '#',
                                          '0xff',
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(child: Text(item['nama'])),
                                  Text('${item['berat']}kg'),
                                ],
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Estimasi Insentif',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.greenAccent.shade100,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Estimasi harga sampah anda'),
                                Text('Rp $totalHarga'),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text('Biaya Layanan'),
                                Text('-Rp 0'),
                              ],
                            ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Perkiraan Insentif',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Rp ${totalHarga - biayaLayanan}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
