import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_ta/pages/warga/akun_page.dart';
import 'package:mobile_ta/pages/warga/edukasi_page.dart';
import 'package:mobile_ta/pages/warga/setor_page.dart';
import 'package:mobile_ta/services/auth_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../pages/warga/beranda_page.dart';
import '../pages/warga/tambah_profil_page.dart';

class WargaMainWrapper extends StatefulWidget {
  final int initialMenu;
  const WargaMainWrapper({Key? key, this.initialMenu = 0}) : super(key: key);

  @override
  State<WargaMainWrapper> createState() => _WargaMainWrapperState();
}

class _WargaMainWrapperState extends State<WargaMainWrapper> {
  int selectedMenu = 0;
  Map<String, dynamic>? akunData;
  Map<String, dynamic>? profilData;
  Map<String, dynamic>? saldoData;

  List<dynamic> artikelList = [];
  List<dynamic> videoList = [];

  String? totalSampah;

  @override
  void initState() {
    super.initState();
    selectedMenu = widget.initialMenu;
    checkInitialData();
  }

  Future<void> loadAkunData() async {
    final data = await fetchAkunData();
    setState(() {
      akunData = data;
    });
  }

  Future<void> loadTotalSampah() async {
    try {
      final response = await http.get(
        Uri.parse('${dotenv.env['URL']}/total-berat'),
      );
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          totalSampah = jsonData['data'];
        });
      } else {
        debugPrint('Gagal ambil total sampah: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error total sampah: $e');
    }
  }

  Future<void> loadSaldoData() async {
    final data = await fetchSaldoData();
    setState(() {
      saldoData = data;
    });
  }

  bool isLoading = true;
  bool profilDitemukan = false;

  Future<void> checkInitialData() async {
    await loadAkunData();

    await cekProfil();
    // Jika profil ditemukan, baru load saldo
    if (profilDitemukan) {
      await loadSaldoData();
      await loadArtikel();
      await loadVideo();
      await loadTotalSampah();
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> loadArtikel() async {
    try {
      final response = await http.get(
        Uri.parse('${dotenv.env['URL']}/artikel/terbaru'),
      );
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          artikelList = jsonData['data'];
        });
      }
    } catch (e) {
      debugPrint('Gagal load artikel: $e');
    }
  }

  Future<void> loadVideo() async {
    try {
      final response = await http.get(
        Uri.parse('${dotenv.env['URL']}/video/terbaru'),
      );
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          videoList = jsonData['data'];
        });
      }
    } catch (e) {
      debugPrint('Gagal load video: $e');
    }
  }

  Future<void> cekProfil() async {
    final authService = AuthService();
    final token = await authService.getToken();

    if (token == null) {
      debugPrint('Token tidak ditemukan saat cek profil');
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('${dotenv.env['URL']}/profil'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        setState(() {
          profilDitemukan = true;
          profilData = json['data'];
        });
      } else if (response.statusCode == 401) {
        // Token expired, try refresh
        final refreshed = await authService.refreshToken();
        if (refreshed) {
          await cekProfil(); // Retry
        } else {
          setState(() {
            profilDitemukan = false;
          });
        }
      } else if (response.statusCode == 404) {
        setState(() {
          profilDitemukan = false;
        });
      } else {
        debugPrint('Gagal cek profil: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error cek profil: $e');
    }
  }

  Future<Map<String, dynamic>?> fetchAkunData() async {
    final authService = AuthService();
    final token = await authService.getToken();

    if (token == null) {
      debugPrint('Token tidak ditemukan');
      return null;
    }

    final response = await http.get(
      Uri.parse('${dotenv.env['URL']}/akun'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    } else if (response.statusCode == 401) {
      // Token expired, try refresh
      final refreshed = await authService.refreshToken();
      if (refreshed) {
        return fetchAkunData(); // Retry
      }
      return null;
    } else {
      debugPrint('Gagal ambil data akun: ${response.body}');
      return null;
    }
  }

  Future<Map<String, dynamic>?> fetchSaldoData() async {
    final authService = AuthService();
    final token = await authService.getToken();

    if (token == null) {
      debugPrint('Token tidak ditemukan');
      return null;
    }

    final response = await http.get(
      Uri.parse('${dotenv.env['URL']}/saldo'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    } else if (response.statusCode == 401) {
      // Token expired, try refresh
      final refreshed = await authService.refreshToken();
      if (refreshed) {
        return fetchSaldoData();
      }
      return null;
    } else {
      debugPrint('Gagal ambil data akun: ${response.body}');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!profilDitemukan) {
      return const WargaTambahProfilPage(); // redirect ke tambah profil jika tidak ditemukan
    }

    List<Widget> menu = [
      WargaBerandaPage(
        akunData: akunData,
        profilData: profilData,
        saldoData: saldoData,
        artikelList: artikelList,
        videoList: videoList,
        totalSampah: totalSampah,
      ),
      WargaSetorPage(profilData: profilData),
      WargaEdukasiPage(
        akunData: akunData,
        artikelList: artikelList,
        videoList: videoList,
      ),
      WargaAkunPage(
        akunData: akunData,
        profilData: profilData,
        saldoData: saldoData,
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: menu.elementAtOrNull(selectedMenu),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedMenu,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.black,
        backgroundColor: Colors.grey.shade200,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            selectedMenu = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.recycling), label: 'Setor'),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Edukasi',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Akun'),
        ],
      ),
    );
  }
}
