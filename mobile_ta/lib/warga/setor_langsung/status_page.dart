import 'package:flutter/material.dart';
import 'package:mobile_ta/widget/warga_main_widget.dart';

class WargaStatusTungguSetorLangsung extends StatelessWidget {
  const WargaStatusTungguSetorLangsung({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent.shade400,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Setor Langsung',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // const SizedBox(height: 32),
                // // Icon atau animasi loading
                // const CircularProgressIndicator(
                //   color: Colors.green,
                //   strokeWidth: 4,
                // ),
                const SizedBox(height: 32),

                // Judul status
                const Text(
                  "Pengajuan Sedang Diproses",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),

                // Deskripsi
                const Text(
                  "Harap menunggu, petugas akan segera menerima dan menindaklanjuti pengajuan Anda.",
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40),

                // Ilustrasi opsional (bisa pakai Lottie juga jika mau lebih interaktif)
                Icon(
                  Icons.watch_later_outlined,
                  size: 80,
                  color: Colors.greenAccent.shade700,
                ),
                const SizedBox(height: 16),

                const Text(
                  "Terima kasih telah peduli lingkungan 🌱",
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14),
                ),

                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent.shade700,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WargaMainWrapper(),
                        ), // atau sesuai rute kamu
                      );
                    },
                    icon: const Icon(Icons.arrow_back),
                    label: const Text(
                      "Kembali",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
