import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_ta/pages/warga/kalkulator/hasil_setor_sampah_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KalkulatorSetorSampahPage extends StatefulWidget {
  const KalkulatorSetorSampahPage({super.key});

  @override
  State<KalkulatorSetorSampahPage> createState() =>
      _KalkulatorSetorSampahPageState();
}

class _KalkulatorSetorSampahPageState extends State<KalkulatorSetorSampahPage> {
  List<Map<String, dynamic>> _jenisSampahList = [
    {'jenis_sampah_id': null, 'berat': null},
  ];

  List<Map<String, dynamic>> _jenisSampahOptions = [];

  Future<void> fetchJenisSampah() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      debugPrint('Token tidak ditemukan');
      return;
    }

    final response = await http.get(
      Uri.parse('${dotenv.env['URL']}/jenis-sampah'),
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

  @override
  void initState() {
    super.initState();
    fetchJenisSampah();
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
      body: Padding(
        padding: EdgeInsets.all(11),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.greenAccent.shade400,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      'Kalkulator Setor Sampah',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Kalkulator Setor Sampah adalah untuk menghitung berat dan harga tiap jenis sampah yang di input',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.greenAccent.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Jenis Sampah',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Berat (kg)',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
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
                                hint: Text('Pilih jenis'),
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
                      icon: Icon(Icons.add, color: Colors.green),
                      label: Text(
                        'Tambah Jenis Sampah',
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent.shade400,
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
                            (context) =>
                                HasilSetorSampahPage(dataSetoran: dataSetor),
                      ),
                    );
                  },

                  child: Text(
                    'Lihat Hasil',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
