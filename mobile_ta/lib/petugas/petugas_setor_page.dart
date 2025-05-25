import 'dart:ffi';

import 'package:flutter/material.dart';
import '../widget/setor_card.dart';

class PetugasSetorPage extends StatefulWidget {
  @override
  _PetugasSetorPageState createState() => _PetugasSetorPageState();
}

class _PetugasSetorPageState extends State<PetugasSetorPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildSection("Setor Terbaru", [SetorCard(), SetorCard()]),
          _buildSection("Setor Proses", [SetorCard()]),
          _buildSection("Setor Selesai", [SetorCard()]),
        ],
      ),
    );
  }

  Widget _buildSetorJemput() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildSection("Setor Terbaru", [SetorCard(), SetorCard()]),
          _buildSection("Setor Proses", [SetorCard(), SetorCard()]),
          _buildSection("Setor Selesai", [SetorCard()]),
        ],
      ),
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
