import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_ta/pages/petugas/petugas_akun_page.dart';
import 'package:mobile_ta/pages/petugas/petugas_konten_page.dart';
import 'package:mobile_ta/pages/petugas/petugas_setor_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../pages/petugas/beranda_page.dart';
import '../pages/petugas/petugas_tambah_profil_page.dart';

class PetugasMainWrapper extends StatefulWidget {
  final int initialMenu;
  const PetugasMainWrapper({Key? key, this.initialMenu = 0}) : super(key: key);

  @override
  State<PetugasMainWrapper> createState() => _WargaMainWrapperState();
}

class _WargaMainWrapperState extends State<PetugasMainWrapper> {
  int selectedMenu = 0;
  Map<String, dynamic>? akunData;
  Map<String, dynamic>? profilData;
  List<dynamic> artikelList = [];
  List<dynamic> videoList = [];
  List<dynamic> setorTerbaruList = [];

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

  bool isLoading = true;
  bool profilDitemukan = false;

  Future<void> checkInitialData() async {
    await loadAkunData();
    await cekProfil();
    if (profilDitemukan) {
      await loadArtikel();
      await loadVideo();
      await loadSetorTerbaru();
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> loadArtikel() async {
    try {
      final response = await http.get(Uri.parse('${dotenv.env['URL']}/artikel/terbaru'));
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
      final response = await http.get(Uri.parse('${dotenv.env['URL']}/video/terbaru'));
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

  Future<void> loadSetorTerbaru() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      debugPrint('Token tidak ditemukan');
      return;
    }
    try {
      final response = await http.get(
        Uri.parse('${dotenv.env['URL']}/setor-baru'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          setorTerbaruList = jsonData['data'];
        });
      }
    } catch (e) {
      debugPrint('Gagal load setor terbaru: $e');
    }
  }

  Future<void> cekProfil() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      debugPrint('Token tidak ditemukan saat cek profil');
      return;
    }

    final response = await http.get(
      Uri.parse('${dotenv.env['URL']}/profil'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      profilDitemukan = true;
      profilData = json['data'];
    } else if (response.statusCode == 404) {
      profilDitemukan = false;
    } else {
      debugPrint('Gagal cek profil: ${response.body}');
    }
  }

  Future<Map<String, dynamic>?> fetchAkunData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      debugPrint('Token tidak ditemukan');
      return null;
    }

    final response = await http.get(
      Uri.parse('${dotenv.env['URL']}/akun'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['data'];
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
      return const PetugasTambahProfilPage(); // redirect ke tambah profil jika tidak ditemukan
    }
    List menu = [
      PetugasBerandaPage(
        akunData: akunData,
        profilData: profilData,
        artikelList: artikelList,
        videoList: videoList,
        setorTerbaruList: setorTerbaruList,
      ),
      PetugasSetorPage(),
      PetugasKontenPage(artikelList: artikelList, videoList: videoList),
      PetugasAkunPage(akunData: akunData, profilData: profilData),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: menu[selectedMenu],
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
