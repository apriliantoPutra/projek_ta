import 'package:flutter/material.dart';
import 'package:mobile_ta/constants/constants.dart';
import 'package:mobile_ta/warga/setor_jemput/konfirmasi_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class WargaSetorJemput extends StatefulWidget {
  const WargaSetorJemput({super.key});

  @override
  State<WargaSetorJemput> createState() => _WargaSetorJemputState();
}

class _WargaSetorJemputState extends State<WargaSetorJemput> {
  List<Map<String, dynamic>> _jenisSampahList = [
    {'jenis_sampah_id': null, 'berat': null},
  ];
  final TextEditingController _tanggalController = TextEditingController();
  final TextEditingController _catatanController = TextEditingController();

  List<Map<String, dynamic>> _jenisSampahOptions = [];

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
                              child: DropdownButtonFormField<double>(
                                value: item['berat'],
                                hint: Text('Berat'),
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
                    SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
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
                    SizedBox(height: 15),
                    Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
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
                    final dataSetor =
                        _jenisSampahList
                            .where(
                              (item) =>
                                  item['jenis_sampah_id'] != null &&
                                  item['berat'] != null,
                            )
                            .toList();

                    if (dataSetor.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Harap isi semua jenis sampah dan berat.',
                          ),
                        ),
                      );
                      return;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => WargaKonfirmasiSetorJemputPage(
                              dataSetoran: dataSetor,
                              tanggal: _tanggalController.text,
                              catatan:
                                  _catatanController.text.isNotEmpty
                                      ? _catatanController.text
                                      : null,
                            ),
                      ),
                    );
                  },
                  child: Text(
                    'Selanjutnya',
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
