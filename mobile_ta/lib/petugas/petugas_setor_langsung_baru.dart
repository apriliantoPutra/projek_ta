import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mobile_ta/constants/constants.dart';
import 'package:mobile_ta/petugas/petugas_setor_langsung_selesai.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PetugasSetorLangsungBaru extends StatefulWidget {
  final int id;
  const PetugasSetorLangsungBaru({required this.id, super.key});

  @override
  State<PetugasSetorLangsungBaru> createState() =>
      _PetugasSetorLangsungBaruState();
}

class _PetugasSetorLangsungBaruState extends State<PetugasSetorLangsungBaru> {
  List<Map<String, dynamic>> _jenisSampahList = [
    {'jenis_sampah_id': null, 'berat': null},
  ];
  Map<String, dynamic>? pengajuanSetor;
  List<Map<String, dynamic>> _jenisSampahOptions = [];
  double totalBerat = 0.0;
  int totalHarga = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchJenisSampah();
    fetchPengajuanSetor();
  }

  Future<void> fetchJenisSampah() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final resp = await http.get(
      Uri.parse('$baseUrl/jenis-sampah'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (resp.statusCode == 200) {
      final json = jsonDecode(resp.body);
      setState(() {
        _jenisSampahOptions = List<Map<String, dynamic>>.from(json['data']);
      });
    } else {
      debugPrint('fetchJenisSampah failed: ${resp.body}');
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

  Future<void> calculateSetoran() async {
    totalBerat = 0;
    totalHarga = 0;
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    for (var item in _jenisSampahList) {
      final id = item['jenis_sampah_id'];
      final berat = (item['berat'] as double?) ?? 0;
      if (id == null) continue;

      final resp = await http.get(
        Uri.parse('$baseUrl/jenis-sampah/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      if (resp.statusCode == 200) {
        final d = jsonDecode(resp.body)['data'];
        final harga = d['harga_per_satuan'] as int;
        totalBerat += berat;
        totalHarga += (berat * harga).round();
      }
    }
  }

  Future<void> storePengajuanSetorLangsung() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final List<Map<String, dynamic>> setoran =
        _jenisSampahList
            .where((it) => it['jenis_sampah_id'] != null && it['berat'] != null)
            .map(
              (it) => {
                'jenis_sampah_id': it['jenis_sampah_id'],
                'berat': it['berat'],
              },
            )
            .toList();

    final resp = await http.post(
      Uri.parse('$baseUrl/setor-langsung/detail-sampah/${widget.id}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'setoran_sampah': setoran,
        'total_berat': totalBerat,
        'total_harga': totalHarga,
      }),
    );

    final body = jsonDecode(resp.body);
    if (!(resp.statusCode == 200 || resp.statusCode == 201)) {
      throw Exception(body['message'] ?? 'error');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (pengajuanSetor == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Setor Langsung Sampah")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final profil = pengajuanSetor!['user']['profil'];
    final pic = (profil['gambar_url'] as String?) ?? '';
    final avatarUrl =
        pic.isNotEmpty
            ? pic
            : 'https://i.pinimg.com/736x/8a/e9/e9/8ae9e92fa4e69967aa61bf2bda967b7b.jpg';
    final nama = profil['nama_pengguna'] as String? ?? '';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Setor Langsung Sampah",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 24,
            color: Colors.black,
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
                  backgroundImage: NetworkImage(avatarUrl),
                ),
                SizedBox(width: 16),
                Text(
                  nama,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              "Masukkan Berat Sampah",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  ..._jenisSampahList.asMap().entries.map((e) {
                    final i = e.key;
                    final it = e.value;
                    return Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: DropdownButtonFormField<int>(
                              value: it['jenis_sampah_id'] as int?,
                              items:
                                  _jenisSampahOptions
                                      .map(
                                        (opt) => DropdownMenuItem<int>(
                                          value: opt['id'],
                                          child: Text(opt['nama_sampah']),
                                        ),
                                      )
                                      .toList(),
                              onChanged: (v) {
                                setState(
                                  () =>
                                      _jenisSampahList[i]['jenis_sampah_id'] =
                                          v,
                                );
                              },
                              decoration: InputDecoration(
                                labelText: "Jenis Sampah",
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: DropdownButtonFormField<double>(
                              value: it['berat'] as double?,
                              items:
                                  List.generate(20, (j) => 0.5 * (j + 1))
                                      .map(
                                        (val) => DropdownMenuItem<double>(
                                          value: val,
                                          child: Text(
                                            val.toString().replaceAll('.', ','),
                                          ),
                                        ),
                                      )
                                      .toList(),
                              onChanged: (v) {
                                setState(
                                  () => _jenisSampahList[i]['berat'] = v,
                                );
                              },
                              decoration: InputDecoration(
                                labelText: "Berat (kg)",
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () {
                        setState(
                          () => _jenisSampahList.add({
                            'jenis_sampah_id': null,
                            'berat': null,
                          }),
                        );
                      },
                      icon: Icon(Icons.add, color: Colors.green),
                      label: Text(
                        "Tambah Jenis Sampah",
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            TextButton(
              onPressed: () async {
                setState(() => isLoading = true);
                await calculateSetoran();
                setState(() => isLoading = false); // supaya UI refresh
              },
              child: Text("Hitung Estimasi Harga"),
            ),

            SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "Estimasi Harga: Rp ${NumberFormat.decimalPattern().format(totalHarga)}",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  setState(() => isLoading = true);
                  await calculateSetoran();
                  try {
                    await storePengajuanSetorLangsung();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Setoran berhasil dikirim")),
                    );
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => PetugasSetorLangsungSelesai(id: widget.id),
                      ),
                      (r) => false,
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(e.toString())));
                  }
                  setState(() => isLoading = false);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff8fd14f),
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                ),
                child:
                    isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                          "Ambil Sampah",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
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
