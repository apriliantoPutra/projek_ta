import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_ta/constants/constants.dart'; // pastikan baseUrl ada di sini

class DetailHistoriSaldoPage extends StatefulWidget {
  final int id;
  const DetailHistoriSaldoPage({required this.id, super.key});

  @override
  State<DetailHistoriSaldoPage> createState() => _DetailHistoriSaldoPageState();
}

class _DetailHistoriSaldoPageState extends State<DetailHistoriSaldoPage> {
  Map<String, dynamic>? data;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchDetailHistoriTarikSaldo();
  }

  Future<void> fetchDetailHistoriTarikSaldo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        setState(() {
          errorMessage = 'Token tidak ditemukan';
          isLoading = false;
        });
        return;
      }

      final response = await http.get(
        Uri.parse('$baseUrl/histori-tarik-saldo/${widget.id}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          data = jsonData['data'];
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Gagal memuat data histori tarik saldo';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Terjadi kesalahan: $e';
        isLoading = false;
      });
    }
  }

  String formatCurrency(int amount) {
    final format = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp. ',
      decimalDigits: 0,
    );
    return format.format(amount);
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'menunggu':
        return Colors.orange;
      case 'terima':
        return Colors.green;
      default:
        return Colors.black;
    }
  }

  String formatMetode(String metode) {
    final lower = metode.toLowerCase();
    if (lower == 'dana' || lower == 'shopeepay') {
      return 'E-Wallet (${_capitalize(metode)})';
    } else if (lower == 'bni' || lower == 'bca') {
      return 'Transfer Bank (${metode.toUpperCase()})';
    }
    return _capitalize(metode);
  }

  String _capitalize(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1).toLowerCase();
  }

  Widget _buildRow(String title, String value, {Color? valueColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            color: valueColor ?? Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
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
          'Detail Tarik Saldo',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: _buildRow(
                              'Jumlah Saldo',
                              formatCurrency(data!['jumlah_saldo']),
                            ),
                          ),
                          const Divider(),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: _buildRow(
                              'Status',
                              data!['status'] ?? 'Tidak diketahui',
                              valueColor: getStatusColor(data!['status'] ?? ''),
                            ),
                          ),
                          const Divider(),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: _buildRow(
                              'Metode',
                              formatMetode(data!['metode'] ?? ''),
                            ),
                          ),
                          const Divider(),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: _buildRow(
                              'Nomor Tarik Saldo',
                              data!['nomor_tarik_saldo'] ?? '-',
                            ),
                          ),
                          const Divider(),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: _buildRow(
                              'Pesan',
                              data!['pesan'] ?? 'Tidak ada pesan!',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
    );
  }
}
