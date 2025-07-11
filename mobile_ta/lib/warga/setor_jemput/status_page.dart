import 'package:flutter/material.dart';
import 'package:mobile_ta/warga/histori_setor/kumpulan_histori_setor_page.dart';
import 'package:mobile_ta/widget/warga_main_widget.dart';

class WargaStatusTungguSetorJemput extends StatelessWidget {
  const WargaStatusTungguSetorJemput({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent.shade400,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Setor Jemput',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                const Text(
                  "Harap menunggu, petugas akan segera menerima dan menindaklanjuti pengajuan Anda.",
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                Icon(
                  Icons.watch_later_outlined,
                  size: 80,
                  color: Colors.greenAccent.shade700,
                ),
                const SizedBox(height: 16),
                const Text(
                  "Terima kasih telah peduli lingkungan 🌱",
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                /// Tombol Aksi
                _buildActionButton(
                  context,
                  icon: Icons.arrow_back,
                  label: "Kembali",
                  color: Colors.green.shade600,
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => WargaMainWrapper(initialMenu: 0),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 16),
                _buildActionButton(
                  context,
                  icon: Icons.history,
                  label: "List Histori",
                  color: Colors.orange,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => KumpulanHistoriSetorPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(icon),
        label: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onTap,
      ),
    );
  }
}
