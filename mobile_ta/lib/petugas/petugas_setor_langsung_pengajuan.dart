import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PetugasSetorLangsungPengajuan extends StatefulWidget {
  final Map<String, dynamic> data;

  const PetugasSetorLangsungPengajuan({required this.data, super.key});

  @override
  State<PetugasSetorLangsungPengajuan> createState() =>
      _PetugasSetorLangsungPengajuanState();
}

class _PetugasSetorLangsungPengajuanState
    extends State<PetugasSetorLangsungPengajuan> {
  @override
  Widget build(BuildContext context) {
    final data = widget.data;

    final tanggal = data['waktu_pengajuan'] != null
        ? DateFormat('dd/MM/yyyy')
            .format(DateTime.parse(data['waktu_pengajuan']))
        : "-";

    final catatan = data['catatan_petugas'] ?? "-";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent.shade400,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
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
                Text("Catatan: $catatan"),
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
              children: const [
                Text(
                  "Kontak Admin",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 8),
                Text("Nama: Nama Pengguna"),
                Text("Email: warga@gmail.com"),
                Text("No HP: +6285290672780"),
              ],
            ),
          ),

          const SizedBox(height: 32),

          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent.shade200,
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    // TODO: aksi batalkan
                  },
                  child: const Text(
                    "Batalkan Setoran",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent.shade400,
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    // TODO: aksi konfirmasi
                  },
                  child: const Text(
                    "Konfirmasi Setoran",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
