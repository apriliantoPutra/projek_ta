import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_ta/pages/warga/histori_setor/setor_langsung/histori_setor_baru_langsung_page.dart';

class HistoriSetorCardLangsungBaru extends StatelessWidget {
  final Map<String, dynamic> data;

  const HistoriSetorCardLangsungBaru({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final waktuPengajuan = data['waktu_pengajuan'];
    final catatan = data['catatan_petugas'];
    final tanggal =
        waktuPengajuan != null
            ? DateFormat(
              'EEEE, dd-MM-yyyy',
              'id_ID',
            ).format(DateTime.parse(waktuPengajuan))
            : "-";

    return Container(
      width: width * 0.95,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xff8fd14f),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Informasi utama
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Setor Langsung",
                style: TextStyle(
                  fontSize: width * 0.045,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 4),
              Text(
                tanggal,
                style: TextStyle(fontSize: width * 0.035, color: Colors.white),
              ),
            ],
          ),
          // Icon panah ke kanan
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => HistoriSetorBaruLangsungPage(
                        id: data['id'],
                        tanggal: tanggal,
                        catatan: catatan,
                      ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
