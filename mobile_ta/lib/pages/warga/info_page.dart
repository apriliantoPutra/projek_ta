import 'package:flutter/material.dart';

class WargaInfoPage extends StatelessWidget {
  const WargaInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.greenAccent.shade400,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Info Aplikasi',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            'Tentang Aplikasi',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Aplikasi Bank Sampah adalah solusi digital yang memudahkan warga dalam melakukan penyetoran sampah kepada petugas bank sampah.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 12),
          const Text(
            'Terdapat dua metode penyetoran sampah:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          const Text(
            "• Setor Langsung: Warga membawa sampah ke lokasi bank sampah.",
          ),
          const Text(
            "• Setor Jemput: Petugas akan menjemput sampah dari rumah warga.",
          ),
          const SizedBox(height: 24),

          const Text(
            'Fitur Utama',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 12),
          _buildFeatureItem(
            Icons.home,
            'Beranda',
            'Menampilkan informasi dan status terbaru.',
          ),
          _buildFeatureItem(
            Icons.recycling,
            'Setor Sampah',
            'Ajukan setor sampah secara langsung atau dijemput.',
          ),
          _buildFeatureItem(
            Icons.article,
            'Edukasi Artikel',
            'Baca artikel tentang pengelolaan sampah.',
          ),
          _buildFeatureItem(
            Icons.ondemand_video,
            'Edukasi Video',
            'Tonton video edukatif tentang lingkungan.',
          ),
          _buildFeatureItem(
            Icons.account_circle,
            'Akun',
            'Kelola profil dan pengaturan akun Anda.',
          ),
          const SizedBox(height: 24),

          const Text(
            'Cara Penggunaan',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 12),
          _buildStepItem(1, 'Masuk ke aplikasi menggunakan akun Anda.'),
          _buildStepItem(2, 'Buka menu “Setor Sampah” di halaman utama.'),
          _buildStepItem(3, 'Pilih jenis setor: langsung atau jemput.'),
          _buildStepItem(4, 'Isi detail pengajuan dan kirim.'),
          _buildStepItem(
            5,
            'Pantau status pengajuan melalui menu "histori" pada beranda.',
          ),
          _buildStepItem(
            6,
            'Setelah statusnya selesai maka saldo akan terisi otomatis',
          ),
          const SizedBox(height: 32),

          const Center(
            child: Text(
              "Versi Aplikasi: 1.0.0",
              style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String subtitle) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: Colors.green.shade100,
        child: Icon(icon, color: Colors.green.shade700),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
    );
  }

  Widget _buildStepItem(int number, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$number. ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text(description)),
        ],
      ),
    );
  }
}
