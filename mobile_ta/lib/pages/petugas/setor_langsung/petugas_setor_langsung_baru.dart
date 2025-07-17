import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_ta/constants/constants.dart';
import 'package:mobile_ta/pages/petugas/setor_langsung/petugas_setor_langsung_konfirmasi.dart';
import 'package:mobile_ta/widget/petugas_main_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PetugasSetorLangsungBaru extends StatefulWidget {
  final int id;
  final String tanggal;
  final String catatan;

  const PetugasSetorLangsungBaru({
    required this.id,
    required this.tanggal,
    required this.catatan,
    super.key,
  });

  @override
  State<PetugasSetorLangsungBaru> createState() =>
      _PetugasSetorLangsungBaruState();
}

class _PetugasSetorLangsungBaruState extends State<PetugasSetorLangsungBaru> {
  Map<String, dynamic>? pengajuanSetor;
  List<Map<String, dynamic>> _jenisSampahList = [
    {'jenis_sampah_id': null, 'berat': null},
  ];
  List<Map<String, dynamic>> _jenisSampahOptions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.wait([fetchJenisSampah(), fetchPengajuanSetor()]);
    setState(() => _isLoading = false);
  }

  Future<void> fetchJenisSampah() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      debugPrint('Token tidak ditemukan');
      return;
    }
    final response = await http.get(
      Uri.parse('$baseUrl/jenis-sampah'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      setState(() {
        _jenisSampahOptions = List<Map<String, dynamic>>.from(json['data']);
      });
    } else {
      debugPrint('Gagal ambil data jenis sampah: ${response.body}');
    }
  }

  Future<void> fetchPengajuanSetor() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final resp = await http.get(
      Uri.parse('$baseUrl/setor-langsung/${widget.id}'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body)['data'];
      setState(() => pengajuanSetor = data);
    } else {
      throw Exception('fetchPengajuanSetor failed');
    }
  }

  void _removeJenisSampah(int index) {
    if (_jenisSampahList.length > 1) {
      setState(() {
        _jenisSampahList.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || pengajuanSetor == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "Setor Langsung Sampah",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: Color(0xFF128d54),
              fontSize: 24,
            ),
          ),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final profil = pengajuanSetor!['user']?['profil'];
    final gambarPengguna =
        (profil != null && (profil['gambar_pengguna'] ?? '').isNotEmpty)
            ? profil['gambar_url']
            : 'https://i.pinimg.com/736x/8a/e9/e9/8ae9e92fa4e69967aa61bf2bda967b7b.jpg';

    final namaPengguna = profil?['nama_pengguna'] ?? 'memuat..';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF128d54)),
          onPressed:
              () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => PetugasMainWrapper(initialMenu: 1),
                ),
                (Route<dynamic> route) => false,
              ),
        ),
        title: Text(
          "Daftar Setor Sampah",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Color(0xFF128d54),
            fontSize: 24,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(gambarPengguna),
                ),
                SizedBox(width: 16),
                Text(
                  namaPengguna,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.10),
                    blurRadius: 16,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Detail Penyetoran",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text("Tanggal: ${widget.tanggal}"),
                  Text("Catatan: ${widget.catatan}"),
                ],
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Masukkan Berat Sampah",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.10),
                    blurRadius: 16,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Jenis Sampah',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Berat (kg)',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      SizedBox(width: 40), // Space for delete button
                    ],
                  ),
                  SizedBox(height: 8),
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
                              hint: Text(
                                'Pilih jenis',
                                style: GoogleFonts.poppins(fontSize: 16),
                              ),
                              items:
                                  _jenisSampahOptions.map((option) {
                                    return DropdownMenuItem<int>(
                                      value: option['id'],
                                      child: Text(option['nama_sampah']),
                                    );
                                  }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _jenisSampahList[index]['jenis_sampah_id'] =
                                      value;
                                });
                              },
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Berat',
                                hintStyle: GoogleFonts.poppins(fontSize: 16),
                                errorText:
                                    _jenisSampahList[index]['error'] ?? null,
                              ),
                              onChanged: (value) {
                                final parsed = double.tryParse(value);
                                String? error;

                                if (parsed == null) {
                                  error = 'Harus berupa angka';
                                } else if (parsed < 0.5) {
                                  error = 'Minimum 0.5 kg';
                                } else if (parsed > 50) {
                                  error = 'Maksimum 50 kg';
                                } else if (!RegExp(
                                  r'^\d+(\.\d)?$',
                                ).hasMatch(value)) {
                                  error = 'Maksimal 1 angka desimal';
                                }

                                setState(() {
                                  if (error != null) {
                                    _jenisSampahList[index]['berat'] = null;
                                    _jenisSampahList[index]['error'] = error;
                                  } else {
                                    _jenisSampahList[index]['berat'] = parsed;
                                    _jenisSampahList[index]['error'] = null;
                                  }
                                });
                              },
                            ),
                          ),
                          SizedBox(width: 8),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removeJenisSampah(index),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _jenisSampahList.add({
                          'jenis_sampah_id': null,
                          'berat': null,
                        });
                      });
                    },
                    icon: Icon(Icons.add, color: Color(0xFF128d54)),
                    label: Text(
                      'Tambah Jenis Sampah',
                      style: GoogleFonts.poppins(color: Color(0xFF128d54)),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF128d54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                ),
                onPressed: () {
                  final hasError = _jenisSampahList.any(
                    (item) => item['error'] != null,
                  );
                  final isAnyEmpty = _jenisSampahList.any(
                    (item) =>
                        item['jenis_sampah_id'] == null ||
                        item['berat'] == null,
                  );

                  if (hasError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Tolong perbaiki input berat.')),
                    );
                    return;
                  }
                  if (isAnyEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Harap isi semua jenis sampah dan berat.',
                        ),
                      ),
                    );
                    return;
                  }
                  final dataSetor =
                      _jenisSampahList
                          .map(
                            (item) => {
                              'jenis_sampah_id': item['jenis_sampah_id'],
                              'berat': item['berat'],
                            },
                          )
                          .toList();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => PetugasSetorLangsungKonfirmasi(
                            dataSetoran: dataSetor,
                            pengajuanSetor: pengajuanSetor,
                            id: widget.id,
                            tanggal: widget.tanggal,
                            catatan: widget.catatan,
                          ),
                    ),
                  );
                },
                child: Text(
                  'Lihat Hasil',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
