import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_ta/constants/constants.dart';
import 'package:mobile_ta/petugas/setor_langsung/petugas_setor_langsung_baru.dart';
import 'package:mobile_ta/petugas/petugas_setor_langsung_pengajuan.dart';
import 'package:mobile_ta/widget/setor_card/setor_card_jemput_baru.dart';
import 'package:mobile_ta/widget/setor_card/setor_card_jemput_proses.dart';
import 'package:mobile_ta/widget/setor_card/setor_card_jemput_selesai.dart';
import 'package:mobile_ta/widget/setor_card/setor_card_langsung_selesai.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widget/setor_card/setor_card_langsung_baru.dart';

class PetugasSetorPage extends StatefulWidget {
  @override
  _PetugasSetorPageState createState() => _PetugasSetorPageState();
}

class _PetugasSetorPageState extends State<PetugasSetorPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Data
  late Future<List<dynamic>> _setorBaruList;
  late Future<List<dynamic>> _setorProsesList;
  late Future<List<dynamic>> _setorSelesaiList;

  Future<List<dynamic>> fetchSetorBaru() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      debugPrint('Token tidak ditemukan');
      return [];
    }
    final response = await http.get(
      Uri.parse('$baseUrl/setor-baru'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData['data'];
    } else {
      throw Exception('Gagal memuat data setor baru');
    }
  }

  Future<List<dynamic>> fetchSetorProses() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      debugPrint('Token tidak ditemukan');
      return [];
    }
    final response = await http.get(
      Uri.parse('$baseUrl/setor-proses'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData['data'];
    } else {
      throw Exception('Gagal memuat data setor proses');
    }
  }

  Future<List<dynamic>> fetchSetorSelesai() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      debugPrint('Token tidak ditemukan');
      return [];
    }
    final response = await http.get(
      Uri.parse('$baseUrl/setor-selesai'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData['data'];
    } else {
      throw Exception('Gagal memuat data setor selesai');
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _setorBaruList = fetchSetorBaru();
    _setorProsesList = fetchSetorProses();
    _setorSelesaiList = fetchSetorSelesai();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Daftar Setor Sampah",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black,
            fontSize: 24,
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              decoration: BoxDecoration(
                // color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: Color(0xff8fd14f),
                  borderRadius: BorderRadius.circular(12),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                labelStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                tabs: [
                  Tab(
                    child: Container(
                      height: 40,
                      alignment: Alignment.center,
                      child: Text("Setor Baru"),
                    ),
                  ),
                  Tab(
                    child: Container(
                      height: 40,
                      alignment: Alignment.center,
                      child: Text("Setor Proses"),
                    ),
                  ),
                  Tab(
                    child: Container(
                      height: 40,
                      alignment: Alignment.center,
                      child: Text("Setor Selesai"),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildSetorBaru(),
                _buildSetorProses(),
                _buildSetorSelesai(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSetorBaru() {
    return FutureBuilder<List<List<dynamic>>>(
      future: Future.wait([_setorBaruList]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Terjadi kesalahan saat memuat data"));
        }

        final baruData = snapshot.data?[0] ?? [];

        return SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              _buildSection(
                "Setor Terbaru",
                baruData.isNotEmpty
                    ? baruData.map<Widget>((data) {
                      final jenisSetor =
                          data['jenis_setor']?.toString()?.toLowerCase();
                      if (jenisSetor == 'setor langsung') {
                        return SetorCardLangsungBaru(data: data);
                      } else if (jenisSetor == 'setor jemput') {
                        return SetorCardJemputBaru(data: data);
                      } else {
                        return SizedBox.shrink(); // fallback jika jenis_setor tidak dikenali
                      }
                    }).toList()
                    : [
                      _buildEmptyState(
                        "Belum ada setoran langsung/jemput baru",
                      ),
                    ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSetorProses() {
    return FutureBuilder<List<dynamic>>(
      future: Future.wait([_setorProsesList]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Gagal memuat data"));
        }

        final baruList = snapshot.data?[0] ?? [];

        return SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              _buildSection(
                "Setor Proses",
                baruList.isNotEmpty
                    ? List<Widget>.from(
                      baruList.map((data) => SetorCardJemputProses(data: data)),
                    )
                    : [_buildEmptyState("Tidak ada data setor proses")],
              ),
              SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSetorSelesai() {
    return FutureBuilder<List<List<dynamic>>>(
      future: Future.wait([_setorSelesaiList]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Terjadi kesalahan saat memuat data"));
        }

        final baruData = snapshot.data?[0] ?? [];

        return SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              _buildSection(
                "Setor Selesai",
                baruData.isNotEmpty
                    ? baruData.map<Widget>((data) {
                      final jenisSetor =
                          data['jenis_setor']?.toString()?.toLowerCase();
                      if (jenisSetor == 'setor langsung') {
                        return SetorCardLangsungSelesai(data: data);
                      } else if (jenisSetor == 'setor jemput') {
                        return SetorCardJemputSelesai(data: data);
                      } else {
                        return SizedBox.shrink(); // fallback jika jenis_setor tidak dikenali
                      }
                    }).toList()
                    : [
                      _buildEmptyState(
                        "Belum ada setoran langsung/jemput baru",
                      ),
                    ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSection(String title, List<Widget> cards) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              // Text(
              //   "Lainnya",
              //   style: TextStyle(fontSize: 16, color: Colors.black),
              // ),
            ],
          ),
          SizedBox(height: 8),
          Column(children: cards),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 12),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(Icons.inbox, size: 36, color: Colors.grey),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
            ),
          ),
        ],
      ),
    );
  }
}
