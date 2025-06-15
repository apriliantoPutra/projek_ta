import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_ta/constants/constants.dart';
import 'package:mobile_ta/petugas/petugas_setor_langsung_baru.dart';
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
  late Future<List<dynamic>> _setorLangsungBaruList;
  late Future<List<dynamic>> _setorLangsungSelesaiList;
  late Future<List<dynamic>> _setorJemputBaruList;

  Future<List<dynamic>> fetchSetorLangsungBaru() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      debugPrint('Token tidak ditemukan');
      return [];
    }
    final response = await http.get(
      Uri.parse('$baseUrl/setor-langsung/baru'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData['data'];
    } else {
      throw Exception('Gagal memuat data setor langsung baru');
    }
  }

  Future<List<dynamic>> fetchSetorLangsungSelesai() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      debugPrint('Token tidak ditemukan');
      return [];
    }
    final response = await http.get(
      Uri.parse('$baseUrl/setor-langsung/selesai'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData['data'];
    } else {
      throw Exception('Gagal memuat data setor langsung baru');
    }
  }

  Future<List<dynamic>> fetchSetorJemputBaru() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      debugPrint('Token tidak ditemukan');
      return [];
    }
    final response = await http.get(
      Uri.parse('$baseUrl/setor-jemput/baru'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData['data'];
    } else {
      throw Exception('Gagal memuat data setor jemput baru');
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _setorLangsungBaruList = fetchSetorLangsungBaru();
    _setorLangsungSelesaiList = fetchSetorLangsungSelesai();

    _setorJemputBaruList = fetchSetorJemputBaru();
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
                      child: Text("Setor Langsung"),
                    ),
                  ),
                  Tab(
                    child: Container(
                      height: 40,
                      alignment: Alignment.center,
                      child: Text("Setor Jemput"),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildSetorLangsung(), _buildSetorJemput()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSetorLangsung() {
    return FutureBuilder<List<List<dynamic>>>(
      future: Future.wait([_setorLangsungBaruList, _setorLangsungSelesaiList]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Terjadi kesalahan saat memuat data"));
        }

        final baruData = snapshot.data?[0] ?? [];
        final selesaiData = snapshot.data?[1] ?? [];

        return SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              _buildSection(
                "Setor Terbaru",
                baruData.isNotEmpty
                    ? baruData
                        .map((data) => SetorCardLangsungBaru(data: data))
                        .toList()
                    : [
                      Container(
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
                                "Tidak ada data setor langsung baru",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
              ),
              SizedBox(height: 16),
              _buildSection(
                "Setor Selesai",
                selesaiData.isNotEmpty
                    ? selesaiData
                        .map((data) => SetorCardLangsungSelesai(data: data))
                        .toList()
                    : [
                      Container(
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
                                "Belum ada setor langsung yang selesai",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSetorJemput() {
    return FutureBuilder<List<dynamic>>(
      future: _setorJemputBaruList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Gagal memuat data"));
        }

        final dataList = snapshot.data ?? [];

        return SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              _buildSection(
                "Setor Terbaru",
                dataList.isNotEmpty
                    ? dataList
                        .map((data) => SetorCardJemputBaru(data: data))
                        .toList()
                    : [
                      Container(
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
                                "Tidak ada data setor jemput baru",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
              ),
              SizedBox(height: 16),
              _buildSection("Setor Proses", [
                SetorCardJemputProses(),
                SetorCardJemputProses(),
              ]),
              SizedBox(height: 16),
              _buildSection("Setor Selesai", [SetorCardJemputSelesai()]),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSection(String title, List<Widget> cards) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
              Text(
                "Lainnya",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ],
          ),
          SizedBox(height: 8),
          Column(children: cards),
        ],
      ),
    );
  }
}
