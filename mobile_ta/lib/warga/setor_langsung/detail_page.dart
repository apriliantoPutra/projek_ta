import 'package:flutter/material.dart';
import 'package:mobile_ta/warga/setor_langsung/status_page.dart';

class WargaDetailSetorLangsung extends StatefulWidget {
  const WargaDetailSetorLangsung({super.key});

  @override
  State<WargaDetailSetorLangsung> createState() =>
      _WargaDetailSetorLangsungState();
}

class _WargaDetailSetorLangsungState extends State<WargaDetailSetorLangsung> {
  final String tanggal = "29/05/2025";
  final String lokasi = "Bank Sampah Kecamatan Tembalang";
  final String catatan =
      "Mohon datang sesuai jadwal dan membawa sampah yang sudah dipilah.";

  final String namaBank = "Bank Sampah Tembalang Berseri";
  final String deskripsiBank =
      "Tempat pengelolaan sampah ramah lingkungan dengan sistem tabungan.";
  final String alamatBank = "Jl. Tembalang Raya No.12, Semarang";
  final String mapUrl =
      "https://maps.googleapis.com/maps/api/staticmap?center=-7.05055837482239,110.44114708764991&zoom=16&size=600x300&markers=color:red%7C-7.05055837482239,110.44114708764991&key=YOUR_API_KEY";

  final String namaAdmin = "Ahmad Fathoni";
  final String emailAdmin = "ahmad@example.com";
  final String noHpAdmin = "0812-3456-7890";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent.shade400,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Setor Langsung',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Informasi Input User
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.greenAccent.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Detail Penyetoran",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text("Tanggal: $tanggal"),
                Text("Lokasi: $lokasi"),
                Text("Catatan: $catatan"),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Informasi Bank Sampah
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Informasi Bank Sampah",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  "Nama: $namaBank",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text("Deskripsi: $deskripsiBank"),
                const SizedBox(height: 4),
                Text("Alamat: $alamatBank"),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    mapUrl,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) =>
                            const Text("Gagal memuat peta"),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Informasi Admin
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.greenAccent.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Kontak Admin",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text("Nama: $namaAdmin"),
                Text("Email: $emailAdmin"),
                Text("No HP: $noHpAdmin"),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Tombol Konfirmasi
          ElevatedButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const WargaStatusTungguSetorLangsung(),
                ),
                (Route<dynamic> route) => false, // menghapus semua histori
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.greenAccent.shade400,
              padding: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "Konfirmasi Setoran",
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
