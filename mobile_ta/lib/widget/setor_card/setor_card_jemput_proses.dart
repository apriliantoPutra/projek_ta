import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_ta/petugas/petugas_setor_jemput_proses.dart';

class SetorCardJemputProses extends StatelessWidget {
  final Map<String, dynamic> data;
  const SetorCardJemputProses({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    final waktuPengajuan = data['waktu_pengajuan'];
    final tanggal =
        waktuPengajuan != null
            ? DateFormat('EEEE, dd-MM-yyyy', 'id_ID') // format lengkap + lokal
            .format(DateTime.parse(waktuPengajuan))
            : "-";
    final profil = data['user']?['profil'];
    final gambarPengguna =
        (profil != null && (profil['gambar_pengguna'] ?? '').isNotEmpty)
            ? profil['gambar_url']
            : 'https://i.pinimg.com/736x/8a/e9/e9/8ae9e92fa4e69967aa61bf2bda967b7b.jpg';

    final namaPengguna = profil['nama_pengguna'] ?? 'memuat..';

    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Color(0xff8fd14f),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 6), // Jarak antar box
        padding: EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 10,
        ), // Jarak antara border dan konten
        decoration: BoxDecoration(
          color: Color(0xFF8fd14f),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center, // Avatar di tengah
          children: [
            CircleAvatar(
              radius: 20, // Perbesar avatar
              backgroundImage: NetworkImage(gambarPengguna),
            ),
            SizedBox(width: 10), // Jarak antara avatar dan teks
            Column(
              mainAxisAlignment: MainAxisAlignment.center, // Teks di tengah
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  namaPengguna,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "Setor Jemput",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Spacer(), // Memberi jarak fleksibel antara teks dan tanggal
            Text(
              tanggal,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white, // Mengubah warna teks menjadi putih
              ),
            ),
            SizedBox(width: 5), // Jarak sebelum icon
            IconButton(
              icon: Icon(
                Icons.arrow_forward,
                color: Colors.white,
              ), // Arah kanan
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => PetugasSetorJemputProses(id: data['id']),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
