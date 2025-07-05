import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mobile_ta/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_ta/warga/setor_langsung/status_page.dart';

class WargaKonfirmasiSetorJemputPage extends StatefulWidget {
  final List<Map<String, dynamic>> dataSetoran;
  final String tanggal;
  final String? catatan;
  final Map<String, dynamic>? bankSampah;

  const WargaKonfirmasiSetorJemputPage({
    super.key,
    this.bankSampah,
    required this.dataSetoran,
    required this.tanggal,
    required this.catatan,
  });

  @override
  State<WargaKonfirmasiSetorJemputPage> createState() =>
      _WargaKonfirmasiSetorJemputPageState();
}

class _WargaKonfirmasiSetorJemputPageState
    extends State<WargaKonfirmasiSetorJemputPage> {
  late Map<String, dynamic>? bankSampah;
  late String namaBank;
  late String deskripsiBank;
  late String alamatBank;
  late String namaAdmin;
  late String emailAdmin;
  late String noHpAdmin;
  late String mapUrl;

  final Map<int, Map<String, dynamic>> jenisSampahCache = {};
  List<Map<String, dynamic>> processedSetoran = [];
  double totalBerat = 0.0;
  int totalHarga = 0;
  int biayaLayanan = 0;
  bool isLoading = true;
  String? formattedDate;

  @override
  void initState() {
    super.initState();
    processSetoran();
    bankSampah = widget.bankSampah;

    namaBank = bankSampah?['nama_bank_sampah'] ?? 'Memuat...';
    mapUrl = bankSampah?['koordinat_bank_sampah'] ?? 'Memuat...';
    deskripsiBank = bankSampah?['deskripsi_bank_sampah'] ?? 'Memuat...';
    alamatBank = bankSampah?['alamat_bank_sampah'] ?? 'Memuat...';
    namaAdmin = bankSampah?['user']?['profil']?['nama_pengguna'] ?? 'Memuat...';
    emailAdmin = bankSampah?['user']?['email'] ?? 'Memuat...';
    noHpAdmin =
        bankSampah?['user']?['profil']?['no_hp_pengguna'] ?? 'Memuat...';

    try {
      final inputDate = DateFormat('dd/MM/yyyy').parse(widget.tanggal);
      formattedDate = DateFormat('yyyy-MM-dd').format(inputDate);
    } catch (e) {
      formattedDate = null;
    }
  }

  Future<void> processSetoran() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) return;

    for (var item in widget.dataSetoran) {
      final int jenisId = item['jenis_sampah_id'];
      final double berat = item['berat'];

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

        totalBerat += berat;
        totalHarga += subtotal;
      }
    }

    setState(() => isLoading = false);
  }

  Future<void> storePengajuanSetorJemput() async {
    if (formattedDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Tanggal tidak valid.')));
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

    // Bentuk data setoran_sampah dari dataSetoran awal
    final List<Map<String, dynamic>> setoranSampah =
        widget.dataSetoran.map((item) {
          return {
            "jenis_sampah_id": item['jenis_sampah_id'],
            "berat": item['berat'],
          };
        }).toList();

    final url = Uri.parse("$baseUrl/setor-jemput");
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
          'setoran_sampah': setoranSampah,
          'total_berat': totalBerat,
          'total_harga': totalHarga,
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Terjadi kesalahan, coba lagi.')));
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
          'Setor Jemput',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 600;
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 20,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 600),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Visualisasi Jenis Sampah
                            _buildCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Komposisi Sampah",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Stack(
                                    children: [
                                      Container(
                                        height: 24,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          color: Colors.grey[300],
                                        ),
                                      ),
                                      Row(
                                        children:
                                            processedSetoran.map((item) {
                                              final proportion =
                                                  item['berat'] / totalBerat;
                                              return Expanded(
                                                flex:
                                                    (proportion * 1000).round(),
                                                child: Container(
                                                  height: 24,
                                                  decoration: BoxDecoration(
                                                    color: Color(
                                                      int.parse(
                                                        item['warna']
                                                            .toString()
                                                            .replaceAll(
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
                                            '${totalBerat.toStringAsFixed(1)} kg',
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
                                  ...processedSetoran.map(
                                    (item) => Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.square,
                                            color: Color(
                                              int.parse(
                                                item['warna']
                                                    .toString()
                                                    .replaceAll('#', '0xff'),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(child: Text(item['nama'])),
                                          Text('${item['berat']} kg'),
                                          const SizedBox(width: 16),
                                          Text('Rp${item['subtotal']}'),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            _buildCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Estimasi Insentif",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Total Sampah"),
                                      Text('Rp$totalHarga'),
                                    ],
                                  ),
                                  const Divider(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Total Insentif",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Rp${totalHarga - biayaLayanan}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            _buildCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Detail Penyetoran",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text("Tanggal: ${widget.tanggal}"),
                                  Text("Catatan: ${widget.catatan ?? "-"}"),
                                ],
                              ),
                            ),

                            _buildCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Informasi Bank Sampah",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Nama: $namaBank",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text("Deskripsi: $deskripsiBank"),
                                  Text("Alamat: $alamatBank"),
                                  const SizedBox(height: 12),
                                  _buildMapImage(mapUrl),
                                ],
                              ),
                            ),

                            _buildCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Kontak Admin",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text("Nama: $namaAdmin"),
                                  Text("Email: $emailAdmin"),
                                  Text("No HP: $noHpAdmin"),
                                ],
                              ),
                            ),

                            const SizedBox(height: 32),

                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.greenAccent.shade400,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                onPressed:
                                    isLoading
                                        ? null
                                        : storePengajuanSetorJemput,
                                child:
                                    isLoading
                                        ? const CircularProgressIndicator()
                                        : const Text('Konfirmasi Setoran'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.greenAccent.shade100,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildMapImage(String koordinat) {
    final cleanedKoordinat = koordinat.trim().replaceAll(' ', '');

    final isValid = RegExp(
      r'^-?\d+(\.\d+)?,-?\d+(\.\d+)?$',
    ).hasMatch(cleanedKoordinat);

    if (!isValid) {
      return _buildFallbackMapImage();
    }

    final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      return _buildFallbackMapImage();
    }

    final staticMapUrl =
        "https://maps.googleapis.com/maps/api/staticmap?center=$cleanedKoordinat&zoom=15&size=600x300&markers=color:red%7C$cleanedKoordinat&key=$apiKey";

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        staticMapUrl,
        height: 180,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildFallbackMapImage(),
      ),
    );
  }

  Widget _buildFallbackMapImage() {
    return Image.network(
      "https://i.pinimg.com/736x/b0/79/09/b079096855c0edbaba47d93c67f18853.jpg",
      height: 150,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }
}
