// kode import tetap
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_ta/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widget/petugas_main_widget.dart';
import '../petugas/petugas_setor_jemput_selesai.dart';

class PetugasSetorJemputProses extends StatefulWidget {
  final int id;
  const PetugasSetorJemputProses({required this.id, super.key});

  @override
  State<PetugasSetorJemputProses> createState() =>
      _PetugasSetorJemputProsesState();
}

class _PetugasSetorJemputProsesState extends State<PetugasSetorJemputProses> {
  List<Map<String, dynamic>> _jenisSampahList = [];

  Map<String, dynamic>? pengajuanDetailSetor;
  List<Map<String, dynamic>> _jenisSampahOptions = [];
  Map<int, Map<String, dynamic>> jenisSampahCache = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchJenisSampah() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) return;

    final response = await http.get(
      Uri.parse('$baseUrl/jenis-sampah'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      setState(() {
        _jenisSampahOptions = List<Map<String, dynamic>>.from(json['data']);
      });
    }
  }

  Future<void> fetchData() async {
    await fetchPengajuanDetailSetor();
    await fetchJenisSampah();
    await fetchJenisSampahListCache();

    final oldSetoran =
        pengajuanDetailSetor?['input_detail']['setoran_sampah'] as List;
    _jenisSampahList =
        oldSetoran
            .map<Map<String, dynamic>>(
              (item) => {
                'jenis_sampah_id': item['jenis_sampah_id'],
                'berat': (item['berat'] as num).toDouble(),
              },
            )
            .toList();

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

  Future<void> fetchJenisSampahById(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) return;

    final response = await http.get(
      Uri.parse('$baseUrl/jenis-sampah/$id'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      jenisSampahCache[id] = {
        'nama': data['nama_sampah'],
        'harga': data['harga_per_satuan'],
        'warna': data['warna_indikasi'],
      };
    }
  }

  Future<void> fetchJenisSampahListCache() async {
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

  // post
  Future<void> konfirmasiSetoran() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) return;

    // Hitung total berat & harga
    double totalBerat = 0;
    int totalHarga = 0;

    List<Map<String, dynamic>> setoranSampah = [];

    for (var item in _jenisSampahList) {
      final int? jenisId = item['jenis_sampah_id'];
      final double? berat = item['berat'];

      if (jenisId == null || berat == null) continue;

      final jenisInfo = jenisSampahCache[jenisId];
      final hargaPerSatuan = jenisInfo != null ? (jenisInfo['harga'] ?? 0) : 0;

      totalBerat += berat;
      totalHarga += (berat * hargaPerSatuan).round();

      setoranSampah.add({"jenis_sampah_id": jenisId, "berat": berat});
    }

    final url = Uri.parse('$baseUrl/setor-jemput/konfirmasi/${widget.id}');
    final response = await http.patch(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'setoran_sampah': setoranSampah,
        'total_berat': totalBerat,
        'total_harga': totalHarga,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pengajuan berhasil dikonfirmasi.")),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => PetugasSetorJemputSelesai(id: widget.id),
        ),
        (Route<dynamic> route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal mengkonfirmasi pengajuan.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || pengajuanDetailSetor == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Setor Langsung Sampah")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final detailSetoran = pengajuanDetailSetor!['input_detail'];
    final int totalHarga = _jenisSampahList.fold(0, (sum, item) {
      final int? jenisId = item['jenis_sampah_id'];
      final double? berat = item['berat'];

      if (jenisId == null || berat == null) return sum;

      final jenisInfo = jenisSampahCache[jenisId];
      final hargaPerSatuan = jenisInfo != null ? (jenisInfo['harga'] ?? 0) : 0;


      return sum + (berat * hargaPerSatuan).round();
    });

    final double totalBerat = _jenisSampahList.fold(
      0.0,
      (sum, item) => sum + (item['berat'] ?? 0.0),
    );

    final profil = pengajuanDetailSetor!['user']?['profil'];
    final gambarPengguna =
        (profil != null && (profil['gambar_pengguna'] ?? '').isNotEmpty)
            ? profil['gambar_url']
            : 'https://i.pinimg.com/736x/8a/e9/e9/8ae9e92fa4e69967aa61bf2bda967b7b.jpg';

    final namaPengguna = profil?['nama_pengguna'] ?? 'memuat..';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
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
              "Proses",
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
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

            const SizedBox(height: 16),

            // Progress bar
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF8FD14F),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
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
                            _jenisSampahList.map<Widget>((item) {
                              final jenisId = item['jenis_sampah_id'];
                              final berat = item['berat'] ?? 0.0;
                              final proportion =
                                  totalBerat > 0 ? berat / totalBerat : 0.0;
                              final warna =
                                  jenisSampahCache[jenisId]?['warna'] ??
                                  '#999999';

                              return Expanded(
                                flex: (proportion * 1000).round(),
                                child: Container(
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: _parseHexColor(warna),
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                      Positioned.fill(
                        child: Center(
                          child: Text(
                            "${totalBerat.toStringAsFixed(1)} kg",
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

                  // Legend
                  ..._jenisSampahList.map((item) {
                    final jenisId = item['jenis_sampah_id'];
                    final berat = item['berat'];
                    final jenisInfo = jenisSampahCache[jenisId];
                    if (jenisInfo == null || berat == null)
                      return const SizedBox();

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
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Text(
                    "Estimasi Harga",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    "Rp $totalHarga",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Form Input Edit Sampah
            Container(
              margin: const EdgeInsets.all(16),
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ..._jenisSampahList.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: DropdownButtonFormField<int>(
                              value: item['jenis_sampah_id'],
                              hint: const Text('Pilih jenis'),
                              items:
                                  _jenisSampahOptions.map((option) {
                                    return DropdownMenuItem<int>(
                                      value: option['id'],
                                      child: Text(option['nama_sampah']),
                                    );
                                  }).toList(),
                              onChanged: (int? value) async {
                                if (value == null) return;

                                setState(() {
                                  _jenisSampahList[index]['jenis_sampah_id'] =
                                      value;
                                });

                                if (!jenisSampahCache.containsKey(value)) {
                                  await fetchJenisSampahById(value);
                                  setState(
                                    () {},
                                  ); // update legend & warna progress bar
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: DropdownButtonFormField<double>(
                              value: item['berat'],
                              hint: const Text('Berat'),
                              items: List.generate(20, (i) {
                                final val = 0.5 * (i + 1);
                                return DropdownMenuItem<double>(
                                  value: val,
                                  child: Text(
                                    val.toString().replaceAll('.', ','),
                                  ),
                                );
                              }),
                              onChanged: (value) {
                                setState(() {
                                  _jenisSampahList[index]['berat'] = value;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(
                              Icons.remove_circle,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              setState(() {
                                _jenisSampahList.removeAt(index);
                              });
                            },
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _jenisSampahList.add({
                          'jenis_sampah_id': null,
                          'berat': null,
                        });
                      });
                    },
                    icon: const Icon(Icons.add, color: Colors.green),
                    label: const Text(
                      'Tambah Jenis Sampah',
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                ],
              ),
            ),

            Center(
              child: SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () async {
                    await konfirmasiSetoran();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8FD14F),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Konfirmasi Sampah',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
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
