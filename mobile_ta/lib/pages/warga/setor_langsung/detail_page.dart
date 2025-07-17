import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mobile_ta/constants/constants.dart';
import 'package:mobile_ta/pages/warga/setor_langsung/status_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WargaDetailSetorLangsung extends StatefulWidget {
  final String tanggal;
  final String? catatan;
  const WargaDetailSetorLangsung({
    Key? key,
    required this.tanggal,
    this.catatan,
  }) : super(key: key);

  @override
  State<WargaDetailSetorLangsung> createState() =>
      _WargaDetailSetorLangsungState();
}

class _WargaDetailSetorLangsungState extends State<WargaDetailSetorLangsung> {
  Map<String, dynamic>? bankSampah;
  String namaBank = 'Memuat...';
  String deskripsiBank = 'Memuat...';
  String alamatBank = 'Memuat...';
  String namaAdmin = 'Memuat...';
  String emailAdmin = 'Memuat...';
  String noHpAdmin = 'Memuat...';
  double? latitudeBankSampah;
  double? longitudeBankSampah;
  GoogleMapController? _mapController;
  CameraPosition? _initialCameraPosition;
  Set<Marker> _markers = {};

  bool isLoading = false;
  String? formattedDate;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() => isLoading = true);

    try {
      // Parse date first
      try {
        final inputDate = DateFormat('dd/MM/yyyy').parse(widget.tanggal);
        formattedDate = DateFormat('yyyy-MM-dd').format(inputDate);
      } catch (e) {
        formattedDate = null;
        debugPrint('Date parse error: $e');
      }

      await fetchBankSampah();
      await _updateBankData();
      _updateMarkers();
    } catch (e) {
      debugPrint('Error in fetchData: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal memuat data bank sampah')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> _updateBankData() async {
    if (bankSampah == null) return;

    setState(() {
      namaBank = bankSampah?['nama_bank_sampah'] ?? 'Tidak tersedia';
      deskripsiBank = bankSampah?['deskripsi_bank_sampah'] ?? 'Tidak tersedia';
      alamatBank = bankSampah?['alamat_bank_sampah'] ?? 'Tidak tersedia';
      namaAdmin =
          bankSampah?['user']?['profil']?['nama_pengguna'] ?? 'Tidak tersedia';
      emailAdmin = bankSampah?['user']?['email'] ?? 'Tidak tersedia';
      noHpAdmin =
          bankSampah?['user']?['profil']?['no_hp_pengguna'] ?? 'Tidak tersedia';

      // Parse coordinates with better error handling
      latitudeBankSampah = _parseCoordinate(bankSampah?['latitude']);
      longitudeBankSampah = _parseCoordinate(bankSampah?['longitude']);

      if (latitudeBankSampah != null && longitudeBankSampah != null) {
        _initialCameraPosition = CameraPosition(
          target: LatLng(latitudeBankSampah!, longitudeBankSampah!),
          zoom: 15,
        );
      }
    });
  }

  double? _parseCoordinate(dynamic coordinate) {
    if (coordinate == null) return null;
    if (coordinate is double) return coordinate;
    if (coordinate is int) return coordinate.toDouble();
    if (coordinate is String) return double.tryParse(coordinate);
    return null;
  }

  void _updateMarkers() {
    if (latitudeBankSampah == null || longitudeBankSampah == null) return;

    setState(() {
      _markers = {
        Marker(
          markerId: const MarkerId('bank_sampah_location'),
          position: LatLng(latitudeBankSampah!, longitudeBankSampah!),
          infoWindow: InfoWindow(title: namaBank),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      };
    });

    // Move camera after a slight delay to ensure map is ready
    Future.delayed(const Duration(milliseconds: 300), () {
      _mapController?.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(latitudeBankSampah!, longitudeBankSampah!),
        ),
      );
    });
  }

  Future<void> fetchBankSampah() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        debugPrint('Token tidak ditemukan');
        return;
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
        if (responseData['data'] != null) {
          setState(() {
            bankSampah = responseData['data'];
          });
        }
      } else {
        debugPrint('Failed to fetch bank sampah: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error in fetchBankSampah: $e');
      rethrow;
    }
  }

  Future<void> storePengajuanSetorLangsung() async {
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

    final url = Uri.parse("$baseUrl/setor-langsung");
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
              builder: (context) => const WargaStatusTungguSetorLangsung(),
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
          'Setor Langsung',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Informasi Input User
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.greenAccent.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Detail Penyetoran",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text("Tanggal: ${widget.tanggal}"),
                Text("Catatan: ${widget.catatan ?? "-"}"),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Informasi Bank Sampah
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Informasi Bank Sampah",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  "Nama: $namaBank",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text("Deskripsi: $deskripsiBank"),
                const SizedBox(height: 4),
                Text("Alamat: $alamatBank"),
                const SizedBox(height: 12),
                _buildMapImage(),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Informasi Admin
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.greenAccent.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Kontak Admin",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text("Nama: $namaAdmin"),
                Text("Email: $emailAdmin"),
                Text("No HP: $noHpAdmin"),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Tombol Konfirmasi
          ElevatedButton(
            onPressed: isLoading ? null : storePengajuanSetorLangsung,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.greenAccent.shade400,
              padding: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child:
                isLoading
                    ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 2,
                      ),
                    )
                    : const Text(
                      "Konfirmasi Setoran",
                      style: TextStyle(fontSize: 16),
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapImage() {
    // Check if coordinates are valid
    if (latitudeBankSampah == null ||
        longitudeBankSampah == null ||
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
            // After map is created, move to bank sampah position
            _mapController?.animateCamera(
              CameraUpdate.newLatLng(
                LatLng(latitudeBankSampah!, longitudeBankSampah!),
              ),
            );
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
