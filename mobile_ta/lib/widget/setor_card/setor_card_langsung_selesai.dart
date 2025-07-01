import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_ta/petugas/setor_langsung/petugas_setor_langsung_selesai.dart';

class SetorCardLangsungSelesai extends StatelessWidget {
  final Map<String, dynamic> data;
  const SetorCardLangsungSelesai({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final waktuPengajuan = data['waktu_pengajuan'];
    final tanggal =
        waktuPengajuan != null
            ? DateFormat(
              'EEEE, dd-MM-yyyy',
              'id_ID',
            ).format(DateTime.parse(waktuPengajuan))
            : "-";

    final profil = data['user']?['profil'];
    final gambarPengguna =
        (profil != null && (profil['gambar_pengguna'] ?? '').isNotEmpty)
            ? profil['gambar_url']
            : 'https://i.pinimg.com/736x/8a/e9/e9/8ae9e92fa4e69967aa61bf2bda967b7b.jpg';

    final namaPengguna = profil['nama_pengguna'] ?? 'memuat..';

    return Container(
      width: width * 0.95,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xff8fd14f),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: width * 0.07, // Responsif
            backgroundImage: NetworkImage(gambarPengguna),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  namaPengguna,
                  style: TextStyle(
                    fontSize: width * 0.045, // ~18
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "Setor Langsung",
                  style: TextStyle(
                    fontSize: width * 0.040,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            children: [
              Text(
                tanggal,
                style: TextStyle(fontSize: width * 0.035, color: Colors.white),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              PetugasSetorLangsungSelesai(id: data['id']),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
