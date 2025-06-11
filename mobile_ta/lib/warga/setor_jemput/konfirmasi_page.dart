import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mobile_ta/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_ta/warga/setor_langsung/status_page.dart';

class WargaKonfirmasiSetorJemputPage extends StatefulWidget {
  final List<Map<String, dynamic>> dataSetoran;
  final String tanggal;
  final String? catatan;

  const WargaKonfirmasiSetorJemputPage({
    super.key,
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

    if (token == null) {
      debugPrint('Token tidak ditemukan');
      return;
    }

    for (var item in widget.dataSetoran) {
      final int jenisId = item['jenis_sampah_id'];
      final double berat = item['berat'] * 1.0;

      // Cek cache dulu
      Map<String, dynamic> jenisData;
      if (jenisSampahCache.containsKey(jenisId)) {
        jenisData = jenisSampahCache[jenisId]!;
      } else {
        final response = await http.get(
          Uri.parse('$baseUrl/jenis-sampah/$jenisId'),
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
          jenisSampahCache[jenisId] = jenisData; // simpan di cache
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
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
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
          'Setor Jemput',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Informasi Layanan
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.greenAccent.shade400,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: const [
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

              // Judul Jenis dan Berat
              const Text(
                'Jenis dan Berat Sampah',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // Box jenis dan berat + indikator
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

              // Estimasi Insentif
              const Text(
                'Estimasi Insentif',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                      children: [
                        const Text('Biaya Layanan'),
                        Text('-Rp $biayaLayanan'),
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
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Informasi Penyetoran',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.greenAccent.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Tanggal: ${widget.tanggal}"),
                    Text("Catatan: ${widget.catatan ?? "-"}"),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Bank Sampah
              const Text(
                'Nama Bank Sampah',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                'Alamat Bank Sampah: Jl. Lorem ipsum dolor sit amet, consectetur adipiscing elit, Semarang',
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  'https://i.pinimg.com/736x/b0/79/09/b079096855c0edbaba47d93c67f18853.jpg',
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 30),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isLoading ? null : storePengajuanSetorJemput,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent.shade400,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child:
                          isLoading
                              ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                  strokeWidth: 2,
                                ),
                              )
                              : const Text(
                                "Konfirmasi Setoran",
                                style: TextStyle(fontSize: 16),
                              ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Batalkan',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
