import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mobile_ta/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_ta/pages/warga/setor_jemput/status_page.dart';

class WargaKonfirmasiSetorJemputPage extends StatefulWidget {
  final List<Map<String, dynamic>> dataSetoran;
  final String tanggal;
  final String? catatan;
  final Map<String, dynamic>? profilData;

  const WargaKonfirmasiSetorJemputPage({
    super.key,
    this.profilData,
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
  Map<String, dynamic>? bankSampah;
  String namaBank = 'Memuat...';
  String deskripsiBank = 'Memuat...';
  String alamatBank = 'Memuat...';
  String namaAdmin = 'Memuat...';
  String emailAdmin = 'Memuat...';
  String noHpAdmin = 'Memuat...';
  int ongkir_per_jarak = 0;

  double? latitudeBankSampah;
  double? longitudeBankSampah;
  double? latitudeWarga;
  double? longitudeWarga;
  GoogleMapController? _mapController;
  CameraPosition? _initialCameraPosition;
  Set<Marker> _markers = {};

  final Map<int, Map<String, dynamic>> jenisSampahCache = {};
  List<Map<String, dynamic>> processedSetoran = [];
  double totalBerat = 0.0;
  int totalHarga = 0;
  int biayaLayanan = 0;
  bool isLoading = true;
  String? formattedDate;
  bool isTotalValid = true;
  String? totalError;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });
    try {
      final inputDate = DateFormat('dd/MM/yyyy').parse(widget.tanggal);
      formattedDate = DateFormat('yyyy-MM-dd').format(inputDate);
    } catch (e) {
      formattedDate = null;
    }

    try {
      await fetchBankSampah();
      await processSetoran();
      if (bankSampah != null) {
        namaBank = bankSampah?['nama_bank_sampah'] ?? 'Tidak tersedia';
        latitudeBankSampah = double.tryParse(bankSampah?['latitude'] ?? '');
        longitudeBankSampah = double.tryParse(bankSampah?['longitude'] ?? '');

        latitudeWarga = double.tryParse(widget.profilData?['latitude'] ?? '');
        longitudeWarga = double.tryParse(widget.profilData?['longitude'] ?? '');

        deskripsiBank =
            bankSampah?['deskripsi_bank_sampah'] ?? 'Tidak tersedia';
        alamatBank = bankSampah?['alamat_bank_sampah'] ?? 'Tidak tersedia';
        namaAdmin =
            bankSampah?['user']?['profil']?['nama_pengguna'] ??
            'Tidak tersedia';
        emailAdmin = bankSampah?['user']?['email'] ?? 'Tidak tersedia';
        noHpAdmin =
            bankSampah?['user']?['profil']?['no_hp_pengguna'] ??
            'Tidak tersedia';

        ongkir_per_jarak = bankSampah?['ongkir_per_jarak'] ?? 0;
      }
      if (latitudeBankSampah != null &&
          longitudeBankSampah != null &&
          latitudeWarga != null &&
          longitudeWarga != null) {
        final midLat = (latitudeBankSampah! + latitudeWarga!) / 2;
        final midLng = (longitudeBankSampah! + longitudeWarga!) / 2;

        _initialCameraPosition = CameraPosition(
          target: LatLng(midLat, midLng),
          zoom: 12,
        );
      }

      calculateServiceFee();

      final totalAkhir = totalHarga - biayaLayanan;
      isTotalValid = totalAkhir >= 0;
      totalError = isTotalValid ? null : "Total insentif tidak boleh negatif";

      _updateMarkers();
    } catch (e) {
      debugPrint('Error in fetchData: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _updateMarkers() {
    if (latitudeBankSampah == null ||
        longitudeBankSampah == null ||
        latitudeWarga == null ||
        longitudeWarga == null)
      return;

    setState(() {
      _markers = {
        Marker(
          markerId: const MarkerId('bank_sampah_location'),
          position: LatLng(latitudeBankSampah!, longitudeBankSampah!),
          infoWindow: InfoWindow(title: namaBank),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
        Marker(
          markerId: const MarkerId('warga_location'),
          position: LatLng(latitudeWarga!, longitudeWarga!),
          infoWindow: const InfoWindow(title: 'Lokasi Anda'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      };

      // Fit camera to show both markers
      if (_mapController != null) {
        final bounds = _getBounds();
        _mapController!.animateCamera(
          CameraUpdate.newLatLngBounds(bounds, 50.0),
        );
      }
    });
  }

  LatLngBounds _getBounds() {
    final northeast = LatLng(
      max(latitudeBankSampah!, latitudeWarga!),
      max(longitudeBankSampah!, longitudeWarga!),
    );
    final southwest = LatLng(
      min(latitudeBankSampah!, latitudeWarga!),
      min(longitudeBankSampah!, longitudeWarga!),
    );
    return LatLngBounds(northeast: northeast, southwest: southwest);
  }

  Future<Map<String, dynamic>?> fetchBankSampah() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        debugPrint('Token tidak ditemukan');
        return null;
      }

      final response = await http.get(
        Uri.parse('$baseUrl/bank-sampah/1'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        setState(() {
          bankSampah = responseData['data'];
        });
      } else {
        debugPrint(
          'Gagal ambil data bank sampah: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      debugPrint('Error in fetchBankSampah: $e');
    }
    return null;
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
  }

  Future<void> storePengajuanSetorJemput() async {
    calculateServiceFee();
    final totalAkhir = totalHarga - biayaLayanan;

    // Validasi total akhir tidak boleh negatif
    if (totalAkhir < 0) {
      setState(() {
        isTotalValid = false;
        totalError = "Total insentif tidak boleh negatif";
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(totalError!)));
      return;
    }

    if (formattedDate == null) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Tanggal tidak valid.')));
      }
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Token tidak ditemukan. Silakan login ulang.'),
          ),
        );
      }
      return;
    }

