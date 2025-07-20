import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HistoriSetorSelesaiLangsungPage extends StatefulWidget {
  final int id;
  const HistoriSetorSelesaiLangsungPage({required this.id, super.key});

  @override
  State<HistoriSetorSelesaiLangsungPage> createState() =>
      _HistoriSetorSelesaiLangsungPageState();
}

class _HistoriSetorSelesaiLangsungPageState
    extends State<HistoriSetorSelesaiLangsungPage> {
  Map<String, dynamic>? pengajuanDetailSetor;
  Map<int, Map<String, dynamic>> jenisSampahCache = {};
  List<Map<String, dynamic>> processedSetoran = [];
  double totalBerat = 0.0;
  int totalHarga = 0;
  int biayaLayanan = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    await fetchPengajuanDetailSetor();
    await processSetoranData();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> fetchPengajuanDetailSetor() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final resp = await http.get(
      Uri.parse('${dotenv.env['URL']}/setor-langsung/selesai/${widget.id}'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body)['data'];
      setState(() {
        pengajuanDetailSetor = data;
      });
    } else {
      throw Exception('fetchPengajuanSetor failed');
    }
  }

  Future<void> processSetoranData() async {
    if (pengajuanDetailSetor == null) return;

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final detailSetoran = pengajuanDetailSetor!['input_detail'];
    final setoranSampah = detailSetoran['setoran_sampah'] as List;

    totalBerat = (detailSetoran['total_berat'] as num).toDouble();
    totalHarga = detailSetoran['total_harga'] as int;

    for (var item in setoranSampah) {
      final int jenisId = item['jenis_sampah_id'];
      final double berat = (item['berat'] as num).toDouble();

      if (!jenisSampahCache.containsKey(jenisId)) {
        final response = await http.get(
          Uri.parse('${dotenv.env['URL']}/jenis-sampah/$jenisId'),
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

      final jenisData = jenisSampahCache[jenisId];
      if (jenisData != null) {
        final int harga = jenisData['harga'];
        final int subtotal = (berat * harga).round();

        processedSetoran.add({
          'nama': jenisData['nama'],
          'berat': berat,
          'harga': harga,
          'subtotal': subtotal,
          'warna': jenisData['warna'],
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || pengajuanDetailSetor == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Setor Langsung Sampah")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    
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
          'Histori Setor Langsung',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Jenis dan Berat Sampah',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          // Grafik Sampah
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
                                      item['warna'].toString().replaceAll(
                                        '#',
                                        '0xff',
                                      ),
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
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.square,
                          color: Color(
                            int.parse(
                              item['warna'].toString().replaceAll('#', '0xff'),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(child: Text(item['nama'])),
                        Text('${item['berat']}kg'),
                        const SizedBox(width: 16),
                        Text('Rp ${item['subtotal']}'),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Estimasi Insentif',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          // Estimasi Insentif
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
                    const Text('Total harga sampah'),
                    Text('Rp $totalHarga'),
                  ],
                ),
                const SizedBox(height: 4),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Insentif',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Rp ${totalHarga - biayaLayanan}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
