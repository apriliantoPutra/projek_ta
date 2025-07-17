import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mobile_ta/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widget/warga_main_widget.dart';

class WargaTarikSaldoPage extends StatefulWidget {
  final Map<String, dynamic>? saldo;
  final String no_hp;
  final int permintaanSaldo;
  const WargaTarikSaldoPage({
    required this.no_hp,
    required this.saldo,
    required this.permintaanSaldo,
    super.key,
  });

  @override
  State<WargaTarikSaldoPage> createState() => _WargaTarikSaldoPageState();
}

class _WargaTarikSaldoPageState extends State<WargaTarikSaldoPage> {
  int? selectedSaldo;
  String? metodeTarik;
  final TextEditingController pesanController = TextEditingController();
  final TextEditingController rekeningController = TextEditingController();
  bool isLoading = false;

  String formatRupiah(int number) {
    return NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(number);
  }

  void handleMetodeChange(String? value) {
    setState(() {
      metodeTarik = value;
      if (value == 'Dana' || value == 'ShopeePay') {
        rekeningController.text = widget.no_hp.toString();
      } else {
        rekeningController.clear();
      }
    });
  }

  bool get isRekeningValid {
    if (metodeTarik == 'Dana' || metodeTarik == 'ShopeePay') {
      return rekeningController.text == widget.no_hp.toString();
    }
    return rekeningController.text.isNotEmpty;
  }

  Future<void> storePengajuanSetorLangsung() async {
    setState(() {
      isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Token tidak ditemukan. Silakan login ulang.')),
      );
      return;
    }

    final url = Uri.parse("$baseUrl/pengajuan-tarik-saldo");
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'jumlah_saldo': selectedSaldo,
          'metode': metodeTarik,
          'nomor_tarik_saldo': rekeningController.text,
          'pesan': pesanController.text,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              responseData['message'] ??
                  'Berhasil mengirim Permintaan Tarik Saldo',
            ),
          ),
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const WargaMainWrapper(initialMenu: 3),
          ),
          (Route<dynamic> route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'] ?? 'Gagal mengirim')),
        );
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Terjadi kesalahan, coba lagi.')));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final int totalSaldo = widget.saldo?['total_saldo'] ?? 0;
    final bool saldoCukup = totalSaldo >= 20000;

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
          'Tarik Saldo',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Info Saldo
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                border: Border.all(color: Colors.green.shade200),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Saldo Anda Saat Ini:",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.green.shade800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    formatRupiah(totalSaldo),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade900,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Permintaan ini akan dikirim ke Admin. Mohon tunggu sampai Admin menyetujui dan melakukan proses transfer.",
                    style: TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                ],
              ),
            ),

            // 🔹 Metode tarik saldo
            const Text("Metode Tarik Saldo:", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: metodeTarik,
              hint: const Text("Pilih Metode"),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
              ),
              items:
                  ['Dana', 'ShopeePay', 'BNI', 'BCA'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
              onChanged: (newValue) {
                setState(() {
                  metodeTarik = newValue;
                  if (metodeTarik == 'Dana' || metodeTarik == 'ShopeePay') {
                    rekeningController.text =
                        widget.no_hp.toString(); // Konversi int ke String
                  } else {
                    rekeningController.clear();
                  }
                });
              },
            ),

            const SizedBox(height: 16),

            // 🔹 Input No Rekening / No HP
            const Text(
              "Nomor Rekening / No HP:",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: rekeningController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText:
                    metodeTarik == null
                        ? 'Isi setelah memilih metode'
                        : metodeTarik == 'Dana' || metodeTarik == 'ShopeePay'
                        ? 'Gunakan/ubah No HP Anda'
                        : 'Masukkan No Rekening',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 🔹 Pilih jumlah saldo
            const Text("Pilih Jumlah Saldo:", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            if (!saldoCukup)
              ElevatedButton(
                onPressed: null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade300,
                ),
                child: const Text("Saldo di atas Rp.5000"),
              )
            else
              Wrap(
                spacing: 10,
                children: [
                  for (int value in [totalSaldo ~/ 2, totalSaldo])
                    ElevatedButton(
                      onPressed:
                          (widget.permintaanSaldo + value <= totalSaldo)
                              ? () => setState(() => selectedSaldo = value)
                              : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            selectedSaldo == value
                                ? Colors.green
                                : (widget.permintaanSaldo + value <= totalSaldo
                                    ? Colors.grey.shade300
                                    : Colors
                                        .grey
                                        .shade200), // Lebih pucat kalau disabled
                        foregroundColor:
                            (widget.permintaanSaldo + value <= totalSaldo)
                                ? Colors.black
                                : Colors.grey,
                      ),
                      child: Text(formatRupiah(value)),
                    ),
                ],
              ),

            const SizedBox(height: 20),

            // 🔹 Pesan Opsional
            const Text("Pesan (Opsional):", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            TextField(
              controller: pesanController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Tulis pesan tambahan di sini...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 20),
            // 🔹 Kirim Permintaan
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    saldoCukup &&
                            selectedSaldo != null &&
                            metodeTarik != null &&
                            isRekeningValid
                        ? storePengajuanSetorLangsung
                        : null,

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  "Kirim Permintaan Tarik Saldo",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
