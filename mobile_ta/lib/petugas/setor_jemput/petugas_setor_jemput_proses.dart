import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_ta/constants/constants.dart';
import 'package:mobile_ta/petugas/setor_jemput/petugas_setor_jemput_selesai.dart';
import 'package:mobile_ta/widget/petugas_main_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PetugasSetorJemputProses extends StatefulWidget {
  final int id;
  const PetugasSetorJemputProses({required this.id, super.key});

  @override
  State<PetugasSetorJemputProses> createState() =>
      _PetugasSetorJemputProsesState();
}

class _PetugasSetorJemputProsesState extends State<PetugasSetorJemputProses> {
  Map<String, dynamic>? pengajuanDetailSetor;
  Map<int, Map<String, dynamic>> jenisSampahCache = {};
  List<Map<String, dynamic>> _jenisSampahList = [];
  List<Map<String, dynamic>> _jenisSampahOptions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      await fetchPengajuanDetailSetor();
      await fetchJenisSampahOptions();
      await processInitialData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> fetchPengajuanDetailSetor() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final resp = await http.get(
      Uri.parse('$baseUrl/setor-jemput/${widget.id}'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (resp.statusCode == 200) {
      final responseData = jsonDecode(resp.body);
      if (responseData['data'] != null) {
        setState(() {
          pengajuanDetailSetor = responseData['data'];
        });
      }
    } else {
      throw Exception('Gagal memuat data pengajuan');
    }
  }

  Future<void> fetchJenisSampahOptions() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) return;

