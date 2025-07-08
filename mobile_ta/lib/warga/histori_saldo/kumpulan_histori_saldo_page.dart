import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_ta/constants/constants.dart';
import 'package:mobile_ta/widget/histori/tarik_saldo_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KumpulanHistoriSaldoPage extends StatefulWidget {
  const KumpulanHistoriSaldoPage({super.key});

  @override
  State<KumpulanHistoriSaldoPage> createState() =>
      _KumpulanHistoriSaldoPageState();
}

class _KumpulanHistoriSaldoPageState extends State<KumpulanHistoriSaldoPage> {
  late Future<List<dynamic>> _historiTarikSaldoList;

  Future<List<dynamic>> fetchHistoriTarikSaldo() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      debugPrint('Token tidak ditemukan');
      return [];
    }
    final response = await http.get(
      Uri.parse('$baseUrl/histori-tarik-saldo'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData['data'];
    } else {
      throw Exception('Gagal memuat data histori tarik saldo');
    }
  }

  @override
  void initState() {
    super.initState();
    _historiTarikSaldoList = fetchHistoriTarikSaldo();
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
          'Histori Tarik Saldo',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _historiTarikSaldoList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return _buildEmptyState('Terjadi kesalahan saat memuat data.');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildEmptyState('Belum ada histori penarikan saldo.');
          } else {
            final data = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: data.length,
              itemBuilder: (context, index) {
                final item = data[index];
                return TarikSaldoCard(data: item);
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          const Icon(Icons.inbox, size: 36, color: Colors.grey),
          const SizedBox(width: 12),
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