    final List<Map<String, dynamic>> setoranSampah =
        widget.dataSetoran.map((item) {
          return {
            "jenis_sampah_id": item['jenis_sampah_id'],
            "berat": item['berat'],
          };
        }).toList();

    final url = Uri.parse("$baseUrl/setor-jemput");
    try {
      setState(() {
        isLoading = true;
      });

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
          'total_harga': totalAkhir,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseData['message'] ?? 'Berhasil mengirim'),
            ),
          );

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const WargaStatusTungguSetorJemput(),
            ),
            (Route<dynamic> route) => false,
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseData['message'] ?? 'Gagal mengirim'),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint("Error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Terjadi kesalahan, coba lagi.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // perhitungan jarak
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

    return distance < 1 ? 0 : distance.round();
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  String _formatDistance(double distance) {
    if (distance < 1) {
      return "Kurang dari 1 Km";
    } else {
      return "${distance.round()} km";
    }
  }

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

    biayaLayanan = jarak * ongkir_per_jarak;
  }

  @override
  Widget build(BuildContext context) {
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Biaya Layanan (Ongkir)"),
                                      Text('Rp $biayaLayanan'),
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
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            'Rp${totalHarga - biayaLayanan}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  isTotalValid
                                                      ? Colors.black
                                                      : Colors.red,
                                            ),
                                          ),
                                          if (!isTotalValid)
                                            Text(
                                              totalError!,
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 12,
                                              ),
                                            ),
                                        ],
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
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            _buildMapImage(),
                            const SizedBox(height: 20),
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
                                    (isLoading || !isTotalValid)
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

  Widget _buildMapImage() {
    if (latitudeBankSampah == null ||
        longitudeBankSampah == null ||
        latitudeWarga == null ||
        longitudeWarga == null ||
        _initialCameraPosition == null) {
      return _buildFallbackMapImage();
    }

    return SizedBox(
      height: 300,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: GoogleMap(
          initialCameraPosition: _initialCameraPosition!,
          markers: _markers,
          onMapCreated: (controller) {
            _mapController = controller;
            // After map is created, fit the bounds
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _mapController?.animateCamera(
                CameraUpdate.newLatLngBounds(_getBounds(), 50.0),
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

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
