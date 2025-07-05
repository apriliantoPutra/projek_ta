import 'package:flutter/material.dart';
import 'package:mobile_ta/constants/constants.dart';
import 'package:mobile_ta/warga/setor_jemput/konfirmasi_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class WargaSetorJemput extends StatefulWidget {
  final Map<String, dynamic>? bankSampah;
  const WargaSetorJemput({this.bankSampah, super.key});

  @override
  State<WargaSetorJemput> createState() => _WargaSetorJemputState();
}

class _WargaSetorJemputState extends State<WargaSetorJemput> {
  List<Map<String, dynamic>> _jenisSampahList = [
    {'jenis_sampah_id': null, 'berat': null, 'error': null},
  ];
  final TextEditingController _tanggalController = TextEditingController();
  final TextEditingController _catatanController = TextEditingController();
  List<Map<String, dynamic>> _jenisSampahOptions = [];

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

  void _removeJenisSampah(int index) {
    if (_jenisSampahList.length > 1) {
      setState(() {
        _jenisSampahList.removeAt(index);
      });
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
          'Setor Jemput',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
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
                        SizedBox(width: 40),
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
                            SizedBox(width: 5),
                            Expanded(
                              child: TextFormField(
                                keyboardType: TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Berat',
                                  errorText: item['error'],
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
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _removeJenisSampah(index),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _jenisSampahList.add({
                            'jenis_sampah_id': null,
                            'berat': null,
                            'error': null,
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
              SizedBox(height: 15),
              // ... (rest of your existing code for date picker and notes)
              Text(
                "Tanggal Penyetoran",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              // Input tanggal
              Container(
                decoration: BoxDecoration(
                  color: Colors.greenAccent.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextFormField(
                  controller: _tanggalController,
                  readOnly: true,
                  onTap: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2024),
                      lastDate: DateTime(2030),
                    );
                    if (pickedDate != null) {
                      // Format tanggal: dd/MM/yyyy
                      String formattedDate =
                          "${pickedDate.day.toString().padLeft(2, '0')}/"
                          "${pickedDate.month.toString().padLeft(2, '0')}/"
                          "${pickedDate.year}";
                      _tanggalController.text = formattedDate;
                    }
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Tanggal",
                  ),
                ),
              ),

              const SizedBox(height: 24),
              Text(
                "Catatan Petugas (Opsional)",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              // Input catatan
              Container(
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.greenAccent.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextFormField(
                  controller: _catatanController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Masukkan catatan untuk petugas...",
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  final hasError = _jenisSampahList.any(
                    (item) => item['error'] != null,
                  );
                  final isAnyEmpty = _jenisSampahList.any(
                    (item) =>
                        item['jenis_sampah_id'] == null ||
                        item['berat'] == null,
                  );

                  if (hasError || isAnyEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Harap periksa input Anda')),
                    );
                    return;
                  }

                  final validData =
                      _jenisSampahList
                          .where(
                            (item) =>
                                item['jenis_sampah_id'] != null &&
                                item['berat'] != null,
                          )
                          .toList();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => WargaKonfirmasiSetorJemputPage(
                            dataSetoran: validData,
                            tanggal: _tanggalController.text,
                            catatan: _catatanController.text,
                            bankSampah: widget.bankSampah,
                          ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent.shade400,
                  padding: const EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('Selanjutnya'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
