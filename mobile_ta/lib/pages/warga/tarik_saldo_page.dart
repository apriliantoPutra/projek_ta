import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
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

    final url = Uri.parse("${dotenv.env['URL']}/pengajuan-tarik-saldo");
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
        backgroundColor: const Color(0xFF128d54),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Tarik Saldo',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 22,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.green.withOpacity(0.10),
                blurRadius: 16,
                offset: Offset(0, 6),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Icon(
                  Icons.account_balance_wallet_rounded,
                  color: Color(0xFF128d54),
                  size: 48,
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  "Saldo Anda Saat Ini",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Color(0xFF128d54),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Center(
                child: Text(
                  formatRupiah(totalSaldo),
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF128d54),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  "Permintaan ini akan dikirim ke Admin. Mohon tunggu sampai Admin menyetujui dan melakukan proses transfer.",
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),

              Text(
                "Metode Tarik Saldo:",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: metodeTarik,
                hint: Text("Pilih Metode", style: GoogleFonts.poppins()),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
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
                        child: Text(value, style: GoogleFonts.poppins()),
                      );
                    }).toList(),
                onChanged: handleMetodeChange,
              ),
              const SizedBox(height: 16),

              Text(
                "Nomor Rekening / No HP:",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
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
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintStyle: GoogleFonts.poppins(),
                ),
                style: GoogleFonts.poppins(),
              ),
              const SizedBox(height: 16),

              Text(
                "Pilih Jumlah Saldo:",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              if (!saldoCukup)
                ElevatedButton(
                  onPressed: null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade300,
                    foregroundColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Saldo minimal Rp.20.000",
                    style: GoogleFonts.poppins(),
                  ),
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
                                  ? Color(0xFF128d54)
                                  : (widget.permintaanSaldo + value <=
                                          totalSaldo
                                      ? Colors.grey.shade300
                                      : Colors.grey.shade200),
                          foregroundColor:
                              selectedSaldo == value
                                  ? Colors.white
                                  : Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: selectedSaldo == value ? 2 : 0,
                        ),
                        child: Text(
                          formatRupiah(value),
                          style: GoogleFonts.poppins(),
                        ),
                      ),
                  ],
                ),
              const SizedBox(height: 20),

              Text(
                "Pesan (Opsional):",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: pesanController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Tulis pesan tambahan di sini...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintStyle: GoogleFonts.poppins(),
                ),
                style: GoogleFonts.poppins(),
              ),
              const SizedBox(height: 20),

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
                    backgroundColor: Color(0xFF128d54),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    "Kirim Permintaan Tarik Saldo",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