    final response = await http.get(
      Uri.parse('$baseUrl/jenis-sampah'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['data'] != null) {
        setState(() {
          _jenisSampahOptions = List<Map<String, dynamic>>.from(
            responseData['data'],
          );
        });
      }
    }
  }

  Future<void> processInitialData() async {
    if (pengajuanDetailSetor == null) return;

    final setoranSampah =
        pengajuanDetailSetor!['input_detail']['setoran_sampah'] as List;

    // Convert initial data to editable format
    _jenisSampahList =
        setoranSampah.map<Map<String, dynamic>>((item) {
          return {
            'jenis_sampah_id': item['jenis_sampah_id'] as int,
            'berat': (item['berat'] as num).toDouble(),
            'error': null,
          };
        }).toList();

    // Cache jenis sampah data
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) return;

    for (var item in setoranSampah) {
      final jenisId = item['jenis_sampah_id'] as int;
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
            'nama': data['nama_sampah'] as String,
            'harga': data['harga_per_satuan'] as int,
            'warna': data['warna_indikasi'] as String,
          };
        }
      }
    }
  }

  void _removeJenisSampah(int index) {
    if (_jenisSampahList.length > 1) {
      setState(() => _jenisSampahList.removeAt(index));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Minimal harus ada 1 jenis sampah')),
      );
    }
  }

  Future<void> konfirmasiSetoran() async {
    // Validate inputs
    bool hasError = false;

    // Check for errors and empty fields
    for (var i = 0; i < _jenisSampahList.length; i++) {
      final item = _jenisSampahList[i];
      if (item['jenis_sampah_id'] == null) {
        setState(() {
          _jenisSampahList[i]['error'] = 'Pilih jenis sampah';
        });
        hasError = true;
      }

      if (item['berat'] == null || item['berat'] <= 0) {
        setState(() {
          _jenisSampahList[i]['error'] = 'Berat harus lebih dari 0';
        });
        hasError = true;
      }
    }

    if (hasError) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Harap periksa input Anda')));
      return;
    }

    setState(() => isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) return;

    // Calculate totals
    double totalBerat = 0;
    int totalHarga = 0;
    final setoranSampah =
        _jenisSampahList.map((item) {
          final jenisId = item['jenis_sampah_id'] as int;
          final berat = item['berat'] as double;
          final jenisInfo = jenisSampahCache[jenisId];
          final harga = (jenisInfo?['harga'] ?? 0) as int;
          final subtotal = (berat * harga).round();

          totalBerat += berat;
          totalHarga += subtotal;

          return {'jenis_sampah_id': jenisId, 'berat': berat};
        }).toList();

    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/setor-jemput/konfirmasi/${widget.id}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'setoran_sampah': setoranSampah,
          'total_berat': totalBerat,
          'total_harga': totalHarga,
        }),
      );

      if (response.statusCode == 200) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => PetugasSetorJemputSelesai(id: widget.id),
          ),
          (Route<dynamic> route) => false,
        );
      } else {
        throw Exception('Gagal mengkonfirmasi setoran');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || pengajuanDetailSetor == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Setor Jemput Sampah")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Calculate current totals for display
    double totalBerat = 0;
    int totalHarga = 0;
    int biayaLayanan = 0;

    final processedSetoran =
        _jenisSampahList.map((item) {
          final jenisId = item['jenis_sampah_id'] as int?;
          final berat = item['berat'] as double?;
          final jenisInfo = jenisId != null ? jenisSampahCache[jenisId] : null;
          final harga = (jenisInfo?['harga'] ?? 0) as int;
          final subtotal = berat != null ? (berat * harga).round() : 0;

          if (berat != null) {
            totalBerat += berat;
            totalHarga += subtotal;
          }

          return {
            'nama': jenisInfo?['nama'] ?? 'Pilih jenis sampah',
            'berat': berat,
            'subtotal': subtotal,
            'warna': jenisInfo?['warna'] ?? '#999999',
          };
        }).toList();

    final profil = pengajuanDetailSetor!['user']?['profil'];
    final gambarPengguna =
        (profil != null && (profil['gambar_url'] ?? '').isNotEmpty)
            ? profil['gambar_url']
            : 'https://i.pinimg.com/736x/8a/e9/e9/8ae9e92fa4e69967aa61bf2bda967b7b.jpg';

    final namaPengguna = profil?['nama_pengguna'] ?? 'memuat..';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        elevation: 0,
        centerTitle: true,
        title: Column(
          children: [
            Text(
              "Setor Jemput Sampah",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
            Text(
              "Proses",
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed:
              () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => PetugasMainWrapper(initialMenu: 1),
                ),
                (Route<dynamic> route) => false,
              ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // User Profile
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(gambarPengguna),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      namaPengguna,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Waste Visualization
            Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.greenAccent.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
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
                              final proportion =
                                  item['berat'] != null && totalBerat > 0
                                      ? item['berat']! / totalBerat
                                      : 0;
                              return Expanded(
                                flex: (proportion * 1000).round(),
                                child: Container(
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: _parseHexColor(item['warna']),
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                      Center(
                        child: Text(
                          "${totalBerat.toStringAsFixed(1)}kg",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  ...processedSetoran.map(
                    (item) => Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Icon(
                            Icons.square,
                            color: _parseHexColor(item['warna']),
                          ),
                          SizedBox(width: 8),
                          Expanded(child: Text(item['nama'])),
                          Text(
                            item['berat'] != null
                                ? "${item['berat']?.toStringAsFixed(2)}kg"
                                : "-",
                          ),
                          SizedBox(width: 16),
                          Text("Rp${item['subtotal']}"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Estimasi Insentif
            Container(
              padding: EdgeInsets.all(16),
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
                      Text('Estimasi harga sampah anda'),
                      Text('Rp $totalHarga'),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text('Biaya Layanan'), Text('-Rp 0')],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Perkiraan Insentif',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Rp ${totalHarga - biayaLayanan}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 10),
            // Editable Waste List
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.greenAccent.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  ..._jenisSampahList.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    return Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: DropdownButtonFormField<int?>(
                              value: item['jenis_sampah_id'],
                              hint: Text('Pilih jenis'),
                              items:
                                  _jenisSampahOptions.map((option) {
                                    return DropdownMenuItem<int?>(
                                      value: option['id'] as int?,
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
                              initialValue: item['berat']?.toString(),
                              keyboardType: TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Berat (kg)',
                                errorText: item['error'],
                              ),
                              onChanged: (value) {
                                if (value.isEmpty) {
                                  setState(() {
                                    _jenisSampahList[index]['berat'] = null;
                                    _jenisSampahList[index]['error'] = null;
                                  });
                                  return;
                                }

                                final parsed = double.tryParse(value);
                                String? error;

                                if (parsed == null) {
                                  error = 'Harus berupa angka';
                                } else if (parsed < 0.5) {
                                  error = 'Minimum 0.5 kg';
                                } else if (parsed > 50) {
                                  error = 'Maksimum 50 kg';
                                } else if (!RegExp(
                                  r'^\d+(\.\d{1,2})?$',
                                ).hasMatch(value)) {
                                  error = 'Maksimal 2 angka desimal';
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

            // Confirmation Button
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: ElevatedButton(
                onPressed: isLoading ? null : konfirmasiSetoran,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF8FD14F),
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                ),
                child:
                    isLoading
                        ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                        : Text(
                          "Konfirmasi Setoran",
                          style: TextStyle(color: Colors.white),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _parseHexColor(String hexColor) {
    try {
      hexColor = hexColor.replaceAll("#", "");
      if (hexColor.length == 6) hexColor = "FF$hexColor";
      return Color(int.parse(hexColor, radix: 16));
    } catch (e) {
      return Colors.grey;
    }
  }
}
