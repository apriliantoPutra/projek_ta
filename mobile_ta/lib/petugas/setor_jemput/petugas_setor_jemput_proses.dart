import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_ta/constants/constants.dart';
import 'package:mobile_ta/petugas/detail_map/map_bank_sampah_map_warga_page.dart';
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
  Map<String, dynamic>? bankSampah;
  Map<int, Map<String, dynamic>> jenisSampahCache = {};
  List<Map<String, dynamic>> _jenisSampahList = [];
  List<Map<String, dynamic>> _jenisSampahOptions = [];

  List<Map<String, dynamic>> processedSetoran = [];
  int ongkir_per_jarak = 0;
  double totalBerat = 0;
  int totalHarga = 0;
  int biayaLayanan = 0;
  String gambarPengguna = '';
  String namaPengguna = '';
  bool isTotalValid = true;
  String? totalError;

  late double latitudeBankSampah;
  late double longitudeBankSampah;
  late double latitudeWarga;
  late double longitudeWarga;
  late GoogleMapController _mapController;
  late CameraPosition _initialCameraPosition;
  Set<Marker> _markers = {};
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
      await fetchBankSampah();
      calculateServiceFee();

      if (pengajuanDetailSetor != null && bankSampah != null) {
        final profil = pengajuanDetailSetor!['user']?['profil'];
        gambarPengguna =
            (profil != null && (profil['gambar_url'] ?? '').isNotEmpty)
                ? profil['gambar_url']
                : 'https://i.pinimg.com/736x/8a/e9/e9/8ae9e92fa4e69967aa61bf2bda967b7b.jpg';

        namaPengguna = profil?['nama_pengguna'] ?? 'memuat..';

        // Parse coordinates with proper error handling
        latitudeWarga =
            double.tryParse(profil?['latitude']?.toString() ?? '0') ?? 0;
        longitudeWarga =
            double.tryParse(profil?['longitude']?.toString() ?? '0') ?? 0;
        latitudeBankSampah =
            double.tryParse(bankSampah?['latitude']?.toString() ?? '0') ?? 0;
        longitudeBankSampah =
            double.tryParse(bankSampah?['longitude']?.toString() ?? '0') ?? 0;
        ongkir_per_jarak = bankSampah?['ongkir_per_jarak'] ?? 0;

        // Calculate mid point for initial camera position
        final midLat = (latitudeBankSampah + latitudeWarga) / 2;
        final midLng = (longitudeBankSampah + longitudeWarga) / 2;

        _initialCameraPosition = CameraPosition(
          target: LatLng(midLat, midLng),
          zoom: 12,
        );

        // Process setoran data
        processedSetoran =
            _jenisSampahList.map((item) {
              final jenisId = item['jenis_sampah_id'] as int?;
              final berat = item['berat'] as double?;
              final jenisInfo =
                  jenisId != null ? jenisSampahCache[jenisId] : null;
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
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
          _updateMarkers();
        });
      }
    }
  }

  void _updateMarkers() {
    setState(() {
      _markers = {
        Marker(
          markerId: const MarkerId('warga_location'),
          position: LatLng(latitudeWarga, longitudeWarga),
          infoWindow: const InfoWindow(title: 'Lokasi Warga'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
        Marker(
          markerId: const MarkerId('bank_sampah_location'),
          position: LatLng(latitudeBankSampah, longitudeBankSampah),
          infoWindow: InfoWindow(
            title: bankSampah?['nama_bank_sampah'] ?? 'Bank Sampah',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      };

      // Fit camera to show both markers
      if (_mapController != null) {
        final bounds = _getBounds();
        _mapController.animateCamera(
          CameraUpdate.newLatLngBounds(bounds, 50.0),
        );
      }
    });
  }

  LatLngBounds _getBounds() {
    final northeast = LatLng(
      latitudeBankSampah > latitudeWarga ? latitudeBankSampah : latitudeWarga,
      longitudeBankSampah > longitudeWarga
          ? longitudeBankSampah
          : longitudeWarga,
    );
    final southwest = LatLng(
      latitudeBankSampah < latitudeWarga ? latitudeBankSampah : latitudeWarga,
      longitudeBankSampah < longitudeWarga
          ? longitudeBankSampah
          : longitudeWarga,
    );
    return LatLngBounds(northeast: northeast, southwest: southwest);
  }

  Future<Map<String, dynamic>?> fetchBankSampah() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      debugPrint('Token tidak ditemukan');
      return null;
    }

    final response = await http.get(
      Uri.parse('$baseUrl/bank-sampah/1'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['data'] != null) {
        setState(() {
          bankSampah = responseData['data'];
        });
        return responseData['data'];
      }
    } else {
      debugPrint('Gagal ambil data bank sampah: ${response.body}');
    }
    return null;
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
    bool hasError = false;
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
    try {
      // 1. Hitung total berat dan harga dari sampah yang dipilih
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

      // 2. Hitung biaya layanan berdasarkan jarak
      calculateServiceFee(); // Pastikan ini mengupdate biayaLayanan

      // 3. Hitung total akhir setelah dikurangi biaya layanan
      final totalAkhir = totalHarga - biayaLayanan;

      // 4. Validasi total akhir tidak negatif
      if (totalAkhir <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Total harga tidak boleh kurang dari biaya layanan'),
          ),
        );
        return;
      }

      // 5. Kirim data ke API
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
          'total_harga': totalAkhir,
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

  // perhitungan jarak
  void calculateServiceFee() {
    if (latitudeWarga == null ||
        longitudeWarga == null ||
        latitudeBankSampah == null ||
        longitudeBankSampah == null) {
      biayaLayanan = 0;
      return;
    }
    final jarak = _calculateDistanceInKm(
      latitudeWarga!,
      longitudeWarga!,
      latitudeBankSampah!,
      longitudeBankSampah!,
    );

    // Hitung biaya layanan
    biayaLayanan = jarak * ongkir_per_jarak;
  }

  int _calculateDistanceInKm(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const earthRadius = 6371; // Radius bumi dalam kilometer
    final dLat = _degreesToRadians(lat2 - lat1);
    final dLon = _degreesToRadians(lon2 - lon1);
    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    final distance = earthRadius * c;

    // Jika jarak < 1 km, return 0, else return jarak dibulatkan ke bawah
    return distance < 1 ? 0 : distance.floor();
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  String _formatDistance(double distance) {
    if (distance < 1) {
      return "Kurang dari 1 Km";
    } else {
      return "${distance.toStringAsFixed(0)} Km";
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

    final estimatedTotal = totalHarga - biayaLayanan;
    isTotalValid = estimatedTotal >= 0;
    totalError = isTotalValid ? null : "Total tidak boleh negatif";

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

            // In your build method, add this:
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.greenAccent.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Lokasi",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  _buildMapImage(),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => (PetugasMapBankSampahMapWargaPage(
                                  latitudeWarga: latitudeWarga,
                                  longitudeWarga: longitudeWarga,
                                  latitudeBankSampah: latitudeBankSampah,
                                  longitudeBankSampah: longitudeBankSampah,
                                )),
                          ),
                        );
                      },
                      icon: const Icon(Icons.map),
                      label: const Text("Detail Map"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            const SizedBox(height: 16),
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
                    children: [
                      const Text("Jarak"),
                      Text(
                        _formatDistance(
                          _calculateDistanceInKm(
                            latitudeWarga ?? 0,
                            longitudeWarga ?? 0,
                            latitudeBankSampah ?? 0,
                            longitudeBankSampah ?? 0,
                          ).toDouble(),
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Biaya Layanan (Ongkir)"),
                      Text('Rp $biayaLayanan'),
                    ],
                  ),
                  Divider(),
                  // CHANGED: Tampilkan estimatedTotal dengan validasi
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Perkiraan Insentif',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Rp ${estimatedTotal >= 0 ? estimatedTotal : 0}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isTotalValid ? Colors.black : Colors.red,
                            ),
                          ),
                          if (!isTotalValid)
                            Text(
                              totalError!,
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                        ],
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
                onPressed:
                    (isLoading || !isTotalValid) ? null : konfirmasiSetoran,
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

  Widget _buildMapImage() {
    // Check if coordinates are valid
    if (latitudeWarga == 0 ||
        longitudeWarga == 0 ||
        latitudeBankSampah == 0 ||
        longitudeBankSampah == 0) {
      return _buildFallbackMapImage();
    }

    return SizedBox(
      height: 180,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: GoogleMap(
          initialCameraPosition: _initialCameraPosition,
          markers: _markers,
          onMapCreated: (controller) {
            _mapController = controller;
            // After map is created, fit the bounds
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final bounds = _getBounds();
              _mapController.animateCamera(
                CameraUpdate.newLatLngBounds(bounds, 50.0),
              );
            });
          },
          mapType: MapType.normal,
          zoomControlsEnabled: false,
          myLocationEnabled: false,
          myLocationButtonEnabled: false,
        ),
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
